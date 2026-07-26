using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Text.RegularExpressions;
using Loxodon.Framework.Views.Variables;
using UnityEditor;
using UnityEngine;

namespace Loxodon.Framework.Editors
{
    public class VariableArrayMonoGenerateWindow : EditorWindow
    {

        private static readonly Dictionary<string, string> ComponentToBindName = new Dictionary<string, string>
        {
            { "Text", "TextBind" },
            { "Button", "ButtonBind" },
            { "Image", "ImageBind" },
            { "Toggle", "ToggleBind" },
            { "InputField", "InputFieldBind" },
            { "Canvas", "CanvasBind" },
            { "CanvasGroup", "CanvasGroupBind" },
            { "RectTransform", "RectTransformBind" },
            { "Transform", "TransformBind" },
        };

        private const string AUTO_GEN_BEGIN = "--[[AutoGenerate Begin]]";
        private const string AUTO_GEN_END = "--[[AutoGenerate End]]";

        private static readonly string[] UIClassTypes = { "Window", "View" };

        private GameObject selectedPrefab;
        private int uiClassTypeIndex;
        private int windowTypeIndex;
        private string[] windowTypeNames;
        private Vector2 scrollPos;

        [MenuItem("Tools/GenVariableArrayMono")]
        public static void ShowWindow()
        {
            var window = GetWindow<VariableArrayMonoGenerateWindow>("GenVariableArrayMono");
            window.minSize = new Vector2(300, 200);
            window.Show();
        }

        private void OnEnable()
        {
            windowTypeNames = ParseWindowTypes();
            if (Selection.activeGameObject != null)
            {
                selectedPrefab = Selection.activeGameObject;
                LoadExistingUIClassType(selectedPrefab.name);
            }
        }

        private void OnGUI()
        {
            EditorGUILayout.Space(10);

            // Prefab field
            EditorGUILayout.LabelField("Prefab", EditorStyles.boldLabel);
            var newPrefab = (GameObject)EditorGUILayout.ObjectField(selectedPrefab, typeof(GameObject), true);
            if (newPrefab != selectedPrefab)
            {
                selectedPrefab = newPrefab;
                if (newPrefab != null)
                    LoadExistingUIClassType(newPrefab.name);
                else
                {
                    uiClassTypeIndex = 0;
                    windowTypeIndex = 0;
                }
            }

            EditorGUILayout.Space(10);

            // UIClassType dropdown (Window / View)
            EditorGUILayout.LabelField("Class Type", EditorStyles.boldLabel);
            uiClassTypeIndex = EditorGUILayout.Popup(uiClassTypeIndex, UIClassTypes);

            EditorGUILayout.Space(10);

            // WindowType dropdown (only for Window)
            bool isWindow = uiClassTypeIndex == 0;
            if (isWindow)
            {
                EditorGUILayout.LabelField("WindowType", EditorStyles.boldLabel);
                if (windowTypeNames != null && windowTypeNames.Length > 0)
                {
                    windowTypeIndex = EditorGUILayout.Popup(windowTypeIndex, windowTypeNames);
                }
                else
                {
                    EditorGUILayout.HelpBox("No WindowType found in WindowEnum.lua.txt", MessageType.Warning);
                }
            }

            EditorGUILayout.Space(20);

            // Generate button
            EditorGUI.BeginDisabledGroup(selectedPrefab == null);
            if (GUILayout.Button("Generate", GUILayout.Height(30)))
            {
                Generate();
            }
            EditorGUI.EndDisabledGroup();

            EditorGUILayout.Space(10);

            // Info
            if (selectedPrefab != null)
            {
                string info = string.Format("prefabPath: {0}\nclassType: {1}", selectedPrefab.name, UIClassTypes[uiClassTypeIndex]);
                if (isWindow)
                    info += string.Format("\nwindowType: WindowEnum.WindowType.{0}", windowTypeNames != null && windowTypeIndex < windowTypeNames.Length ? windowTypeNames[windowTypeIndex] : "");
                EditorGUILayout.HelpBox(info, MessageType.Info);
            }
        }

        private void Generate()
        {
            try
            {
                if (selectedPrefab == null)
                {
                    EditorUtility.DisplayDialog("Error", "Please select a prefab.", "OK");
                    return;
                }

                bool isWindow = uiClassTypeIndex == 0;

                if (isWindow && (windowTypeNames == null || windowTypeNames.Length == 0))
                {
                    EditorUtility.DisplayDialog("Error", "No WindowType available. Check WindowEnum.lua.txt.", "OK");
                    return;
                }

                var mono = selectedPrefab.GetComponent<VariableArrayMono>();
                if (mono == null)
                {
                    EditorUtility.DisplayDialog("Error", string.Format("The selected GameObject \"{0}\" does not have a VariableArrayMono component.", selectedPrefab.name), "OK");
                    return;
                }

                var entries = new List<TagEntry>();
                CollectTagEntries(selectedPrefab.transform, entries);

                if (entries.Count == 0)
                {
                    EditorUtility.DisplayDialog("Info", string.Format("No tagged child nodes found under \"{0}\".", selectedPrefab.name), "OK");
                    return;
                }

                // Preserve user-renamed variables from existing VariableArray
                PreserveExistingNames(mono, entries);

                // Check for duplicate names, abort if found
                if (HasDuplicateNames(entries))
                    return;

                // Ensure variableArray is initialized before creating SerializedObject
                if (mono.variableArray == null)
                    mono.variableArray = new VariableArray();

                var serializedObject = new SerializedObject(mono);
                var variableArrayProp = serializedObject.FindProperty("variableArray");
                var variablesProp = variableArrayProp.FindPropertyRelative("variables");

                variablesProp.ClearArray();

                for (int i = 0; i < entries.Count; i++)
                {
                    var entry = entries[i];
                    variablesProp.InsertArrayElementAtIndex(i);
                    var element = variablesProp.GetArrayElementAtIndex(i);

                    element.FindPropertyRelative("name").stringValue = entry.Name;
                    element.FindPropertyRelative("variableType").enumValueIndex = (int)entry.VariableType;
                    element.FindPropertyRelative("dataValue").stringValue = "";

                    if (entry.VariableType == VariableType.Object || entry.VariableType == VariableType.GameObject || entry.VariableType == VariableType.Component)
                    {
                        element.FindPropertyRelative("objectValue").objectReferenceValue = entry.ObjectValue;
                    }
                    else
                    {
                        element.FindPropertyRelative("objectValue").objectReferenceValue = null;
                    }
                }

                serializedObject.ApplyModifiedProperties();
                EditorUtility.SetDirty(mono);

                string windowType = isWindow && windowTypeNames != null && windowTypeIndex < windowTypeNames.Length ? windowTypeNames[windowTypeIndex] : null;
                string classType = UIClassTypes[uiClassTypeIndex];

                GenerateLuaScript(selectedPrefab.name, classType, windowType, entries);

                Debug.LogFormat("VariableArrayMono Generate: {0} variables added to \"{1}\".", entries.Count, selectedPrefab.name);
            }
            catch (Exception e)
            {
                Debug.LogErrorFormat("VariableArrayMono Generate Error: {0}\n{1}", e.Message, e.StackTrace);
                EditorUtility.DisplayDialog("Error", string.Format("Generate failed:\n{0}", e.Message), "OK");
            }
        }

        #region WindowType Parsing

        private void LoadExistingUIClassType(string className)
        {
            uiClassTypeIndex = 0;
            windowTypeIndex = 0;
            if (windowTypeNames == null || windowTypeNames.Length == 0)
                return;

            // Search for lua script in Assets directory
            var files = Directory.GetFiles(Application.dataPath, className + ".lua.txt", SearchOption.AllDirectories);

            foreach (var file in files)
            {
                try
                {
                    string content = File.ReadAllText(file);

                    // Detect class type: class("XXX", WindowBase) -> Window, class("XXX", ViewBase) -> View
                    if (content.Contains("ViewBase"))
                        uiClassTypeIndex = 1;

                    // Parse windowType
                    var regex = new Regex(string.Format(@"{0}\.windowType\s*=\s*WindowEnum\.WindowType\.(\w+)", className));
                    var match = regex.Match(content);
                    if (match.Success)
                    {
                        string typeName = match.Groups[1].Value;
                        for (int i = 0; i < windowTypeNames.Length; i++)
                        {
                            if (windowTypeNames[i] == typeName)
                            {
                                windowTypeIndex = i;
                                return;
                            }
                        }
                    }
                }
                catch (Exception)
                {
                }
            }
        }

        private static string[] ParseWindowTypes()
        {
            var types = new List<string>();

            var files = Directory.GetFiles(Application.dataPath, "WindowEnum.lua.txt", SearchOption.AllDirectories);
            if (files.Length == 0)
            {
                EditorUtility.DisplayDialog("Error", "WindowEnum.lua.txt not found in project.", "OK");
                return new string[0];
            }

            string content = File.ReadAllText(files[0]);

            // Parse WindowType enum entries: KEY = value
            var regex = new Regex(@"WindowEnum\.WindowType\s*=\s*\{([^}]+)\}", RegexOptions.Singleline);
            var match = regex.Match(content);
            if (match.Success)
            {
                var entries = match.Groups[1].Value;
                var lineRegex = new Regex(@"\s*(\w+)\s*=\s*\d+\s*,?");
                foreach (Match m in lineRegex.Matches(entries))
                {
                    types.Add(m.Groups[1].Value);
                }
            }

            if (types.Count == 0)
            {
                EditorUtility.DisplayDialog("Error", "Failed to parse WindowType from WindowEnum.lua.txt.", "OK");
                return new string[0];
            }

            return types.ToArray();
        }

        #endregion

        #region Lua Script Generation

        private static void GenerateLuaScript(string className, string classType, string windowType, List<TagEntry> entries)
        {
            var requireSet = new SortedSet<string>();
            var initLines = new List<string>();

            foreach (var entry in entries)
            {
                string bindName = GetBindName(entry);
                if (string.IsNullOrEmpty(bindName))
                    continue;

                requireSet.Add(bindName);
                initLines.Add(string.Format("    self.{0} = {1}.new(\"{0}\")", entry.Name, bindName));
            }

            string outputPath = EditorUtility.SaveFilePanel(
                "Save Lua Script",
                Application.dataPath,
                className + ".lua.txt",
                "lua.txt");

            if (string.IsNullOrEmpty(outputPath))
                return;

            string content;
            if (File.Exists(outputPath))
            {
                content = File.ReadAllText(outputPath);
                content = MergeExistingFile(content, className, classType, windowType, requireSet, initLines);
            }
            else
            {
                content = GenerateNewFile(className, classType, windowType, requireSet, initLines);
            }

            File.WriteAllText(outputPath, content, new UTF8Encoding(false));
            AssetDatabase.Refresh();
            Debug.LogFormat("Lua script generated: {0}", outputPath);
        }

        private static string GenerateNewFile(string className, string classType, string windowType, SortedSet<string> requireSet, List<string> initLines)
        {
            bool isWindow = classType == "Window";
            string baseClass = isWindow ? "WindowBase" : "ViewBase";

            var sb = new StringBuilder();
            sb.AppendFormat("local {0} = require(\"LuaFramework.Views.{1}\")\n", baseClass, baseClass);
            if (isWindow)
                sb.AppendFormat("local WindowEnum = require(\"LuaFramework.Views.WindowEnum\")\n");
            sb.AppendLine();

            foreach (var req in requireSet)
            {
                sb.AppendFormat("local {0} = require(\"LuaFramework.Views.ComponentBinds.{0}\")\n", req);
            }
            sb.AppendLine();

            sb.AppendFormat("local {0} = class(\"{0}\", {1})\n", className, baseClass);
            sb.AppendLine();
            sb.AppendFormat("{0}.prefabPath = \"{1}\"\n", className, className);
            sb.AppendLine();
            if (isWindow && !string.IsNullOrEmpty(windowType))
            {
                sb.AppendFormat("{0}.windowType = WindowEnum.WindowType.{1}\n", className, windowType);
                sb.AppendLine();
            }
            sb.AppendFormat("function {0}:OnInit()\n", className);
            sb.Append("    " + AUTO_GEN_BEGIN + "\n");
            foreach (var line in initLines)
            {
                sb.Append(line + "\n");
            }
            sb.Append("    " + AUTO_GEN_END + "\n");
            sb.AppendFormat("end\n");
            sb.AppendLine();
            sb.AppendFormat("function {0}:OnShow()\n", className);
            sb.AppendLine("end");
            sb.AppendLine();
            sb.AppendFormat("function {0}:OnHide()\n", className);
            sb.AppendLine("end");
            sb.AppendLine();
            sb.AppendFormat("return {0}\n", className);

            return sb.ToString();
        }

        private static string MergeExistingFile(string content, string className, string classType, string windowType, SortedSet<string> requireSet, List<string> initLines)
        {
            bool isWindow = classType == "Window";
            string baseClass = isWindow ? "WindowBase" : "ViewBase";

            // Update require statements
            content = MergeRequireStatements(content, requireSet);

            // Update base class require line: both path and local variable name
            content = content.Replace("require(\"LuaFramework.Views.WindowBase\")", string.Format("require(\"LuaFramework.Views.{0}\")", baseClass));
            content = content.Replace("require(\"LuaFramework.Views.ViewBase\")", string.Format("require(\"LuaFramework.Views.{0}\")", baseClass));
            content = content.Replace("local WindowBase =", string.Format("local {0} =", baseClass));
            content = content.Replace("local ViewBase =", string.Format("local {0} =", baseClass));

            // Add or remove WindowEnum require
            if (isWindow)
            {
                string windowEnumRequire = "local WindowEnum = require(\"LuaFramework.Views.WindowEnum\")";
                if (!content.Contains(windowEnumRequire))
                {
                    // Insert after base class require line
                    string baseRequire = string.Format("require(\"LuaFramework.Views.{0}\")", baseClass);
                    int baseReqEnd = content.IndexOf(baseRequire);
                    if (baseReqEnd >= 0)
                    {
                        int insertPos = content.IndexOf('\n', baseReqEnd) + 1;
                        string nlChar = content.Contains("\r\n") ? "\r\n" : "\n";
                        content = content.Substring(0, insertPos) + windowEnumRequire + nlChar + content.Substring(insertPos);
                    }
                }
            }
            else
            {
                content = Regex.Replace(content, @"local WindowEnum = require\(""LuaFramework\.Views\.WindowEnum""\)\r?\n?", "");
            }

            // Update class declaration base class
            var classRegex = new Regex(string.Format(@"local {0} = class\(""{0}"",\s*\w+\)", className));
            content = classRegex.Replace(content, string.Format("local {0} = class(\"{0}\", {1})", className, baseClass));

            // Update prefabPath
            content = MergeClassField(content, className, "prefabPath", string.Format("\"{0}\"", className));

            // Update or remove windowType
            if (isWindow && !string.IsNullOrEmpty(windowType))
            {
                content = MergeClassField(content, className, "windowType", string.Format("WindowEnum.WindowType.{0}", windowType), "prefabPath");
            }
            else
            {
                // Remove windowType line for View (also clean up adjacent blank lines)
                content = RemoveClassField(content, className, "windowType");
            }

            // Update OnInit auto-generated block
            int beginIndex = content.IndexOf(AUTO_GEN_BEGIN, StringComparison.Ordinal);
            int endIndex = content.IndexOf(AUTO_GEN_END, StringComparison.Ordinal);

            // Detect line ending from existing file
            string nl = content.Contains("\r\n") ? "\r\n" : "\n";

            var sb = new StringBuilder();
            sb.Append("    " + AUTO_GEN_BEGIN + nl);
            foreach (var line in initLines)
            {
                sb.Append(line + nl);
            }
            sb.Append("    " + AUTO_GEN_END + nl);

            string genBlock = sb.ToString();

            if (beginIndex >= 0 && endIndex >= 0 && endIndex > beginIndex)
            {
                int lineStart = beginIndex;
                while (lineStart > 0 && content[lineStart - 1] != '\r' && content[lineStart - 1] != '\n')
                    lineStart--;

                int lineEnd = endIndex + AUTO_GEN_END.Length;
                if (lineEnd < content.Length && content[lineEnd] == '\r')
                    lineEnd++;
                if (lineEnd < content.Length && content[lineEnd] == '\n')
                    lineEnd++;

                content = content.Substring(0, lineStart) + genBlock + content.Substring(lineEnd);
            }
            else
            {
                string onInitPattern = string.Format("function {0}:OnInit()", className);
                int onInitIndex = content.IndexOf(onInitPattern, StringComparison.Ordinal);
                if (onInitIndex >= 0)
                {
                    int insertPos = content.IndexOf('\n', onInitIndex) + 1;
                    content = content.Substring(0, insertPos) + genBlock + content.Substring(insertPos);
                }
                else
                {
                    var onInitSb = new StringBuilder();
                    onInitSb.AppendLine();
                    onInitSb.AppendFormat("function {0}:OnInit()\n", className);
                    onInitSb.Append(genBlock);
                    onInitSb.AppendFormat("end\n");
                    content = onInitSb.ToString() + content;
                }
            }

            return content;
        }

        private static string MergeClassField(string content, string className, string fieldName, string value, string insertAfterField = null)
        {
            string pattern = string.Format("{0}.{1} = ", className, fieldName);
            int index = content.IndexOf(pattern, StringComparison.Ordinal);
            if (index >= 0)
            {
                int lineStart = index;
                int lineEnd = content.IndexOf('\n', index);
                if (lineEnd < 0) lineEnd = content.Length;
                string newLine = string.Format("{0}.{1} = {2}", className, fieldName, value);
                content = content.Substring(0, lineStart) + newLine + content.Substring(lineEnd);
            }
            else
            {
                // Insert after the specified field, or after class declaration line
                int insertPos = -1;
                string nl = content.Contains("\r\n") ? "\r\n" : "\n";

                if (!string.IsNullOrEmpty(insertAfterField))
                {
                    string afterPattern = string.Format("{0}.{1} = ", className, insertAfterField);
                    int afterIndex = content.IndexOf(afterPattern, StringComparison.Ordinal);
                    if (afterIndex >= 0)
                    {
                        int afterLineEnd = content.IndexOf('\n', afterIndex);
                        if (afterLineEnd >= 0)
                        {
                            insertPos = afterLineEnd + 1;
                        }
                    }
                }

                if (insertPos < 0)
                {
                    string classLine = string.Format("local {0} = class(", className);
                    int classIndex = content.IndexOf(classLine, StringComparison.Ordinal);
                    if (classIndex >= 0)
                    {
                        insertPos = content.IndexOf('\n', classIndex) + 1;
                    }
                }

                if (insertPos >= 0)
                {
                    string insertText = string.Format("{0}.{1} = {2}{3}", className, fieldName, value, nl);
                    content = content.Substring(0, insertPos) + insertText + content.Substring(insertPos);
                }
            }
            return content;
        }

        private static string RemoveClassField(string content, string className, string fieldName)
        {
            string pattern = string.Format("{0}.{1} = ", className, fieldName);
            int index = content.IndexOf(pattern, StringComparison.Ordinal);
            if (index >= 0)
            {
                // Find the start of this line
                int lineStart = index;
                while (lineStart > 0 && content[lineStart - 1] != '\r' && content[lineStart - 1] != '\n')
                    lineStart--;

                // Find the end of this line (including line break)
                int lineEnd = content.IndexOf('\n', index);
                if (lineEnd < 0) lineEnd = content.Length;
                else lineEnd++;

                content = content.Substring(0, lineStart) + content.Substring(lineEnd);
            }
            return content;
        }

        private static string MergeRequireStatements(string content, SortedSet<string> requireSet)
        {
            foreach (var req in requireSet)
            {
                string requireLine = string.Format("local {0} = require(\"LuaFramework.Views.ComponentBinds.{0}\")", req);
                if (!content.Contains(requireLine))
                {
                    int lastRequireIndex = content.LastIndexOf(")require(\"", StringComparison.Ordinal);
                    if (lastRequireIndex < 0)
                        lastRequireIndex = content.LastIndexOf("require(\"", StringComparison.Ordinal);

                    if (lastRequireIndex >= 0)
                    {
                        int lineEnd = content.IndexOf('\n', lastRequireIndex);
                        if (lineEnd >= 0)
                        {
                            content = content.Substring(0, lineEnd + 1) + requireLine + "\n" + content.Substring(lineEnd + 1);
                        }
                    }
                    else
                    {
                        int classLineEnd = content.IndexOf('\n');
                        if (classLineEnd >= 0)
                        {
                            content = content.Substring(0, classLineEnd + 1) + "\n" + requireLine + "\n" + content.Substring(classLineEnd + 1);
                        }
                    }
                }
            }

            return content;
        }

        #endregion

        #region Tag Collection

        private static string GetBindName(TagEntry entry)
        {
            if (entry.VariableType == VariableType.GameObject)
                return "GameObjectBind";

            if (entry.VariableType == VariableType.Component && entry.ObjectValue is Component comp)
            {
                string typeName = comp.GetType().Name;
                string bindName;
                if (ComponentToBindName.TryGetValue(typeName, out bindName))
                    return bindName;
            }

            return null;
        }

        private static bool HasDuplicateNames(List<TagEntry> entries)
        {
            var seen = new HashSet<string>();
            var duplicates = new HashSet<string>();
            foreach (var entry in entries)
            {
                if (!seen.Add(entry.Name))
                    duplicates.Add(entry.Name);
            }

            if (duplicates.Count > 0)
            {
                var names = new List<string>(duplicates);
                names.Sort();
                EditorUtility.DisplayDialog("Duplicate Names", string.Format("Found duplicate variable names: {0}\n\nPlease rename them in the Inspector and try again.", string.Join(", ", names.ToArray())), "OK");
                return true;
            }

            return false;
        }

        private static void PreserveExistingNames(VariableArrayMono mono, List<TagEntry> entries)
        {
            if (mono.variableArray == null)
                return;

            var serializedObject = new SerializedObject(mono);
            var variablesProp = serializedObject.FindProperty("variableArray").FindPropertyRelative("variables");
            if (variablesProp == null || variablesProp.arraySize == 0)
                return;

            var existingNames = new Dictionary<UnityEngine.Object, string>();
            for (int i = 0; i < variablesProp.arraySize; i++)
            {
                var element = variablesProp.GetArrayElementAtIndex(i);
                var name = element.FindPropertyRelative("name").stringValue;
                var obj = element.FindPropertyRelative("objectValue").objectReferenceValue;
                if (obj != null && !string.IsNullOrEmpty(name))
                    existingNames[obj] = name;
            }

            foreach (var entry in entries)
            {
                string existingName;
                if (existingNames.TryGetValue(entry.ObjectValue, out existingName))
                    entry.Name = existingName;
            }
        }

        private static void CollectTagEntries(Transform root, List<TagEntry> entries)
        {
            foreach (Transform child in root)
            {
                TryCreateEntry(child.gameObject, entries);
                CollectTagEntries(child, entries);
            }
        }

        private static void TryCreateEntry(GameObject go, List<TagEntry> entries)
        {
            string tag = go.tag;
            if (string.IsNullOrEmpty(tag) || tag == "Untagged")
                return;

            TagEntry entry = CreateEntryFromTag(go, tag);
            if (entry != null)
                entries.Add(entry);
        }

        private static TagEntry CreateEntryFromTag(GameObject go, string tag)
        {
            string[] parts = tag.Split('.');
            if (parts.Length == 0)
                return null;

            string typeStr = parts[0].Trim();
            VariableType variableType;
            if (!Enum.TryParse(typeStr, out variableType))
                return null;

            switch (variableType)
            {
                case VariableType.Object:
                    return new TagEntry(go.name, VariableType.Object, go);
                case VariableType.GameObject:
                    return new TagEntry(go.name, VariableType.GameObject, go);
                case VariableType.Component:
                    {
                        if (parts.Length < 2)
                        {
                            Debug.LogWarningFormat("VariableArrayMono Generate: Tag \"{0}\" on \"{1}\" is Component type but no component type specified, skipped.", tag, go.name);
                            return null;
                        }

                        string componentTypeName = parts[1].Trim();
                        var component = FindComponent(go, componentTypeName);
                        if (component == null)
                        {
                            Debug.LogWarningFormat("VariableArrayMono Generate: Component \"{0}\" not found on \"{1}\", skipped.", componentTypeName, go.name);
                            return null;
                        }
                        return new TagEntry(go.name, VariableType.Component, component);
                    }
                default:
                    Debug.LogWarningFormat("VariableArrayMono Generate: VariableType \"{0}\" is not supported for tag-based generation on \"{1}\", skipped.", variableType, go.name);
                    return null;
            }
        }

        private static Component FindComponent(GameObject go, string componentTypeName)
        {
            var components = go.GetComponents<Component>();
            foreach (var comp in components)
            {
                if (comp == null)
                    continue;
                var type = comp.GetType();
                if (type.Name == componentTypeName || type.FullName == componentTypeName)
                    return comp;
            }

            foreach (var assembly in AppDomain.CurrentDomain.GetAssemblies())
            {
                try
                {
                    var type = assembly.GetType(componentTypeName);
                    if (type != null && typeof(Component).IsAssignableFrom(type))
                    {
                        var comp = go.GetComponent(type);
                        if (comp != null)
                            return comp;
                    }
                }
                catch (Exception)
                {
                }
            }

            return null;
        }

        private class TagEntry
        {
            public string Name;
            public VariableType VariableType;
            public UnityEngine.Object ObjectValue;

            public TagEntry(string name, VariableType variableType, UnityEngine.Object objectValue)
            {
                Name = name;
                VariableType = variableType;
                ObjectValue = objectValue;
            }
        }

        #endregion
    }
}
