local IProxyInvoker = require("LuaFramework.Binding.Reflection.IProxyInvoker")

local ProxyInvoker = class("ProxyInvoker", IProxyInvoker) as ProxyInvokerType

function ProxyInvoker.get:ProxyMethodInfo(): string
    return self.proxyMethodInfo
end

function ProxyInvoker:ctor(target: LuaObject, proxyMethodInfo: string)
    IProxyInvoker.ctor(self)
    self.target = target
    self.proxyMethodInfo = proxyMethodInfo
end

function ProxyInvoker:Invoke(...: any): any...
    local functionType = classget(self.target, self.proxyMethodInfo) as function
    return functionType(self.target, ...)
end

return ProxyInvoker