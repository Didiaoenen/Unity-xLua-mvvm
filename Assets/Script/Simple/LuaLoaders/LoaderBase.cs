using XLua;

namespace Assembly_CSharp.Assets.Script.Simple.LuaLoaders
{
    public abstract class LoaderBase : DisposableBase
    {
        protected abstract byte[] Load(ref string path);

        public static implicit operator LuaEnv.CustomLoader(LoaderBase loader)
        {
            return loader.Load;
        }
    }
}

