local util = require("xlua.util") as UtilType

local CoroutineExt = class("CoroutineExt") as CoroutineExtType

function CoroutineExt:ctor()
end

function CoroutineExt:__singleton(): CoroutineExtType
    return CoroutineExt.new()
end

function CoroutineExt:GetEnumerator(callback: function): CS.System.Collections.IEnumerator
    return util.cs_generator(function()
        if callback then
            callback()
        end
    end)
end

function CoroutineExt:Yield(enumerator: CS.System.Object)
    coroutine.yield(enumerator)
end

function CoroutineExt:Wait(time: number)
    coroutine.yield(CS.UnityEngine.WaitForSeconds(time))
end

function CoroutineExt:dtor()
end

return CoroutineExt