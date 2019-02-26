using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WootingAHK
{
    public static class WootingCodeLookup
    {
        static WootingCodeLookup()
        {
            ScanCodeToRowCol = new Dictionary<int, (byte, byte)>();
            foreach (var mapping in RowColToScanCode)
            {
                ScanCodeToRowCol.Add(mapping.Value, mapping.Key);
            }
        }

        public static Dictionary<int, (byte, byte)> ScanCodeToRowCol;

        public static Dictionary<(byte, byte), int> RowColToScanCode = new Dictionary<(byte, byte), int>
        {
            // Row 0
            { (0, 0), 1 },      // Esc
            { (0, 2), 59 },      // F1
            { (0, 3), 60 },      // F2
            { (0, 4), 61 },      // F3
            { (0, 5), 62 },      // F4
            { (0, 6), 63 },      // F5
            { (0, 7), 64 },      // F6
            { (0, 8), 65 },      // F7
            { (0, 9), 66 },      // F8
            { (0, 10), 67 },      // F9
            { (0, 11), 68 },      // F10
            { (0, 12), 87 },      // F11
            { (0, 13), 88 },      // F12
            { (0, 14), 311 },   // PrtScr
            { (0, 15), 69 },   // Pause
            { (0, 16), 70 },   // ScrollLock

            // Row 1
            { (1, 0), 41 },      // `
            { (1, 1), 2 },      // 1
            { (1, 2), 3 },      // 2
            { (1, 3), 4 },      // 3
            { (1, 4), 5 },      // 4
            { (1, 5), 6 },      // 5
            { (1, 6), 7 },      // 6
            { (1, 7), 8 },      // 7
            { (1, 8), 9 },      // 8
            { (1, 9), 10 },      // 9
            { (1, 10), 11 },      // 0
            { (1, 11), 12 },      // -
            { (1, 12), 13 },      // +
            { (1, 13), 14 },      // Backspace
            { (1, 14), 338 },   // Insert
            { (1, 15), 327 },   // Home
            { (1, 16), 329 },   // PgUp
            { (1, 17), 325 },   // NumLock
            { (1, 18), 309 },   // Numpad /
            { (1, 19), 55 },   // Numpad *
            { (1, 20), 74 },   // Numpad -

            // Row 2
            { (2, 0), 15 },      // Tab
            { (2, 1), 16 },      // Q
            { (2, 2), 17 },      // W
            { (2, 3), 18 },      // E
            { (2, 4), 19 },      // R
            { (2, 5), 20 },      // T
            { (2, 6), 21 },      // Y
            { (2, 7), 22 },      // U
            { (2, 8), 23 },   // I
            { (2, 9), 24 },   // O
            { (2, 10), 25 },   // P
            { (2, 11), 26 },   // [
            { (2, 12), 27 },   // ]
            { (2, 14), 339 },   // Del
            { (2, 15), 335 },   // End
            { (2, 16), 337 },   // PgDn
            { (2, 17), 71 },   // Numpad 7
            { (2, 18), 72 },   // Numpad 8
            { (2, 19), 73 },   // Numpad 9
            { (2, 20), 78 },   // Numpad +

            // Row 3
            { (3, 0), 58 },      // CapsLock
            { (3, 1), 30 },      // A
            { (3, 2), 31 },      // S
            { (3, 3), 32 },      // D
            { (3, 4), 33 },      // F
            { (3, 5), 34 },      // G
            { (3, 6), 35 },      // H
            { (3, 7), 36 },      // J
            { (3, 8), 37 },   // K
            { (3, 9), 38 },   // L
            { (3, 10), 39 },   // ;
            { (3, 11), 40 },   // '
            { (3, 12), 43 },   // ISO #
            { (3, 13), 28 },   // Return
            { (3, 17), 75 },   // Numpad 4
            { (3, 18), 76 },   // Numpad 5
            { (3, 19), 77 },   // Numpad 6

            // Row 4
            { (4, 0), 42 },      // LShift
            { (4, 1), 86 },      // ISO \ |
            { (4, 2), 44 },      // Z
            { (4, 3), 45 },      // X
            { (4, 4), 46 },      // C
            { (4, 5), 47 },      // V
            { (4, 6), 48 },      // B
            { (4, 7), 49 },      // N
            { (4, 8), 50 },      // M
            { (4, 9), 51 },   // ,
            { (4, 10), 52 },   // .
            { (4, 11), 53 },   // /
            { (4, 13), 310 },   // RShift
            { (4, 15), 328 },   // Up Arrow
            { (4, 17), 79 },   // Numpad 1
            { (4, 18), 80 },   // Numpad 2
            { (4, 19), 81 },   // Numpad 3
            { (4, 20), 284 },   // Numpad Enter


            // Row 5
            { (5, 0), 29 },      // LCtrl
            { (5, 1), 91 },      // LWin
            { (5, 2), 56 },      // LAlt
            { (5, 6), 57 },      // Space
            { (5, 10), 312 },      // RAlt 56 + 256 Extended bit
            { (5, 11), 348 },      // RWin
            { (5, 13), 285 },      // RCtrl
            { (5, 14), 331 },   // Left Arrow
            { (5, 15), 336 },   // Down Arroww
            { (5, 16), 333 },   // Right Arrow
            { (5, 18), 82 },   // Numpad 0
            { (5, 19), 83 },   // Numpad .

        };
    }

    public class RowCol
    {
        public RowCol(int row, int col)
        {
            Row = row;
            Col = col;
        }
        public int Row { get; set; }
        public int Col { get; set; }
    }
}
