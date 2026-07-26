local ExecutorsExt = class("ExecutorsExt") as ExecutorsExtType

local InterceptableEnumerator = CS.Loxodon.Framework.Execution.InterceptableEnumerator

function ExecutorsExt:ctor()
    self.csharp = CS.Loxodon.Framework.Execution.Executors
end

function ExecutorsExt:__singleton(): ExecutorsExtType
    return ExecutorsExt.new()
end

function ExecutorsExt:WaitWhile(callback: function): CS.System.Object
    return self.csharp.WaitWhile(callback)
end

function ExecutorsExt:RunOnCoroutine(callback: CS.System.Collections.IEnumerator): CS.Loxodon.Framework.Execution.CoroutineResult
    return self.csharp.RunOnCoroutine(callback)
end

function ExecutorsExt:RunOnCoroutineReturn(callback: CS.System.Collections.IEnumerator): CS.UnityEngine.Coroutine
    local ie = InterceptableEnumerator(callback) as CS.System.Collections.IEnumerator
    return self.csharp.RunOnCoroutineReturn(ie)
end

function ExecutorsExt:RunOnCoroutineNoReturn(callback: CS.System.Collections.IEnumerator)
    local ie = InterceptableEnumerator(callback) as CS.System.Collections.IEnumerator
    self.csharp.RunOnCoroutineNoReturn(ie)
end

function ExecutorsExt:RunOnMainThread(callback: function)
    self.csharp.RunOnMainThread(callback)
end

function ExecutorsExt:dtor()
end

return ExecutorsExt