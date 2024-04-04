local INodeProxyFactory = class("INodeProxyFactory") as INodeProxyFactoryType

function INodeProxyFactory:ctor()
end

function INodeProxyFactory:Create(source: LuaObject, token: PathTokenType): SourceProxyBaseType
    assert({source, token}, "")
end

return INodeProxyFactory