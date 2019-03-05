using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;

namespace WootingAHK
{
    public static class KeyNameHelper
    {
        [DllImport("user32", SetLastError = true, CharSet = CharSet.Unicode)]
        private static extern int GetKeyNameTextW(uint lParam, StringBuilder lpString, int nSize);

        // GetKeyNameTextW does not seem to return names for these ScanCodes
        private static readonly Dictionary<int, string> MissingKeyNames = new Dictionary<int, string>
        {
            { 100, "F13" }, { 101, "F14" }, { 101, "F15" }, { 101, "F16" }, { 101, "F17" }, { 101, "F18" }, 
            { 101, "F19" }, { 101, "F20" }, { 101, "F21" }, { 101, "F22" }, { 101, "F23" }, { 101, "F24" }
        };

        public static string GetNameFromScanCode(int code)
        {
            if (MissingKeyNames.ContainsKey(code))
            {
                return MissingKeyNames[code];
            }
            code -= 1;
            uint lParam;
            if (code > 255)
            {
                code -= 256;
                lParam = (0x100 | ((uint)code + 1 & 0xff)) << 16;
            }
            else
            {
                lParam = (uint)(code + 1) << 16;
            }

            var sb = new StringBuilder(260);
            if (GetKeyNameTextW(lParam, sb, 260) == 0)
            {
                return null;
            }
            var keyName = sb.ToString().Trim();
            if (keyName == "") return null;
            return keyName;
        }
    }
}
