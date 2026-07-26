local Miscellaneous = require("LuaFramework.Common.Miscellaneous")
local CoroutineExt = require("LuaFramework.Common.CoroutineExt")
local ExecutorsExt = require("LuaFramework.Execution.ExecutorsExt")

local DefaultUIViewLocator = class("DefaultUIViewLocator") as DefaultUIViewLocatorType

function DefaultUIViewLocator:ctor()
end

function DefaultUIViewLocator:__singleton(): DefaultUIViewLocatorType
    return DefaultUIViewLocator.new()
end

function DefaultUIViewLocator:LoadAsync(name: string, ctype: CS.System.Type): CS.Loxodon.Framework.Asynchronous.ProgressResult_1_Single
    local result = (classget(CS.Loxodon.Framework.Asynchronous, Miscellaneous.CSName.ProgressResult_1_Single) as CS.Loxodon.Framework.Asynchronous.ProgressResult_1_Single)(true)
    ExecutorsExt.Instance:RunOnCoroutineNoReturn(CoroutineExt.Instance:GetEnumerator(function ()
        DefaultUIViewLocator:DoLoad(result, name, ctype)
    end))
    return result
end

function DefaultUIViewLocator:DoLoad(promise: CS.Loxodon.Framework.Asynchronous.ProgressResult_1_Single, name: string, cType: CS.System.Type)
    promise:UpdateProgress(0)
    local request = CS.UnityEngine.Resources.LoadAsync(name, cType) as CS.UnityEngine.ResourceRequest
    while not request.isDone do
        promise:UpdateProgress(request.progress)
        CoroutineExt.Instance:Wait(3)
    end

    promise:UpdateProgress(1)
    promise:SetResult(request.asset as CS.System.Object)
end

function DefaultUIViewLocator:dtor()
end

return DefaultUIViewLocator