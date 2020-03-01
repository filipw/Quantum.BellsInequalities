using System;
using System.Threading.Tasks;
using Microsoft.Quantum.Simulation.Core;
using Microsoft.Quantum.Simulation.Simulators;

namespace BellsInequalities
{
    class Driver
    {
        static async Task Main (string[] args)
        {
            using var qsim = new QuantumSimulator();
            var p1 = await Run("P(a,b)", () => BellsInequalityA.Run(qsim));
            var p2 = await Run("P(a,c)", () => BellsInequalityB.Run(qsim));
            var p3 = await Run("P(b,c)", () => BellsInequalityC.Run(qsim));

            Console.WriteLine("|P(a,b)−P(a,c)| − P(b,c) ≤ 1, (if lower than 1, then EPR was right): " + (-(p1 - p2) - p3));
        }

        private static async Task<decimal> Run(string name, Func<Task<(bool, bool)>> test)
        {
            decimal runs = 100;
            decimal zerozero = 0;
            decimal zeroone = 0;
            decimal onezero = 0;
            decimal oneone = 0;

            for (var i = 0; i < runs; i++)
            {
                {
                    var received = await test();
                    if (received.Item1 == false && received.Item2 == false) zerozero++;
                    if (received.Item1 == false && received.Item2 == true) zeroone++;
                    if (received.Item1 == true && received.Item2 == false) onezero++;
                    if (received.Item1 == true && received.Item2 == true) oneone++;
                }
            }

            Console.WriteLine("|00> " + zerozero / runs);
            Console.WriteLine("|01> " + zeroone / runs);
            Console.WriteLine("|10> " + onezero / runs);
            Console.WriteLine("|11> " + oneone / runs);

            var p = (zerozero / runs + oneone / runs - zeroone / runs - onezero / runs);
            Console.WriteLine(name + ": " + p);
            Console.WriteLine();

            return p;
        }
    }
}