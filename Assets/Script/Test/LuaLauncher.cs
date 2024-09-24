/*
 * MIT License
 *
 * Copyright (c) 2018 Clark Yang
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of 
 * this software and associated documentation files (the "Software"), to deal in 
 * the Software without restriction, including without limitation the rights to 
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies 
 * of the Software, and to permit persons to whom the Software is furnished to do so, 
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all 
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE 
 * SOFTWARE.
 */

using System;
using System.IO;
using System.Text;
using UnityEngine;
using XLua;

using Loxodon.Log;
using Loxodon.Framework.Views;
using Loxodon.Framework.XLua.Loaders;

namespace Loxodon.Framework.Examples
{
    public class LuaLauncher : MonoBehaviour
    {
        //private static readonly ILog log = LogManager.GetLogger(typeof(LuaLauncher));

        public ScriptReference script;

        private LuaTable scriptEnv;
        private LuaTable metatable;
        private Action<MonoBehaviour> onAwake;
        private Action<MonoBehaviour> onEnable;
        private Action<MonoBehaviour> onDisable;
        private Action<MonoBehaviour> onStart;
        private Action<MonoBehaviour> onUpdate;
        private Action<MonoBehaviour> onDestroy;

        void Awake()
        {
            var luaEnv = LuaEnvironment.LuaEnv;
#if UNITY_EDITOR
            foreach (string dir in Directory.GetDirectories(Application.dataPath, "LuaScripts", SearchOption.AllDirectories))
            {
                luaEnv.AddLoader(new FileLoader(dir, ".lua"));
                luaEnv.AddLoader(new FileLoader(dir, ".lua.txt"));
            }
#else
            /* Pre-compiled and encrypted */
            //var decryptor = new RijndaelCryptograph(128,Encoding.ASCII.GetBytes("E4YZgiGQ0aqe5LEJ"), Encoding.ASCII.GetBytes("5Hh2390dQlVh0AqC"));
            //luaEnv.AddLoader( new DecodableLoader(new FileLoader(Application.streamingAssetsPath + "/LuaScripts/", ".bytes"), decryptor));
            //luaEnv.AddLoader( new DecodableLoader(new FileLoader(Application.persistentDataPath + "/LuaScripts/", ".bytes"), decryptor));

            /* Lua source code */
            luaEnv.AddLoader(new FileLoader(Application.streamingAssetsPath + "/LuaScripts/", ".bytes"));
            luaEnv.AddLoader(new FileLoader(Application.persistentDataPath + "/LuaScripts/", ".bytes"));
#endif



            InitLuaEnv();

            if (onAwake != null)
                onAwake(this);

        }

        void InitLuaEnv()
        {
            var luaEnv = LuaEnvironment.LuaEnv;
            scriptEnv = luaEnv.NewTable();

            LuaTable meta = luaEnv.NewTable();
            meta.Set("__index", luaEnv.Global);
            scriptEnv.SetMetaTable(meta);
            meta.Dispose();

            scriptEnv.Set("target", this);

            string scriptText = (script.Type == ScriptReferenceType.TextAsset) ? script.Text.text : string.Format("require(\"Game.{0}\");", script.Filename);
            luaEnv.DoString(scriptText, script.Filename, scriptEnv);

            onAwake = scriptEnv.Get<Action<MonoBehaviour>>("Awake");
            onEnable = scriptEnv.Get<Action<MonoBehaviour>>("Enable");
            onStart = scriptEnv.Get<Action<MonoBehaviour>>("Start");
            onUpdate = scriptEnv.Get<Action<MonoBehaviour>>("Update");
            onDisable = scriptEnv.Get<Action<MonoBehaviour>>("Disable");
            onDestroy = scriptEnv.Get<Action<MonoBehaviour>>("Destroy");
        }

        void OnEnable()
        {
            if (onEnable != null)
                onEnable(this);
        }

        void Update()
        {
            if (onUpdate != null)
                onUpdate(this);
        }

        void OnDisable()
        {
            if (onDisable != null)
                onDisable(this);
        }

        void Start()
        {
            if (onStart != null)
                onStart(this);
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
}