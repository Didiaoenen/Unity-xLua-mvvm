namespace Assembly_CSharp.Assets.Script.Simple.Asynchronous
{
    public interface IProgressResult<TProgress> : IAsyncResult
    {
        TProgress Progress { get; }

        new IProgressCallbackable<TProgress> Callbackable();
    }

    public interface IProgressResult<TProgress, TResult> : IAsyncResult<TResult>, IProgressResult<TProgress>
    {
        new IProgressCallbackable<TProgress, TResult> Callbackable();
    }
}

