local TargetProxyBase = require("LuaFramework.Binding.Proxy.Targets.TargetProxyBase")

local TargetProxyEventBase = class("TargetProxyEventBase", TargetProxyBase) as EventTargetProxyBaseType

function TargetProxyEventBase:ctor(target: LuaObject)
    TargetProxyBase.ctor(self, target)
end

function TargetProxyEventBase:SetValue(value: any)
    assert({value}, "")
end

function TargetProxyEventBase:dtor()
end

return TargetProxyEventBase