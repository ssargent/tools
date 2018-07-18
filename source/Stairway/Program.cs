using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Reflection;
using System.Runtime.Versioning;
using System.IO;

namespace Stairway
{
    public class DocumentedAssemblyReference
    {
        public string AssemblyName { get; set; }
        public string ReferencedAssemblyName { get; set; }
    }
    class Program
    {
        static void Main(string[] args)
        {
            var data = CompileAssemblyReferences(args);

            data.ForEach(r =>
            {
                if(!String.IsNullOrEmpty(args[1]) && r.ReferencedAssemblyName.Contains(args[1]))
                    Console.WriteLine($"{r.AssemblyName} => {r.ReferencedAssemblyName}");
            });

            Console.ReadLine();
        }

        private static List<DocumentedAssemblyReference> CompileAssemblyReferences(string[] args)
        {
            var data = new List<DocumentedAssemblyReference>();

            if (!Directory.Exists(args[0]))
            {
                Console.Write($"The directory {args[0]} does not exist.  Please enter a valid directory.");
            }

            var files = Directory.GetFiles(args[0], "*.dll").ToList();

            files.ForEach(file =>
            {
                try
                {
                    var assembly = Assembly.LoadFrom(file);

                    var referenced = assembly.GetReferencedAssemblies().ToList();

                    referenced.ForEach(a =>
                    {
                        data.Add(new DocumentedAssemblyReference() { AssemblyName = assembly.FullName, ReferencedAssemblyName = a.FullName });
                    });
                }
                catch (BadImageFormatException) { }
                catch (Exception ex)
                {
                    throw ex;
                }
            });

            return data;
        }
    }
}
