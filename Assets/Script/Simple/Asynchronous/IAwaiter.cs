using System.Runtime.CompilerServices;

namespace Assembly_CSharp.Assets.Script.Simple.Asynchronous
{
    public interface IAwaiter : ICriticalNotifyCompletion
    {
        bool IsCompleted { get; }

        void GetResult();
    }

    public interface IAwaiter<T> : ICriticalNotifyCompletion
    {
        bool IsCompleted { get; }

        T GetResult();
    }
}
