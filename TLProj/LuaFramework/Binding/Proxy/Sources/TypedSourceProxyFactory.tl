local ISourceProxyFactory = require("LuaFramework.Binding.Proxy.Sources.ISourceProxyFactory")

local TypedSourceProxyFactory = class("TypedSourceProxyFactory", ISourceProxyFactory) as TypedSourceProxyFactoryType

function TypedSourceProxyFactory:ctor()
    ISourceProxyFactory.ctor(self)
end

function TypedSourceProxyFactory:IsSupported(description: SourceDescriptionType): boolean
    assert({description}, "")
    return true
end

function TypedSourceProxyFactory:CreateProxy(source: LuaObject, description: SourceDescriptionType): SourceProxyBaseType
    if not self:IsSupported(description) then
        return
    end

    local proxy: OutProxyType = {}
    if self:TryCreateProxy(source, description, proxy) then
        return proxy.ref as SourceProxyBaseType
    end

    return proxy.ref as SourceProxyBaseType
end

function TypedSourceProxyFactory:TryCreateProxy(source: LuaObject, description: SourceDescriptionType, proxy: OutProxyType): boolean
    assert({source, description, proxy}, "")
    return true
end

function TypedSourceProxyFactory:dtor()
end

return TypedSourceProxyFactory