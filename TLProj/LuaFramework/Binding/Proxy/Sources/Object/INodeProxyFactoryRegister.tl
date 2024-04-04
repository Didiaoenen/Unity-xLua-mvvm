local INodeProxyFactoryRegister = class("INodeProxyFactoryRegister") as INodeProxyFactoryRegisterType

function INodeProxyFactoryRegister:ctor()
end

function INodeProxyFactoryRegister:Register(factory: INodeProxyFactoryType, priority: number)
    assert({factory, priority}, "")
end

function INodeProxyFactoryRegister:Unregister(factory: INodeProxyFactoryType)
    assert({factory}, "")
end

return INodeProxyFactoryRegister