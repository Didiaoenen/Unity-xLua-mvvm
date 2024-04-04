namespace Assembly_CSharp.Assets.Script.Simple.Execution
{
    public abstract class AbstractExecutor
    {
        static AbstractExecutor()
        {
            Executors.Create();
        }
    }
}