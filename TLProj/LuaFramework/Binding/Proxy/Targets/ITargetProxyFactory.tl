local ITargetProxyFactory = class("ITargetProxyFactory") as ITargetProxyFactoryType

function ITargetProxyFactory:ctor()
end

function ITargetProxyFactory:CreateProxy(target: LuaObject, description: BindingDescriptionType): TargetProxyBaseType
    assert({target, description}, "")
end

return ITargetProxyFactory