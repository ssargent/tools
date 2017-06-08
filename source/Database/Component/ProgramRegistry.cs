using System;
using System.Collections.Generic;
using System.IO;
using System.Reflection;
using System.Text;
using System.Linq;

namespace Database.Components
{
    public class ProgramRegistry
    {
        private class Nested
        {
            internal static readonly ProgramRegistry instance;

            static Nested()
            {
                ProgramRegistry.Nested.instance = new ProgramRegistry();
            }
        }

        public Dictionary<string, IProgram> Programs
        {
            get;
            set;
        }

        public static ProgramRegistry Instance
        {
            get
            {
                return ProgramRegistry.Nested.instance;
            }
        }

        private ProgramRegistry()
        {
            this.Programs = new Dictionary<string, IProgram>();
            var assembly = GetType().GetTypeInfo().Assembly;
            IEnumerable<IProgram> enumerable = Enumerable.Select<Type, IProgram>(Enumerable.Where<Type>(assembly.GetTypes(), (Type t) => Enumerable.Contains<Type>(t.GetInterfaces(), typeof(IProgram)) && t.GetConstructor(Type.EmptyTypes) != null), (Type t) => Activator.CreateInstance(t) as IProgram);
            using (IEnumerator<IProgram> enumerator = enumerable.GetEnumerator())
            {
                while (enumerator.MoveNext())
                {
                    IProgram current = enumerator.Current;
                    if (!this.Programs.ContainsKey(current.Name.ToLower()))
                    {
                        this.Programs.Add(current.Name.ToLower(), current);
                    }
                }
            }
        }

        public void Execute(string[] args)
        {
            if (this.Programs.ContainsKey(args[0].ToLower()))
            {
                this.Programs[args[0].ToLower()].Execute(args);
                return;
            }
            throw new ArgumentException("Program does not exists");
        }

        public IProgram Get(string programName)
        {
            IProgram result;
            if (this.Programs.ContainsKey(programName.ToLower()))
            {
                result = this.Programs[programName.ToLower()];
            }
            else
            {
                result = null;
            }
            return result;
        }
    }
}
