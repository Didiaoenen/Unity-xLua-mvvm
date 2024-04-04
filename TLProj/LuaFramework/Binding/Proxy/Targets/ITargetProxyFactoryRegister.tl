local ITargetProxyFactoryRegister = class("ITargetProxyFactoryRegister") as ITargetProxyFactoryRegisterType

function ITargetProxyFactoryRegister:ctor()
end

function ITargetProxyFactoryRegister:Register(factory: ITargetProxyFactoryType, priority: number)
    assert({factory, priority}, "")
end

function ITargetProxyFactoryRegister:Unregister(factory: ITargetProxyFactoryType)
    assert({factory}, "")
end

return ITargetProxyFactoryRegister