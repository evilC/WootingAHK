using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using WootingAnalogSDKNET;

//using Wooting;

namespace WootingAHK
{
    public class WootingWrapper : IDisposable
    {
        private readonly ConcurrentDictionary<int, KeyWatcher> _keyWatchers = new ConcurrentDictionary<int, KeyWatcher>();
        private Thread _workerThread;

        public WootingWrapper()
        {
            var (noDevices, error) = WootingAnalogSDK.Initialise();
            WootingAnalogSDK.SetKeycodeMode(KeycodeType.ScanCode1);
            // If the number of devices is at least 0 it indicates the initialisation was successful
            if (noDevices >= 0)
            {
                Console.WriteLine($"Analog SDK Successfully initialised with {noDevices} devices!");
            }
            else
            {
                Console.WriteLine($"Analog SDK failed to initialise: {error}");
            }
        }

        public KeyWatcher SubscribeAnalog(int scanCode, dynamic callback)
        {
            _CheckKeyCode(scanCode);
            //var tuple = WootingCodeLookup.ScanCodeToRowCol[scanCode];
            //return SubscribeKeyRowCol(tuple.Item1, tuple.Item2, callback);
            _workerThread = new Thread(WorkerThread);
            _workerThread.Start();
            return SubscribeKeyScanCode(scanCode, callback);
        }

        private void WorkerThread()
        {
            while (true)
            {
                var (keys, readErr) = WootingAnalogSDK.ReadFullBuffer(20);
                if (readErr == WootingAnalogResult.Ok)
                {
                    // Go through all the keys that were read and output them
                    foreach (var analog in keys)
                    {
                        //Console.Write($"({analog.Item1},{analog.Item2})");
                        if (_keyWatchers.ContainsKey(analog.Item1))
                        {
                            _keyWatchers[analog.Item1].OnKeyEvent(analog.Item2);
                        }
                    }
                }
                else
                {
                    Console.WriteLine($"Read failed with {readErr}");
                    // We want to put more of a delay in when we get an error as we don't want to spam the log with the errors
                    Thread.Sleep(1000);
                }
                Thread.Sleep(10);
            }
        }

        //public KeyWatcher SubscribeKeyRowCol(byte row, byte col, dynamic callback)
        //{
        //    var tuple = (row, col);
        //    var keyWatcher = new KeyWatcher(tuple, callback);
        //    _keyWatchers.TryAdd(tuple, keyWatcher);
        //    return keyWatcher;
        //}

        public KeyWatcher SubscribeKeyScanCode(int scanCode, dynamic callback)
        {
            var keyWatcher = new KeyWatcher(scanCode, callback);
            _keyWatchers.TryAdd(scanCode, keyWatcher);
            return keyWatcher;
        }

        public void SetKeyRgb(int scanCode, byte red, byte green, byte blue)
        {
            _CheckKeyCode(scanCode);
            var tuple = WootingCodeLookup.ScanCodeToRowCol[scanCode];
            //RGBControl._DirectSetKey(tuple.Item1, tuple.Item2, red, green, blue);
        }

        public void ResetKeyRgb(int scanCode)
        {
            _CheckKeyCode(scanCode);
            var tuple = WootingCodeLookup.ScanCodeToRowCol[scanCode];
            //RGBControl.ResetKey(tuple.Item1, tuple.Item2);
        }

        public RowCol GetKeyRowColFromScanCode(int scanCode)
        {
            _CheckKeyCode(scanCode);
            var tuple = WootingCodeLookup.ScanCodeToRowCol[scanCode];
            return new RowCol(tuple.Item1, tuple.Item2);
        }

        public int[] GetScanCodeList()
        {
            var list = WootingCodeLookup.ScanCodeToRowCol.Keys.ToList();
            list.Sort();
            return list.ToArray();
        }

        public string OkCheck()
        {
            return "OK";
        }

        private void _CheckKeyCode(int scanCode)
        {
            if (!WootingCodeLookup.ScanCodeToRowCol.ContainsKey(scanCode))
                throw new Exception($"Unknown Key ScanCode: {scanCode}");
        }

        public void Dispose()
        {
            //foreach (var keyWatcher in _keyWatchers.Values)
            //{
            //    keyWatcher.Dispose();
            //    //RGBControl.Reset();
            //}
            _workerThread.Abort();
            _workerThread.Join();
        }
    }
}
