local NotifiableSourceProxyBase = require("LuaFramework.Binding.Proxy.Sources.NotifiableSourceProxyBase")
local INotifyPropertyChanged = require("LuaFramework.Binding.INotifyPropertyChanged")
local UnityProxyRegister = require("LuaFramework.Binding.UnityProxyRegister")
local TableOprationMode = require("LuaFramework.Binding.TableOprationMode")

local FieldOrPropertyNodeProxy = class("FieldOrPropertyNodeProxy", NotifiableSourceProxyBase) as PropertyNodeProxyType

function FieldOrPropertyNodeProxy:ctor(source: LuaObject, propertyInfo: string)
    NotifiableSourceProxyBase.ctor(self, source)
    self.propertyInfo = propertyInfo

    if nil == source then
        return
    end

    if self.source.is and self.source.is(INotifyPropertyChanged) then
        local sourceNotify = self.source as INotifyPropertyChangedType
        sourceNotify.PropertyChanged = {opt = TableOprationMode.Add, save = self.propertyInfo, this = self, callback = self.OnPropertyChanged}
    end    
end

function FieldOrPropertyNodeProxy:OnPropertyChanged(sender: LuaObject, e: PropertyChangedEventArgsType)
    assert({sender, e}, "")
    local name = e.PropertyName
    if nil == name or "" == name or self.propertyInfo == name then
        self:RaiseValueChanged()
    end
end

function FieldOrPropertyNodeProxy:GetValue(): any
    local source = self.source
    if nil == source then
        return
    end

    local proxyInfo = UnityProxyRegister.Instance:Get(self.propertyInfo)
    if proxyInfo then
        return proxyInfo.getter(source)
    else
        return classget(self.source, self.propertyInfo)
    end
end

function FieldOrPropertyNodeProxy:SetValue(value: any)
    local source = self.source
    if nil == source then
        return
    end

    local proxyInfo = UnityProxyRegister.Instance:Get(self.propertyInfo)
    if proxyInfo then
        proxyInfo.setter(source, value)
    else
        classset(self.source, self.propertyInfo, value)
    end
end

function FieldOrPropertyNodeProxy:dtor()
end

return FieldOrPropertyNodeProxy