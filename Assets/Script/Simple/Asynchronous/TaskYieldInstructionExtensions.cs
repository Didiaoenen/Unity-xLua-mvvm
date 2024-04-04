using System.Threading.Tasks;

namespace Assembly_CSharp.Assets.Script.Simple.Asynchronous
{
    public static class TaskYieldInstructionExtensions
    {
        public static TaskYieldInstruction AsCoroutine(this Task task)
        {
            return new TaskYieldInstruction(task);
        }

        public static TaskYieldInstruction<T> AsCoroutine<T>(this Task<T> task)
        {
            return new TaskYieldInstruction<T>(task);
        }
    }
}