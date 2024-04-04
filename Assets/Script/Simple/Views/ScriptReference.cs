using System;
using UnityEngine;
using Object = UnityEngine.Object;

namespace Assembly_CSharp.Assets.Script.Simple.Views
{
    public enum ScriptReferenceType
    {
        TextAsset,
        FileName
    }

    [Serializable]
    public class ScriptReference : ISerializationCallbackReceiver
    {
#if UNITY_EDITOR
        [SerializeField]
        private Object cachedAsset;
#endif

        [SerializeField]
        protected TextAsset text;

        [SerializeField]
        protected string filename;

        [SerializeField]
        protected ScriptReferenceType type = ScriptReferenceType.TextAsset;

        public virtual ScriptReferenceType Type
        {
            get { return type; }
        }

        public virtual TextAsset Text
        {
            get { return text; }
        }

        public virtual string Filename
        {
            get { return filename; }
        }

        public void OnAfterDeserialize()
        {
            Clear();
        }

        public void OnBeforeSerialize()
        {
            Clear();
        }

        protected virtual void Clear()
        {
#if !UNITY_EDITOR
            switch (type)
            {
                case ScriptReferenceType.TextAsset:
                    filename = null;
                    break;
                case ScriptReferenceType.Filename:
                    text = null;
                    break;
            }
#endif
        }
    }
}

