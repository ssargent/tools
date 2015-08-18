using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace jsonvalidate
{
    class Program
    {
        protected static int ErrorCount { get; set; }
        static void Main(string[] args)
        {
            ErrorCount = 0;
            if (!Directory.Exists(args[0]))
            {
                Console.WriteLine("usage jsonvalidate 'path/to/folder'");
                return;
            }

            var jsonFiles = Directory.GetFiles(args[0], "*.json", SearchOption.AllDirectories).ToList();
            jsonFiles.ForEach(ParseFile);

            Console.WriteLine("{0} Files Checked, {1} Errors Found", jsonFiles.Count, ErrorCount);

        }

        static void ParseFile(string dataFile)
        {
            try
            {
                var filedata = File.ReadAllText(dataFile);
                JToken.Parse(filedata);
            }
            catch (Exception)
            {
                Console.WriteLine("Cannot Parse File {0}", dataFile);
                ErrorCount++;
            }
        }
    }
}
