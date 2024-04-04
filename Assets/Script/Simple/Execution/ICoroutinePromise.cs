using UnityEngine;
using Assembly_CSharp.Assets.Script.Simple.Asynchronous;

namespace Assembly_CSharp.Assets.Script.Simple.Execution
{
    public interface ICoroutinePromise : IPromise
    {
        void AddCoroutine(Coroutine coroutine);
    }

    public interface ICoroutinePromise<TResult> : IPromise<TResult>, ICoroutinePromise
    {
    }

    public interface ICoroutineProgressPromise<TProgress> : IProgressPromise<TProgress>, ICoroutinePromise
    {
    }

    public interface ICoroutineProgressPromise<TProgress, TResult> : IProgressPromise<TProgress, TResult>, ICoroutineProgressPromise<TProgress>
    {
    }
}
