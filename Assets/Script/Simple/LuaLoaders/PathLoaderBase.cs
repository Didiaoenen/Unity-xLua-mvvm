namespace Assembly_CSharp.Assets.Script.Simple.LuaLoaders
{
    public abstract class PathLoaderBase : LoaderBase
    {
        protected string prefix = string.Empty;

        protected string suffix = ".lua.txt";

        public PathLoaderBase(string prefix, string suffix)
        {
            this.prefix = prefix;
            if (!string.IsNullOrEmpty(prefix))
                this.prefix = prefix.Replace("\\", "/");

            if (!prefix.EndsWith("/"))
                this.prefix = prefix + "/";

            this.suffix = suffix;
        }

        protected virtual string GetFullName(string className)
        {
            return string.Format("{0}{1}{2}", prefix, className.Replace(".", "/"), suffix);
        }
    }
}

