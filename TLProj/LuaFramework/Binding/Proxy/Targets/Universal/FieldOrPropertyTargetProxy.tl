local ValueTargetProxyBase = require("LuaFramework.Binding.Proxy.Targets.ValueTargetProxyBase")
local UnityProxyRegister = require("LuaFramework.Binding.UnityProxyRegister")
local TableOprationMode = require("LuaFramework.Binding.TableOprationMode")
local BindingMode = require("LuaFramework.Binding.BindingMode")

local FieldOrPropertyTargetProxy = class("FieldOrPropertyTargetProxy", ValueTargetProxyBase) as PropertyTargetProxyType

function FieldOrPropertyTargetProxy.get:DefaultMode(): number
    return BindingMode.TwoWay
end

function FieldOrPropertyTargetProxy:ctor(target: LuaObject, propertyInfo: string)
    ValueTargetProxyBase.ctor(self, target)
    self.propertyInfo = propertyInfo
end

function FieldOrPropertyTargetProxy:DoSubscribeForValueChange(target: LuaObject)
    local targetNotify = target as INotifyPropertyChangedType
    targetNotify.PropertyChanged = {opt = TableOprationMode.Add, save = self.propertyInfo, this = self, callback = self.OnPropertyChanged}
end

function FieldOrPropertyTargetProxy:DoUnsubscribeForValueChange(target: LuaObject)
    local targetNotify = target as INotifyPropertyChangedType
    targetNotify.PropertyChanged = {opt = TableOprationMode.Remove, save = self.propertyInfo}
end

function FieldOrPropertyTargetProxy:OnPropertyChanged(sender: LuaObject, e: PropertyChangedEventArgsType)
    assert({sender, e}, "")
    local name = e.PropertyName
    if nil == name or "" == name or self.propertyInfo == name then
        local target = self.target
        if nil == target then
            return
        end

        self:RaiseValueChanged()
    end
end

function FieldOrPropertyTargetProxy:GetValue(): any
    local target = self.target
    if nil == target then
        return
    end

    local proxyInfo = UnityProxyRegister.Instance:Get(self.propertyInfo)
    if proxyInfo then
        return proxyInfo.getter(target)
    else
        return classget(self.target, self.propertyInfo)
    end
end

function FieldOrPropertyTargetProxy:SetValue(value)
    local target = self.target
    if nil == target then
        return
    end

    local proxyInfo = UnityProxyRegister.Instance:Get(self.propertyInfo)
    if proxyInfo then
        proxyInfo.setter(target, value)
    else
        classset(self.target, self.propertyInfo, value)
    end
end

function FieldOrPropertyTargetProxy:dtor()
end

return FieldOrPropertyTargetProxy