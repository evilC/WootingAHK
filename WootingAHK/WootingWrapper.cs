using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Wooting;

namespace WootingAHK
{
    public class WootingWrapper : IDisposable
    {
        private readonly ConcurrentDictionary<(byte, byte), KeyWatcher> _keyWatchers = new ConcurrentDictionary<(byte, byte), KeyWatcher>();

        public WootingWrapper()
        {
        }

        public KeyWatcher SubscribeKey(int scanCode, dynamic callback)
        {
            _CheckKeyCode(scanCode);
            var tuple = WootingCodeLookup.ScanCodeToRowCol[scanCode];
            return SubscribeKeyRowCol(tuple.Item1, tuple.Item2, callback);
        }

        public KeyWatcher SubscribeKeyRowCol(byte row, byte col, dynamic callback)
        {
            var tuple = (row, col);
            var keyWatcher = new KeyWatcher(tuple, callback);
            _keyWatchers.TryAdd(tuple, keyWatcher);
            return keyWatcher;
        }

        public void SetKeyRgb(int scanCode, byte red, byte green, byte blue)
        {
            _CheckKeyCode(scanCode);
            var tuple = WootingCodeLookup.ScanCodeToRowCol[scanCode];
            RGBControl._DirectSetKey(tuple.Item1, tuple.Item2, red, green, blue);
        }

        public void ResetKeyRgb(int scanCode)
        {
            _CheckKeyCode(scanCode);
            var tuple = WootingCodeLookup.ScanCodeToRowCol[scanCode];
            RGBControl.ResetKey(tuple.Item1, tuple.Item2);
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
            foreach (var keyWatcher in _keyWatchers.Values)
            {
                keyWatcher.Dispose();
                RGBControl.Reset();
            }
        }
    }
}
