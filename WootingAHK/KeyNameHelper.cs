using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading.Tasks;

namespace WootingAHK
{
    static class KeyNameHelper
    {
        [DllImport("user32", SetLastError = true, CharSet = CharSet.Unicode)]
        public static extern int GetKeyNameTextW(uint lParam, StringBuilder lpString, int nSize);

        public static string GetNameFromScanCode(int code)
        {
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
