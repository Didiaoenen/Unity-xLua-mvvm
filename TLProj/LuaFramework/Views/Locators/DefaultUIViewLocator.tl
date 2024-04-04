local Miscellaneous = require("LuaFramework.Common.Miscellaneous")
local CoroutineExt = require("LuaFramework.Common.CoroutineExt")
local ExecutorsExt = require("LuaFramework.Execution.ExecutorsExt")

local DefaultUIViewLocator = class("DefaultUIViewLocator") as DefaultUIViewLocatorType

function DefaultUIViewLocator.LoadAsync(name: string, ctype: CS.System.Type): CS.Asynchronous.ProgressResult_1_Single
    local result = (classget(CS.Asynchronous, Miscellaneous.CSName.ProgressResult_1_Single) as CS.Asynchronous.ProgressResult_1_Single)(true)
    ExecutorsExt.Instance:RunOnCoroutineNoReturn(CoroutineExt.GetEnumerator(function ()
        DefaultUIViewLocator.DoLoad(result, name, ctype)
    end))
    return result
end

function DefaultUIViewLocator.DoLoad(promise: CS.Asynchronous.ProgressResult_1_Single, name: string, cType: CS.System.Type)
    promise:UpdateProgress(0)
    local request = CS.UnityEngine.Resources.LoadAsync(name, cType) as CS.UnityEngine.ResourceRequest
    while not request.isDone do
        promise:UpdateProgress(request.progress)
        CoroutineExt.Wait(3)
    end

    local ins = CS.UnityEngine.Object.Instantiate(request.asset)
    ins.name = name

    promise:UpdateProgress(1)
    promise:SetResult(ins as CS.System.Object)
end

return DefaultUIViewLocator