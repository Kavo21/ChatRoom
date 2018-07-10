using Quobject.SocketIoClientDotNet.Client;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace Chat_Socketio
{
    /// <summary>
    /// MainWindow.xaml 的互動邏輯
    /// </summary>
    public partial class MainWindow : Window
    {
        private string Message { get; set; }

        /// <summary>
        /// 連接到Socket.io
        /// </summary>
        private Sokcet_Connect sokcet_Connect = new Sokcet_Connect();

        /// <summary>
        /// /因為資料從伺服器發送下來，直接存取會有執行緒問題，所以需要委派
        /// </summary>
        private delegate void Update_Delegate(String data);

        private Data _data = new Data();

        public MainWindow()
        {
            InitializeComponent();

            sokcet_Connect.sendDataToClinet += UpdateView;

            //透過DataContext繫結資料
            //MessageView.DataContext = data;

            //this是視窗本身，由於TextBlock屬於視窗Windows階層之下,
            //所以都有繼承沿用Windows元件中的DataConext，都可以繫結到此data物件來源
            this.DataContext = _data;

        }

        private void UpdateView(String data)
        {
            //WPF的寫法，判斷是否為同一個執行續
            if (!Dispatcher.CheckAccess())
            {
                //如果不是就要用委派
                Dispatcher.Invoke(new Update_Delegate(UpdateView),data);
            }
            else
            {
                this._data.Message += DateTime.Now.ToShortTimeString() + " : " + data + Environment.NewLine;
            }
        }

        private void Room_Click(object sender, RoutedEventArgs e)
        {
            sokcet_Connect.JoinRoom(Room.Text.ToString());
        }

        private void Send_Click(object sender, RoutedEventArgs e)
        {
            if (!String.IsNullOrEmpty(InputText.Text.ToString()))
            {
                //向伺服器端，發送事件，並傳資料
                sokcet_Connect.SendDataToServer(Name.Text.ToString().Trim()+" : "+InputText.Text.ToString());

                //自己也要顯示
                this._data.Message += DateTime.Now.ToShortTimeString() + " : " + InputText.Text.ToString().Trim() + Environment.NewLine;

                //清空輸入
                InputText.Text = null;
            }
        }

        private void Window_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.Key == Key.Enter) {
                this.Send_Click(sender, new RoutedEventArgs());
            }
        }

        private void Window_Closing(object sender, System.ComponentModel.CancelEventArgs e)
        {
            sokcet_Connect.SocketDisconnect();
        }
    }
}
