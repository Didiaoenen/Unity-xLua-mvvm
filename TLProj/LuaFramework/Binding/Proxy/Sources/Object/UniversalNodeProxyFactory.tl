local INodeProxyFactory = require("LuaFramework.Binding.Proxy.Sources.Object.INodeProxyFactory")
local MethodNodeProxy = require("LuaFramework.Binding.Proxy.Sources.Object.MethodNodeProxy")
local FieldOrPropertyNodeProxy = require("LuaFramework.Binding.Proxy.Sources.Object.FieldOrPropertyNodeProxy")
local InteractionNodeProxy = require("LuaFramework.Binding.Proxy.Sources.Object.InteractionNodeProxy")
local IInteractionRequest = require("LuaFramework.Interactivity.IInteractionRequest")

local UniversalNodeProxyFactory = class("UniversalNodeProxyFactory", INodeProxyFactory) as UniversalNodeProxyFactoryType

function UniversalNodeProxyFactory:ctor()
    INodeProxyFactory.ctor(self)
end

function UniversalNodeProxyFactory:Create(source: LuaObject, token: PathTokenType): SourceProxyBaseType
    local node = token.Current
    if nil == source then
        return
    end

    return self:CreateProxy(source, node)
end

function UniversalNodeProxyFactory:CreateProxy(source: LuaObject, node: string): SourceProxyBaseType
    local memberInfo = classget(source, node)

    if "userdata" == type(memberInfo) then
        return FieldOrPropertyNodeProxy.new(source, node) as SourceProxyBaseType
    end

    if "function" == type(memberInfo) then
        return MethodNodeProxy.new(source, node) as SourceProxyBaseType
    end

    if "table" == type(memberInfo) then
        if (memberInfo as LuaObject).is(IInteractionRequest) then
            return InteractionNodeProxy.new(source, node) as SourceProxyBaseType
        end
    end

    return FieldOrPropertyNodeProxy.new(source, node) as SourceProxyBaseType
end

function UniversalNodeProxyFactory:dtor()
end

return UniversalNodeProxyFactory
