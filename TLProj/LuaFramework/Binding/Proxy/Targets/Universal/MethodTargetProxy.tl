local TargetProxyBase = require("LuaFramework.Binding.Proxy.Targets.TargetProxyBase")
local IProxyInvoker = require("LuaFramework.Binding.Reflection.IProxyInvoker")
local IObtainable = require("LuaFramework.Binding.Proxy.IObtainable")
local BindingMode = require("LuaFramework.Binding.BindingMode")

local MethodTargetProxy = class("MethodTargetProxy", TargetProxyBase, IObtainable, IProxyInvoker) as MethodTargetProxyType

function MethodTargetProxy.get:DefaultMode(): number
    return BindingMode.OneWayToSource
end

function MethodTargetProxy.get:ProxyMethodInfo(): string
    return self.methodInfo
end

function MethodTargetProxy:ctor(target: LuaObject, methodInfo: string)
    TargetProxyBase.ctor(self, target)
    IObtainable.ctor(self)
    IProxyInvoker.ctor(self)
    self.methodInfo = methodInfo
end

function MethodTargetProxy:GetValue(): any
    return self as IProxyInvokerType
end

function MethodTargetProxy:Invoke(sender: LuaObject, ...: any)
    local target = self.target
    if nil == target then
        return
    end

    local functionType = classget(target, self.methodInfo) as function
    functionType(target, sender, ...)
end

function MethodTargetProxy:dtor()
end

return MethodTargetProxy