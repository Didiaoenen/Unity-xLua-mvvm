local SourceProxyBase = require("LuaFramework.Binding.Proxy.Sources.SourceProxyBase")
local IObtainable = require("LuaFramework.Binding.Proxy.IObtainable")
local ProxyInvoker = require("LuaFramework.Binding.Reflection.ProxyInvoker")

local MethodNodeProxy = class("MethodNodeProxy", SourceProxyBase, IObtainable) as MethodNodeProxyType

function MethodNodeProxy:ctor(source: LuaObject, methodInfo: string)
    SourceProxyBase.ctor(self, source)
    IObtainable.ctor(self)
    self.methodInfo = methodInfo
    self.invoker = ProxyInvoker.new(self.source, self.methodInfo) as IProxyInvokerType
end

function MethodNodeProxy:GetValue(): any
    return self.invoker
end

function MethodNodeProxy:dtor()
end

return MethodNodeProxy