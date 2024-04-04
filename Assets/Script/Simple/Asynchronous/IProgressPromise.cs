namespace Assembly_CSharp.Assets.Script.Simple.Asynchronous
{
    public interface IProgressPromise<TProgress> : IPromise
    {
        TProgress Progress { get; }

        void UpdateProgress(TProgress progress);
    }

    public interface IProgressPromise<TProgress, TResult> : IProgressPromise<TProgress>, IPromise<TResult>
    {
    }
}

