using Quobject.SocketIoClientDotNet.Client;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;

namespace Chat_Socketio
{
   public class Sokcet_Connect
    {
        private Socket socket;

        /// <summary>
        /// 委派
        /// </summary>
        public delegate void SendDataToClinet(String data);

        /// <summary>
        /// 實體化委派
        /// </summary>
        public SendDataToClinet sendDataToClinet;

        public Sokcet_Connect()
        {
            //連接到伺服器網址
            socket = IO.Socket("http://localhost:3000/");

            //連接事件
            socket.On("Connection", (data) =>
            {
                sendDataToClinet.Invoke("連線成功");
            });

            //中斷連接事件
            socket.On("disconnect", (data) =>
            {
                sendDataToClinet.Invoke(data.ToString());
            });

            //接受伺服器發送下來的事件與資料
            socket.On("Chat message Room", (data) =>
            {
                sendDataToClinet.Invoke(data.ToString());
            });

            //接受伺服器發送下來的事件與資料
            socket.On("ChatRoomAdded", (data) =>
            {
                sendDataToClinet.Invoke(data.ToString());
            });
        }



        //加入房間
        public void JoinRoom(String room) {
            //向伺服器端，發送事件，並傳資料
            socket.Emit("CreateRoom", room);
        }

        //傳送資料
        public void SendDataToServer(String data) {

            //向伺服器端，發送事件，並傳資料
            socket.Emit("RoomMessage", data);
            //socket.Emit("RoomMessageIncludeMyself", data);
          
        }

        //中斷連接方法
        public void SocketDisconnect() {

            socket.Disconnect();
        }
    }
}
