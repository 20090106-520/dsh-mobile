package com.deepseek.harness.mobile

import android.os.Bundle
import android.view.View
import android.view.inputmethod.EditorInfo
import android.widget.Toast
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.app.AppCompatActivity
import androidx.recyclerview.widget.DividerItemDecoration
import androidx.recyclerview.widget.LinearLayoutManager
import com.deepseek.harness.mobile.databinding.ActivityMainBinding
import com.deepseek.harness.mobile.databinding.DialogConnectionBinding
import com.deepseek.harness.mobile.databinding.ItemMessageBinding
import com.google.gson.Gson
import com.google.gson.annotations.SerializedName
import org.java_websocket.client.WebSocketClient
import org.java_websocket.drafts.Draft_6455
import org.java_websocket.handshake.ServerHandshake
import java.net.URI

class MainActivity : AppCompatActivity() {
    
    private lateinit var binding: ActivityMainBinding
    private lateinit var adapter: MessageAdapter
    private val messages = mutableListOf<Message>()
    
    private var wsClient: WebSocketClient? = null
    private var serverUrl = "ws://192.168.1.100:3081"
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)
        
        setupRecyclerView()
        setupListeners()
        loadSettings()
    }
    
    private fun setupRecyclerView() {
        adapter = MessageAdapter(messages) { position ->
            // TODO: 长按操作
        }
        binding.recyclerView.apply {
            layoutManager = LinearLayoutManager(this@MainActivity)
            adapter = this@MainActivity.adapter
            addItemDecoration(DividerItemDecoration(this@MainActivity, DividerItemDecoration.VERTICAL))
        }
    }
    
    private fun setupListeners() {
        binding.fabConfig.setOnClickListener { showConnectionDialog() }
        
        binding.sendBtn.setOnClickListener { sendMessage() }
        
        binding.messageInput.setOnEditorActionListener { v, actionId, event ->
            if (actionId == EditorInfo.IME_ACTION_SEND) {
                sendMessage()
                true
            } else {
                false
            }
        }
    }
    
    private fun loadSettings() {
        val prefs = getSharedPreferences("settings", MODE_PRIVATE)
        serverUrl = prefs.getString("server_url", "ws://192.168.1.100:3081") ?: serverUrl
        updateStatus()
    }
    
    private fun saveSettings() {
        val prefs = getSharedPreferences("settings", MODE_PRIVATE)
        prefs.edit().putString("server_url", serverUrl).apply()
    }
    
    private fun showConnectionDialog() {
        val dialogBinding = DialogConnectionBinding.inflate(layoutInflater)
        val dialog = AlertDialog.Builder(this)
            .setView(dialogBinding.root)
            .create()
        
        dialogBinding.etServerUrl.setText(serverUrl)
        
        dialogBinding.btnConnect.setOnClickListener {
            val url = dialogBinding.etServerUrl.text.toString().trim()
            if (url.isNotEmpty()) {
                serverUrl = url
                saveSettings()
                connectToServer()
                dialog.dismiss()
            } else {
                Toast.makeText(this, "请输入服务器地址", Toast.LENGTH_SHORT).show()
            }
        }
        
        dialogBinding.btnCancel.setOnClickListener { dialog.dismiss() }
        dialog.show()
    }
    
    private fun connectToServer() {
        updateStatus("连接中...")
        
        try {
            wsClient?.close()
            
            wsClient = object : WebSocketClient(URI(serverUrl), Draft_6455()) {
                override fun onOpen(handshakeRes: ServerHandshake?) {
                    runOnUiThread {
                        updateStatus("已连接")
                        addSystemMessage("已连接到 DSH 桌面端")
                    }
                }
                
                override fun onMessage(message: String?) {
                    message ?: return
                    try {
                        val data = Gson().fromJson(message, WebSocketMessage::class.java)
                        when (data?.type) {
                            "connected" -> {
                                runOnUiThread {
                                    addSystemMessage(data.message ?: "已连接")
                                }
                            }
                            "response" -> {
                                runOnUiThread {
                                    addMessage(Message(data.content ?: "", isUser = false))
                                }
                            }
                            "typing" -> {
                                // 显示正在输入
                            }
                            "error" -> {
                                runOnUiThread {
                                    addSystemMessage("错误: ${data.message}")
                                }
                            }
                        }
                    } catch (e: Exception) {
                        runOnUiThread {
                            addSystemMessage("解析消息失败: ${e.message}")
                        }
                    }
                }
                
                override fun onClose(code: Int, reason: String?, remote: Boolean) {
                    runOnUiThread {
                        updateStatus("已断开")
                        addSystemMessage("连接已断开 (code: $code)")
                    }
                }
                
                override fun onError(ex: Exception?) {
                    runOnUiThread {
                        updateStatus("连接失败")
                        addSystemMessage("错误: ${ex?.message}")
                    }
                }
            }
            
            wsClient?.connect()
            
        } catch (e: Exception) {
            updateStatus("连接失败")
            addSystemMessage("连接错误: ${e.message}")
        }
    }
    
    private fun sendMessage() {
        val text = binding.messageInput.text.toString().trim()
        if (text.isEmpty() || wsClient?.isClosed == false) return
        
        addMessage(Message(text, isUser = true))
        binding.messageInput.text.clear()
        
        val msg = Gson().toJson(WebSocketRequest("message", text))
        wsClient?.send(msg)
    }
    
    private fun addMessage(message: Message) {
        messages.add(message)
        adapter.notifyItemInserted(messages.size - 1)
        binding.recyclerView.scrollToPosition(messages.size - 1)
    }
    
    private fun addSystemMessage(text: String) {
        messages.add(Message(text, isUser = false, isSystem = true))
        adapter.notifyItemInserted(messages.size - 1)
        binding.recyclerView.scrollToPosition(messages.size - 1)
    }
    
    private fun updateStatus(text: String = "未连接") {
        binding.statusText.text = text
        binding.fabConfig.visibility = if (text.contains("已连接")) View.GONE else View.VISIBLE
    }
    
    override fun onDestroy() {
        super.onDestroy()
        wsClient?.close()
    }
}

data class Message(
    val content: String,
    val isUser: Boolean = false,
    val isSystem: Boolean = false
)

data class WebSocketMessage(
    val type: String?,
    val content: String? = null,
    val message: String? = null,
    val id: String? = null
)

data class WebSocketRequest(
    val type: String,
    val content: String
)

class MessageAdapter(
    private val messages: List<Message>,
    private val onLongClick: ((Int) -> Unit)? = null
) : androidx.recyclerview.widget.RecyclerView.Adapter<MessageAdapter.ViewHolder>() {
    
    class ViewHolder(val binding: ItemMessageBinding) : androidx.recyclerview.widget.RecyclerView.ViewHolder(binding.root)
    
    override fun onCreateViewHolder(parent: android.view.ViewGroup, viewType: Int): ViewHolder {
        val binding = ItemMessageBinding.inflate(
            android.view.LayoutInflater.from(parent.context),
            parent,
            false
        )
        return ViewHolder(binding)
    }
    
    override fun onBindViewHolder(holder: ViewHolder, position: Int) {
        val message = messages[position]
        holder.binding.apply {
            if (message.isSystem) {
                tvMessage.text = message.content
                tvMessage.setTextColor(android.graphics.Color.parseColor("#888888"))
                cardView.setCardBackgroundColor(android.graphics.Color.TRANSPARENT)
                cardView.setStrokeWidth(0)
            } else {
                tvMessage.text = message.content
                tvMessage.setTextColor(
                    if (message.isUser) android.graphics.Color.WHITE
                    else android.graphics.Color.parseColor("#EEEEEE")
                )
                cardView.setCardBackgroundColor(
                    if (message.isUser) android.graphics.Color.parseColor("#E94560")
                    else android.graphics.Color.parseColor("#1A1A2E")
                )
                cardView.setStrokeWidth(0)
            }
        }
    }
    
    override fun getItemCount() = messages.size
}
