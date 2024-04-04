using System;
using System.Reflection;
using Assembly_CSharp.Assets.Script.Simple.Observables;

namespace Assembly_CSharp.Assets.Script.Simple
{
    public static class TypeExtensions
    {
        public static bool IsSubclassOfGenericTypeDefinition(this Type type, Type genericTypeDefinition)
        {
            if (!genericTypeDefinition.IsGenericTypeDefinition)
                return false;

            if (type.IsGenericType && type.GetGenericTypeDefinition().Equals(genericTypeDefinition))
                return true;

            Type baseType = type.BaseType;
            if (baseType != null && baseType != typeof(object))
            {
                if (IsSubclassOfGenericTypeDefinition(baseType, genericTypeDefinition))
                    return true;
            }

            foreach (Type t in type.GetInterfaces())
            {
                if (IsSubclassOfGenericTypeDefinition(t, genericTypeDefinition))
                    return true;
            }

            return false;
        }

        public static object CreateDefault(this Type type)
        {
            if (type == null)
                return null;

            if (type == typeof(string))
                return string.Empty;

            if (!type.IsValueType)
                return null;

            if (Nullable.GetUnderlyingType(type) != null)
                return null;

            return Activator.CreateInstance(type);
        }

        public static object ToSafe(this Type type, object value)
        {
            if (value == null)
                return type.CreateDefault();

            var safeValue = value;
            try
            {
                if (!type.IsInstanceOfType(value))
                {
                    if (value is IObservableProperty)
                    {
                        safeValue = (value as IObservableProperty).Value;
                        if (!type.IsInstanceOfType(safeValue))
                        {
                            safeValue = ChangeType(safeValue, type);
                        }
                    }
                    else if (type == typeof(string))
                    {
                        safeValue = value.ToString();
                    }
                    else if (type.IsEnum)
                    {
                        var s = value as string;
                        safeValue = s != null ? Enum.Parse(type, s, true) : Enum.ToObject(type, value);
                    }
                    else if (type.IsValueType)
                    {
                        var underlyingType = Nullable.GetUnderlyingType(type) ?? type;
                        safeValue = underlyingType == typeof(bool) ? ConvertToBoolean(value) : ChangeType(value, underlyingType);
                    }
                    else
                    {
                        safeValue = ChangeType(value, type);
                    }
                }
            }
            catch (Exception) { }

            return safeValue;
        }

        private static object ChangeType(object value, Type type)
        {
            try
            {
                return Convert.ChangeType(value, type);
            }
            catch (Exception)
            {
                return value;
            }
        }

        private static bool ConvertToBoolean(object result)
        {
            if (result == null)
                return false;

            if (result is string)
                return (result as string).ToLower().Equals(true.ToString().ToLower());

            if (result is bool)
                return (bool)result;

            var resultType = result.GetType();
            if (resultType.IsValueType)
            {
                var underlyingType = Nullable.GetUnderlyingType(resultType) ?? resultType;
                return !result.Equals(underlyingType.CreateDefault());
            }

            return true;
        }

        public static bool IsStatic(this MemberInfo info)
        {
            var fieldInfo = info as FieldInfo;
            if (fieldInfo != null)
                return fieldInfo.IsStatic;

            var propertyInfo = info as PropertyInfo;
            if (propertyInfo != null)
            {
                var method = propertyInfo.GetGetMethod();
                if (method != null)
                    return method.IsStatic;

                method = propertyInfo.GetSetMethod();
                if (method != null)
                    return method.IsStatic;
            }

            var methodInfo = info as MethodInfo;
            if (methodInfo != null)
                return methodInfo.IsStatic;

            var eventInfo = info as EventInfo;
            if (eventInfo != null)
            {
                var method = eventInfo.GetAddMethod();
                if (method != null)
                    return method.IsStatic;

                method = eventInfo.GetRemoveMethod();
                if (method == null)
                    return method.IsStatic;
            }

            return false;
        }
    }
}

