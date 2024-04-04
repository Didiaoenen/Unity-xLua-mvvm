local FieldOrPropertyTargetProxy = require("LuaFramework.Binding.Proxy.Targets.Universal.FieldOrPropertyTargetProxy")
local BindingMode = require("LuaFramework.Binding.BindingMode")

local UnityFieldOrPropertyProxy = class("UnityFieldOrPropertyProxy", FieldOrPropertyTargetProxy) as UnityPropertyProxyType

function UnityFieldOrPropertyProxy.get:DefaultMode(): number
    return BindingMode.TwoWay
end

function UnityFieldOrPropertyProxy:ctor(target: LuaObject, propertyInfo: string, unityEvent: string)
    FieldOrPropertyTargetProxy.ctor(self, target, propertyInfo)
    self.unityEvent = unityEvent
end

function UnityFieldOrPropertyProxy:DoSubscribeForValueChange(target: LuaObject)
    if nil == self.unityEvent or nil == target then
        return
    end

    local unityEvent = classget(self.target, self.unityEvent) as CS.UnityEngine.Events.UnityEvent
    if unityEvent then
        unityEvent:AddListener(bindevent(self, self.OnValueChanged))
    end
end

function UnityFieldOrPropertyProxy:DoUnsubscribeForValueChange()
    local unityEvent = classget(self.target, self.unityEvent) as CS.UnityEngine.Events.UnityEvent
    if unityEvent then
        unityEvent:RemoveAllListeners()
    end
end

function UnityFieldOrPropertyProxy:OnValueChanged(...: any)
    assert({...}, "")
    self:RaiseValueChanged()
end

function UnityFieldOrPropertyProxy:dtor()
end

return UnityFieldOrPropertyProxy