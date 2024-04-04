using System;
using System.Collections;
using Assembly_CSharp.Assets.Script.Simple.Asynchronous;

namespace Assembly_CSharp.Assets.Script.Simple.Execution
{
    public class CoroutineExecutor : AbstractExecutor, ICoroutineExecutor
    {
        public virtual void RunOnCoroutineNoReturn(IEnumerator routine)
        {
            Executors.RunOnCoroutineNoReturn(routine);
        }

        public virtual Asynchronous.IAsyncResult RunOnCoroutine(IEnumerator routine)
        {
            return Executors.RunOnCoroutine(routine);
        }

        public virtual Asynchronous.IAsyncResult RunOnCoroutine(Func<IPromise, IEnumerator> func)
        {
            return Executors.RunOnCoroutine(func);
        }

        public virtual IAsyncResult<TResult> RunOnCoroutine<TResult>(Func<IPromise<TResult>, IEnumerator> func)
        {
            return Executors.RunOnCoroutine(func);
        }

        public virtual IProgressResult<TProgress> RunOnCoroutine<TProgress>(Func<IProgressPromise<TProgress>, IEnumerator> func)
        {
            return Executors.RunOnCoroutine(func);
        }

        public virtual IProgressResult<TProgress, TResult> RunOnCoroutine<TProgress, TResult>(Func<IProgressPromise<TProgress, TResult>, IEnumerator> func)
        {
            return Executors.RunOnCoroutine(func);
        }
    }
}
