local Miscellaneous = require("LuaFramework.Common.Miscellaneous")
local ITargetProxyFactory = require("LuaFramework.Binding.Proxy.Targets.ITargetProxyFactory")
local UnityFieldOrPropertyProxy = require("LuaFramework.Binding.Proxy.Targets.UGUI.UnityFieldOrPropertyProxy")
local UnityEventProxy = require("LuaFramework.Binding.Proxy.Targets.UGUI.UnityEventProxy")

local UnityTargetProxyFactory = class("UnityTargetProxyFactory", ITargetProxyFactory) as UnityTargetProxyFactoryType

function UnityTargetProxyFactory:ctor()
end

function UnityTargetProxyFactory:CreateProxy(target: LuaObject, description: BindingDescriptionType): TargetProxyBaseType
    local memberInfo = classget(target, description.TargetName)

    local updateTrigger: any = nil
    if nil ~= description.UpdateTrigger and "" ~= description.UpdateTrigger then
        updateTrigger = classget(target, description.UpdateTrigger)

        if nil == updateTrigger then
            return
        end
    end

    if "userdata" == type(memberInfo) then
        if Miscellaneous.CSType.UnityEventBaseT:IsAssignableFrom((memberInfo as CS.System.Object):GetType()) then
            return UnityEventProxy.new(target, description.TargetName) as TargetProxyBaseType
        end
    end
    
    return UnityFieldOrPropertyProxy.new(target, description.TargetName, description.UpdateTrigger) as TargetProxyBaseType
end

function UnityTargetProxyFactory:dtor()
end

return UnityTargetProxyFactory