using System;
using Assembly_CSharp.Assets.Script.Simple.Asynchronous;

namespace Assembly_CSharp.Assets.Script.Simple.Execution
{
    public interface IScheduledExecutor : IDisposable
    {
        void Start();

        void Stop();

        IAsyncResult<TResult> Schedule<TResult>(Func<TResult> command, long delay);

        IAsyncResult<TResult> Schedule<TResult>(Func<TResult> command, TimeSpan delay);

        Asynchronous.IAsyncResult Schedule(Action command, long delay);

        Asynchronous.IAsyncResult Schedule(Action command, TimeSpan delay);

        Asynchronous.IAsyncResult ScheduleAtFixedRate(Action command, long initialDelay, long period);

        Asynchronous.IAsyncResult ScheduleAtFixedRate(Action command, TimeSpan initialDelay, TimeSpan period);

        Asynchronous.IAsyncResult ScheduleWithFixedDelay(Action command, long initialDelay, long delay);

        Asynchronous.IAsyncResult ScheduleWithFixedDelay(Action command, TimeSpan initialDelay, TimeSpan delay);
    }
}
