using System;
using System.Collections.Generic;
using System.Text;

namespace Database.Components
{
    public interface IProgram
    {
        string Name
        {
            get;
        }

        void Execute(string[] args);

        void Help();
    }
}
