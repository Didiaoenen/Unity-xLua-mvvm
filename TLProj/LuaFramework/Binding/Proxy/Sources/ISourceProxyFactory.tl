local ISourceProxyFactory = class("ISourceProxyFactory") as ISourceProxyFactoryType

function ISourceProxyFactory:ctor()
end

function ISourceProxyFactory:CreateProxy(source: LuaObject, description: SourceDescriptionType): SourceProxyBaseType
    assert({source, description}, "")
end

return ISourceProxyFactory