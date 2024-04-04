local ISourceProxyFactory = require("LuaFramework.Binding.Proxy.Sources.ISourceProxyFactory")
local ISourceProxyFactoryRegistry = require("LuaFramework.Binding.Proxy.Sources.ISourceProxyFactoryRegistry")

local SourceProxyFactory = class("SourceProxyFactory", ISourceProxyFactory, ISourceProxyFactoryRegistry) as SourceProxyFactoryType

function SourceProxyFactory:ctor()
    ISourceProxyFactory.ctor(self)
    ISourceProxyFactoryRegistry.ctor(self)
    self.factories = {}
end

function SourceProxyFactory:CreateProxy(source: LuaObject, description: SourceDescriptionType): SourceProxyBaseType
    if nil == source then
        return
    end

    local proxy: OutProxyType = {}
    if self:TryCreateProxy(source, description, proxy) then
        return proxy.ref as SourceProxyBaseType
    end
end

function SourceProxyFactory:TryCreateProxy(source: LuaObject, description: SourceDescriptionType, proxy: OutProxyType): boolean
    for _, v in ipairs(self.factories) do
        local factory = v.factory
        if factory then
            proxy.ref = (factory as ISourceProxyFactoryType):CreateProxy(source, description) as LuaObject
            if proxy.ref then
                return true
            end
        end
    end
    return false
end

function SourceProxyFactory:Register(factory: ISourceProxyFactoryType, priority: number)
    if nil == factory then
        return        
    end

    table.insert(self.factories, {factory = factory as LuaObject, priority = priority or 100})
    table.sort(self.factories, function(a: PriorityFactoryPairType, b: PriorityFactoryPairType): boolean
        return a.priority > b.priority
    end)
end

function SourceProxyFactory:Unregister(factory: ISourceProxyFactoryType)
    if nil == factory then
        return
    end

    for i, v in ipairs(self.factories) do
        if v.factory == factory as LuaObject then
            table.remove(self.factories, i)
            return
        end
    end
end

function SourceProxyFactory:dtor()
end

return SourceProxyFactory