using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Database.Components;

namespace Database.Component
{
    public class MigratePostgresql : IProgram
    {
        public string Name => "pgmigrate";

        public void Execute(string[] args)
        {
            Console.WriteLine("PostgreSQL Migrations");

            var connectionString = args[1];
            var migrationPath = args[2];

            var i = 0; 
            args.ToList().ForEach(s => Console.WriteLine($"Arg[{i++}] = {s}"));
        }

        public void Help()
        {
            Console.WriteLine("Usage: % database pgmigrate");
        }
    }
}
