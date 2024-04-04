local BindingProxyBase = require("LuaFramework.Binding.Proxy.BindingProxyBase")
local ISourceProxy = require("LuaFramework.Binding.Proxy.Sources.ISourceProxy")

local SourceProxyBase = class("SourceProxyBase", BindingProxyBase, ISourceProxy) as SourceProxyBaseType

function SourceProxyBase.get:Source(): LuaObject
    return self.source
end

function SourceProxyBase.set:Source(value: LuaObject)
    self.source = value
end

function SourceProxyBase:ctor(source: LuaObject)
    BindingProxyBase.ctor(self)
    ISourceProxy.ctor(self)
    self.source = source
end

return SourceProxyBase