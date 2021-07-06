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

            // 1 = Esc key
            w.SubscribeAnalog(1, new Action<float>((value) =>
            {
                Console.WriteLine("Subscription Value: " + value);
            }));
        }
    }
}
