local BindingProxyBase = require("LuaFramework.Binding.Proxy.BindingProxyBase")
local ITargetProxy = require("LuaFramework.Binding.Proxy.Targets.ITargetProxy")
local BindingMode = require("LuaFramework.Binding.BindingMode")

local TargetProxyBase = class("TargetProxyBase", BindingProxyBase, ITargetProxy) as TargetProxyBaseType

function TargetProxyBase.get:Target(): LuaObject
    return self.target
end

function TargetProxyBase.get:DefaultMode(): number
    return BindingMode.OneWay
end

function TargetProxyBase:ctor(target: LuaObject)
    BindingProxyBase.ctor(self)
    ITargetProxy.ctor(self)
    self.target = target
    self.targetName = ""
end

function TargetProxyBase:IsAlive(target: LuaObject): boolean
    assert({target})
    return true
end

function TargetProxyBase:dtor()
end

return TargetProxyBase