using System;

namespace Assembly_CSharp.Assets.Script.Simple
{
    public class DisposableBase : IDisposable
    {
        protected virtual void Dispose(bool disposing)
        {
        }

        ~DisposableBase()
        {
            Dispose(false);
        }

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }
    }
}

