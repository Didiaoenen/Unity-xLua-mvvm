using XLua;
using System;
using System.IO;
using UnityEngine;
using Assembly_CSharp.Assets.Script.Simple;
using Assembly_CSharp.Assets.Script.Simple.Views;
using Assembly_CSharp.Assets.Script.Simple.LuaLoaders;

public class LuaTest : MonoBehaviour
{
    public ScriptReference script;

    private LuaTable scriptEnv;

    private LuaTable metatable;

    private Action<MonoBehaviour> onAwake;

    private Action<MonoBehaviour> onEnable;

    private Action<MonoBehaviour> onStart;

    private Action<MonoBehaviour> onUpdate;

    private Action<MonoBehaviour> onDisable;

    private Action<MonoBehaviour> onDestroy;

    private void Awake()
    {
        var luaEnv = LuaEnvironment.LuaEnv;
#if UNITY_EDITOR
        foreach (var dir in Directory.GetDirectories(Application.dataPath, "LuaScripts", SearchOption.AllDirectories))
        {
            luaEnv.AddLoader(new FileLoader(dir, ".lua"));
            luaEnv.AddLoader(new FileLoader(dir, ".lua.txt"));
        }
#endif

        InitLauEnv();
    }

    void InitLauEnv()
    {
        var luaEnv = LuaEnvironment.LuaEnv;
        scriptEnv = luaEnv.NewTable();

        var meta = luaEnv.NewTable();
        meta.Set("__index", luaEnv.Global);
        scriptEnv.SetMetaTable(meta);
        meta.Dispose();

        string scriptText = (script.Type == ScriptReferenceType.TextAsset) ? script.Text.text : string.Format("require(\"Game.{0}\");", script.Filename);
        luaEnv.DoString(scriptText, script.Filename, scriptEnv);

        onAwake = scriptEnv.Get<Action<MonoBehaviour>>("Awake");
        onEnable = scriptEnv.Get<Action<MonoBehaviour>>("Enable");
        onStart = scriptEnv.Get<Action<MonoBehaviour>>("Start");
        onUpdate = scriptEnv.Get<Action<MonoBehaviour>>("Update");
        onDisable = scriptEnv.Get<Action<MonoBehaviour>>("Disbale");
        onDestroy = scriptEnv.Get<Action<MonoBehaviour>>("Destroy");

        if (onAwake != null)
        {
            onAwake(this);
        }
    }

    private void Start()
    {
        if (onStart != null)
            onStart(this);
    }

    private void OnEnable()
    {
        if (onEnable != null)
            onEnable(this);
    }

    private void Update()
    {
        if (onUpdate != null)
            onUpdate(this);
    }

    void OnDisable()
    {
        if (onDisable != null)
            onDisable(this);
    }

    void OnDestroy()
    {
        if (onDestroy != null)
            onDestroy(this);

        onDestroy = null;
        onStart = null;
        onEnable = null;
        onDisable = null;
        onAwake = null;

        if (metatable != null)
        {
            metatable.Dispose();
            metatable = null;
        }

        if (scriptEnv != null)
        {
            scriptEnv.Dispose();
            scriptEnv = null;
        }
    }
}
