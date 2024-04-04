using UnityEngine;
using System.Threading.Tasks;
using System.Runtime.ExceptionServices;

namespace Assembly_CSharp.Assets.Script.Simple.Asynchronous
{
    public class TaskYieldInstruction : CustomYieldInstruction
    {
        private readonly Task task;
        public TaskYieldInstruction(Task task)
        {
            this.task = task;
        }

        public override bool keepWaiting
        {
            get
            {
                if (task.Exception != null)
                    ExceptionDispatchInfo.Capture(task.Exception).Throw();

                return !task.IsCompleted;
            }
        }
    }

    public class TaskYieldInstruction<T> : CustomYieldInstruction
    {
        private readonly Task<T> task;
        public TaskYieldInstruction(Task<T> task)
        {
            this.task = task;
        }

        public override bool keepWaiting
        {
            get
            {
                if (task.Exception != null)
                    ExceptionDispatchInfo.Capture(task.Exception).Throw();

                return !task.IsCompleted;
            }
        }
    }
}