using System;
using System.Reflection;
using System.Runtime.CompilerServices;

namespace Assembly_CSharp.Assets.Script.Simple
{
    public static class WeakDelegateExtensions
    {
        public static Action AsWeak(this Action action)
        {
            if (!IsCanWeaken(action))
                return action;

            Type type = action.Target.GetType();
            WeakReference targetRef = new WeakReference(action.Target);
            MethodInfo method = action.Method;
            return () =>
            {
                object target = targetRef.Target;
                if (target == null)
                    return;

                method.Invoke(target, null);
            };
        }

        public static Action<T> AsWeak<T>(this Action<T> action)
        {
            if (!IsCanWeaken(action))
                return action;

            Type type = action.Target.GetType();
            WeakReference targetRef = new WeakReference(action.Target);
            MethodInfo method = action.Method;
            return (t) =>
            {
                object target = targetRef.Target;
                if (target == null)
                    return;

                method.Invoke(target, new object[] { t });
            };
        }

        private static bool IsCanWeaken(Delegate del)
        {
            if (del == null || del.Method.IsStatic || del.Target == null || IsClosure(del))
                return false;
            return true;
        }

        private static bool IsClosure(Delegate del)
        {
            if (del == null || del.Method.IsStatic || del.Target == null)
                return false;

            var type = del.Target.GetType();
            var isInvisible = !type.IsVisible;
            var isCompilerGenerated = type.GetCustomAttributes(typeof(CompilerGeneratedAttribute), false) != null;
            var isNested = type.IsNested && type.MemberType == MemberTypes.NestedType;
            return isNested && isCompilerGenerated && isInvisible;
        }
    }
}

