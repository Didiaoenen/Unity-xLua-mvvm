local ISourceProxyFactoryRegistry = class("ISourceProxyFactoryRegistry") as ISourceProxyFactoryRegistryType

function ISourceProxyFactoryRegistry:ctor()
end

function ISourceProxyFactoryRegistry:Register(factory: ISourceProxyFactoryType, priority: number)
    assert({factory, priority}, "")
end

function ISourceProxyFactoryRegistry:Unregister(factory: ISourceProxyFactoryType)
    assert({factory}, "")
end

return ISourceProxyFactoryRegistry