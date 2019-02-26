using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using Wooting;

namespace WootingAHK
{
    public class KeyWatcher : IDisposable
    {
        private readonly Thread _thread;
        private byte _currentValue = 0;
        private readonly dynamic _callback;
        private (byte, byte) _rowColTuple;

        public KeyWatcher((byte row, byte col) rowCol, dynamic callback)
        {
            _callback = callback;
            _rowColTuple = rowCol;
            _thread = new Thread(WatchFn);
            _thread.Start();
        }

        private void WatchFn()
        {
            while (true)
            {
                var val = AnalogReader.ReadAnalog(_rowColTuple.Item1, _rowColTuple.Item2);
                if (val != _currentValue)
                {
                    _currentValue = val;
                    ThreadPool.QueueUserWorkItem(cb => _callback(val));
                }
                Thread.Sleep(10);
            }

        }

        public void Dispose()
        {
            _thread.Abort();
            _thread.Join();
        }
    }
}
