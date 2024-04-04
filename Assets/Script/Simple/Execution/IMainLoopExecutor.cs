using System;

namespace Assembly_CSharp.Assets.Script.Simple.Execution
{
    public interface IMainLoopExecutor
    {
        void RunOnMainThread(Action action, bool waitForExecution = false);

        TResult RunOnMainThread<TResult>(Func<TResult> func);
    }
}
