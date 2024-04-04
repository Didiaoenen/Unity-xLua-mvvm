using System;
using System.Threading;
using Assembly_CSharp.Assets.Script.Simple.Execution;

namespace Assembly_CSharp.Assets.Script.Simple.Asynchronous
{
    public class AsyncResult : IAsyncResult, IPromise
    {
        private bool done = false;

        private object result = null;

        private Exception exception = null;

        private bool cancelled = false;

        protected bool cancelable = false;

        protected bool cancellationRequested;

        protected readonly object _lock = new object();

        private Synchronizable synchronizable;

        private Callbackable callbackable;

        public virtual Exception Exception { get { return exception; } }

        public virtual bool IsDone { get { return done; } }

        public virtual object Result { get { return result; } }

        public virtual bool IsCancellationRequested { get { return cancellationRequested; } }

        public virtual bool IsCancelled { get { return cancelled; } }

        public AsyncResult() : this(false)
        {
        }

        public AsyncResult(bool cancelable)
        {
            this.cancelable = cancelable;
        }

        public void SetException(string error)
        {
        }

        public void SetException(Exception exception)
        {
        }

        public void SetResult(object result = null)
        {
            lock (_lock)
            {
                if (done)
                    return;

                this.result = result;
                done = true;
                Monitor.PulseAll(_lock);
            }

            RaiseOnCallback();
        }

        public virtual void SetCancelled()
        {
            lock (_lock)
            {
                if (!cancelable || done)
                    return;

                cancelled = true;
                exception = new OperationCanceledException();
                done = true;
                Monitor.PulseAll(_lock);
            }

            RaiseOnCallback();
        }

        public virtual bool Cancel()
        {
            if (!cancelable)
                throw new NotSupportedException();

            if (IsDone)
                return false;

            cancellationRequested = true;
            SetCancelled();
            return true;
        }

        protected virtual void RaiseOnCallback()
        {
            if (callbackable != null)
                callbackable.RaiseOnCallback();
        }

        public virtual ICallbackable Callbackable()
        {
            lock (_lock)
            {
                return callbackable ?? (callbackable = new Callbackable(this));
            }
        }

        public virtual ISynchronizable Synchronized()
        {
            lock (_lock)
            {
                return synchronizable ?? (synchronizable = new Synchronizable(this, _lock));
            }
        }

        public virtual object WaitForDone()
        {
            return Executors.WaitWhile(() => !IsDone);
        }
    }

    public class AsyncResult<TResult> : AsyncResult, IAsyncResult<TResult>, IPromise<TResult>
    {
        private Synchronizable<TResult> synchronizable;

        private Callbackable<TResult> callbackable;

        public virtual new TResult Result
        {
            get
            {
                var result = base.Result;
                return result != null ? (TResult)result : default(TResult);
            }
        }

        public AsyncResult() : this(false)
        {
        }

        public AsyncResult(bool cancelable) : base(cancelable)
        {
        }

        public virtual void SetResult(TResult result)
        {
            base.SetResult(result);
        }

        protected override void RaiseOnCallback()
        {
            base.RaiseOnCallback();
            if (callbackable != null)
                callbackable.RaiseOnCallback();
        }

        public new virtual ICallbackable<TResult> Callbackable()
        {
            lock (_lock)
            {
                return callbackable ?? (callbackable = new Callbackable<TResult>(this));
            }
        }

        public new virtual ISynchronizable<TResult> Synchronized()
        {
            lock (_lock)
            {
                return synchronizable ?? (synchronizable = new Synchronizable<TResult>(this, _lock));
            }
        }
    }
}

