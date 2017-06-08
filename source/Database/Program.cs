using Database.Components;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Database
{
    class Program
    {
        static void Main(string[] args)
        {
            if (args.Length < 1)
            {
                args = new string[]
                {
                    "buildscript"
                };
            }
            ProgramRegistry.Instance.Execute(args);
            Console.WriteLine("Completed");
        } 
    }
}
