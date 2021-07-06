using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
//using Wooting;

namespace WootingAHK
{
    public class KeyWatcher : IDisposable
    {
        //private readonly Thread _thread;
        private byte _currentValue = 0;
        private readonly dynamic _callback;
        //private (byte, byte) _rowColTuple;
        private int _scanCode;
        private readonly WorkerThread _callbackThread;

        public KeyWatcher(int scanCode, dynamic callback)
        {
            _callbackThread = new WorkerThread().Start();
            _callback = callback;
            //_rowColTuple = rowCol;
            _scanCode = scanCode;
            //_thread = new Thread(WatchFn);
            //_thread.Start();
        }

        public void OnKeyEvent(float value)
        {
            _callback(value);
        }

        public void Dispose()
        {
            //_thread.Abort();
            //_thread.Join();
        }
    }
}
