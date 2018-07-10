# Chat_Socketio
透過 Socket.io 連接方式交換資料

# Installation 
C# 專案必須先安裝 SocketIoClientDotNet 套件
Nuget install:
Install-Package SocketIoClientDotNet

#事件
IO.Socket("http://localhost:3000/") 裡面需要填伺服器的網址，而伺服器也需要填寫相對應的傳送與接收事件
