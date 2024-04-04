local INodeProxyFactoryRegister = require("LuaFramework.Binding.Proxy.Sources.Object.INodeProxyFactoryRegister")
local INodeProxyFactory = require("LuaFramework.Binding.Proxy.Sources.Object.INodeProxyFactory")
local TypedSourceProxyFactory = require("LuaFramework.Binding.Proxy.Sources.TypedSourceProxyFactory")
local ChainedObjectSourceProxy = require("LuaFramework.Binding.Proxy.Sources.Object.ChainedObjectSourceProxy")
local PathToken = require("LuaFramework.Binding.Paths.PathToken")

local ObjectSourceProxyFactory = class("ObjectSourceProxyFactory", TypedSourceProxyFactory, INodeProxyFactory, INodeProxyFactoryRegister) as ObjectSourceProxyFactoryType

function ObjectSourceProxyFactory:ctor()
    TypedSourceProxyFactory.ctor(self)
    INodeProxyFactory.ctor(self)
    INodeProxyFactoryRegister.ctor(self)
    self.factories = {}        
end

function ObjectSourceProxyFactory:TryCreateProxy(source: LuaObject, description: SourceDescriptionType, proxy: OutProxyType): boolean
    local paths = (description as ObjectSourceDescriptionType).Paths
    assert(#(paths) > 0)

    local token = PathToken.new(paths, 1)

    if #paths == 1 then
        proxy.ref = self:Create(source, token) as LuaObject
        if proxy.ref then
            return true
        end
        return false
    end

    proxy.ref = ChainedObjectSourceProxy.new(source, token, self) as LuaObject
    return true
end

function ObjectSourceProxyFactory:Create(source: LuaObject, token: PathTokenType): SourceProxyBaseType
    local proxy: OutProxyType = {}
    for _, v in ipairs(self.factories) do
        local factory = v.factory
        if factory then
            proxy.ref = (factory as INodeProxyFactoryType):Create(source, token) as LuaObject
            if proxy.ref then
                return proxy.ref as SourceProxyBaseType
            end
        end
    end

    return proxy.ref as SourceProxyBaseType
end

function ObjectSourceProxyFactory:Register(factory: INodeProxyFactoryType, priority: number)
    if nil == factory then
        return    
    end

    table.insert(self.factories, {factory = factory as LuaObject, priority = priority or 100})
    table.sort(self.factories, function (a: PriorityFactoryPairType, b: PriorityFactoryPairType): boolean
        return a.priority > b.priority
    end)
end

function ObjectSourceProxyFactory:Unregister(factory: INodeProxyFactoryType)
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

function ObjectSourceProxyFactory:dtor()
end

return ObjectSourceProxyFactory