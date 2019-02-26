using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WootingAHK;

namespace TestApp
{
    class Program
    {
        static void Main(string[] args)
        {
            var w = new WootingWrapper();

            w.SubscribeKey(30, new Action<int>((value) =>
            {
                Console.WriteLine("Subscription Value: " + value);
            }));
        }
    }
}
