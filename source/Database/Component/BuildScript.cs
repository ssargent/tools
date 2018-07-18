using System;
using System.Collections.Generic;
using System.IO;
using System.Reflection;
using System.Text;
using System.Linq;

namespace Database.Components
{
    public class BuildScript : IProgram
    {
        private bool PathRelativeToExe
        {
            get;
            set;
        }

        private string ExePath
        {
            get;
            set;
        }

        public string Name
        {
            get
            {
                return "buildscript";
            }
        }

        public void Execute(string[] args)
        {
            this.PathRelativeToExe = false;
            Enumerable.ToList<string>(args).ForEach(delegate (string arg)
            {
                if (arg == "-exerelative")
                {
                    this.PathRelativeToExe = true;
                }
            });
            this.ExePath = GetType().GetTypeInfo().Assembly.Location;
            StringBuilder stringBuilder = new StringBuilder();

            if (Directory.Exists(this.ComputePath("./schema")))
            {
                Console.WriteLine("Writing Schema Files");
                stringBuilder.Append(this.BuildScriptForDirectory(this.ComputePath("./schema"), "*.sql"));
                Console.WriteLine();
            }
            if (Directory.Exists(this.ComputePath("./functions")))
            {
                Console.WriteLine("Writing Functions");
                stringBuilder.Append(this.BuildScriptForDirectory(this.ComputePath("./functions"), "*.sql"));
                Console.WriteLine();
            }
            if (Directory.Exists(this.ComputePath("./procedures")))
            {
                Console.WriteLine("Writing Procedures");
                stringBuilder.Append(this.BuildScriptForDirectory(this.ComputePath("./procedures"), "*.sql"));
                Console.WriteLine();
            }
            if (Directory.Exists(this.ComputePath("./views")))
            {
                Console.WriteLine("Writing Views");
                stringBuilder.Append(this.BuildScriptForDirectory(this.ComputePath("./views"), "*.sql"));
                Console.WriteLine();
            }
            if (Directory.Exists(this.ComputePath("./data")))
            {
                Console.WriteLine("Writing Data");
                stringBuilder.Append(this.BuildScriptForDirectory(this.ComputePath("./data"), "*.sql"));
                Console.WriteLine();
            }
            if(Directory.Exists(this.ComputePath("./triggers")))
            {
                Console.WriteLine("Writing Triggers");
                stringBuilder.Append(this.BuildScriptForDirectory(this.ComputePath("./triggers"), "*.sql"));
                Console.WriteLine();
            }
            if (Directory.Exists(this.ComputePath("./assembly-scripts")))
            {
                Console.WriteLine("Writing Assemblies");
                stringBuilder.Append(this.BuildScriptForDirectory(this.ComputePath("./assembly-scripts"), "*.sql"));
                Console.WriteLine();
            }
            
            File.WriteAllText(this.ComputePath($"./updates_{DateTime.Now.Year}_{DateTime.Now.Month}_{DateTime.Now.Day}.sql"), stringBuilder.ToString());
        }

        public string ComputePath(string path)
        {
            string result;
            if (!this.PathRelativeToExe)
            {
                result = path;
            }
            else
            {
                DirectoryInfo parent = Directory.GetParent(this.ExePath);
                result = Path.Combine(parent.Parent.FullName, path);
            }
            return result;
        }

        public string BuildScriptForDirectory(string directoryPath, string extension = "*.sql")
        {
            List<string> list = Directory.GetFiles(directoryPath, extension).ToList();
            list.Sort();
            StringBuilder builder = new StringBuilder();
            builder.AppendLine(string.Format("-- Begin Files Found in {0}", directoryPath));
            list.ForEach(delegate (string filePath)
            {
                Console.WriteLine(filePath);
                builder.AppendLine(string.Format("-- included from file: {0}", filePath));
                builder.Append(File.ReadAllText(filePath));
                builder.AppendLine();
            });
            builder.AppendLine(string.Format("-- End Files Found in {0}", directoryPath));
            builder.AppendLine();
            return builder.ToString();
        }

        public void Help()
        {
            Console.WriteLine("Usage: % database buildscript");
        }
    }
}
