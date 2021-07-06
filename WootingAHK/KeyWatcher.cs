using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace WootingAHK
{
    public class KeyWatcher : IDisposable
    {
        private readonly dynamic _callback;
        private int _scanCode;
        private readonly WorkerThread _callbackThread;

        public KeyWatcher(int scanCode, dynamic callback)
        {
            _callbackThread = new WorkerThread().Start();
            _callback = callback;
            _scanCode = scanCode;
        }

        public void OnKeyEvent(float value)
        {
            _callbackThread.Actions.Add(() => _callback(value));
        }

        public void Dispose()
        {
            _callbackThread.Dispose();
        }
    }
}
