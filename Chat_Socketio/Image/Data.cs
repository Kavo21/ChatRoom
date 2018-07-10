using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel;

namespace Chat_Socketio
{
    /// <summary>
    /// 記得實作 INotifyPropertyChanged ，當資料變動可以即時更改UI
    /// 記得在Xmal Bing 資料
    /// </summary>
    public class Data:INotifyPropertyChanged 
    {
        /// <summary>
        /// 宣告 PropertyChangedEventHandler 物件
        /// </summary>
        public event PropertyChangedEventHandler PropertyChanged;

        private string message;   

        public string Message
        {
            get
            {
                return message;
            }
            set
            {
                message = value;
                NotifyPropertyChanged("Message");
            }
        }

        //NotifyPropertyChanged填入的字串是對應到XAML上要Binding的屬性名稱
        private void NotifyPropertyChanged(string propertyName)
        {
            if (PropertyChanged != null)
            {
                PropertyChanged(this, new PropertyChangedEventArgs(propertyName));
            }
        }
    }
}
