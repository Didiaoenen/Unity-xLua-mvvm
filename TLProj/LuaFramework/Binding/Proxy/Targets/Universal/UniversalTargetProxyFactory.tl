local ITargetProxyFactory = require("LuaFramework.Binding.Proxy.Targets.ITargetProxyFactory")
local FieldOrPropertyTargetProxy = require("LuaFramework.Binding.Proxy.Targets.Universal.FieldOrPropertyTargetProxy")
local InteractionTargetProxy = require("LuaFramework.Binding.Proxy.Targets.Universal.InteractionTargetProxy")
local MethodTargetProxy = require("LuaFramework.Binding.Proxy.Targets.Universal.MethodTargetProxy")
local IInteractionAction = require("LuaFramework.Interactivity.IInteractionAction")

local UniversalTargetProxyFactory = class("UniversalTargetProxyFactory", ITargetProxyFactory) as UniversalTargetProxyFactoryType

function UniversalTargetProxyFactory:ctor()
    ITargetProxyFactory.ctor(self)
end

function UniversalTargetProxyFactory:CreateProxy(target: LuaObject, description: BindingDescriptionType): TargetProxyBaseType
    local memberInfo = classget(target, description.TargetName)

    if "userdata" == type(memberInfo) then
        return FieldOrPropertyTargetProxy.new(target, description.TargetName) as TargetProxyBaseType
    end

    if "function" == type(memberInfo) then
        return MethodTargetProxy.new(target, description.TargetName) as TargetProxyBaseType
    end

    if "table" == type(memberInfo) then
        if (memberInfo as LuaObject).is(IInteractionAction) then
            return InteractionTargetProxy.new(target, description.TargetName) as TargetProxyBaseType
        end
    end

    return FieldOrPropertyTargetProxy.new(target, description.TargetName) as TargetProxyBaseType
end

function UniversalTargetProxyFactory:dtor()
end

return UniversalTargetProxyFactory