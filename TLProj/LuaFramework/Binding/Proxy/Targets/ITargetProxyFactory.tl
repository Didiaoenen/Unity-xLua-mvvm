local ITargetProxyFactory = class("ITargetProxyFactory") as ITargetProxyFactoryType

function ITargetProxyFactory:ctor()
end

function ITargetProxyFactory:CreateProxy(target: LuaObject, discription: BindingDescriptionType): TargetProxyBaseType
    assert({target, discription}, "")
end

return ITargetProxyFactory