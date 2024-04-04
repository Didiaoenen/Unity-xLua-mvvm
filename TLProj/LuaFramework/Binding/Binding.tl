local AbstractBinding = require("LuaFramework.Binding.AbstractBinding")
local INotifiable = require("LuaFramework.Binding.Proxy.INotifiable")
local BindingMode = require("LuaFramework.Binding.BindingMode")

local Binding = class("Binding", AbstractBinding) as BindingType

function Binding.get:BindingMode(): number
    if self.bindingMode ~= BindingMode.Default then
        return self.bindingMode
    end

    self.bindingMode = self.bindingDescription.Mode
    if self.bindingMode == BindingMode.Default then
        self.bindingMode = self.targetProxy.DefaultMode
    end

    return self.bindingMode
end

function Binding:ctor(source: LuaObject, target: LuaObject, bindingDescription: BindingDescriptionType, sourceProxyFactory: ISourceProxyFactoryType, targetProxyFactory: ITargetProxyFactoryType)
    AbstractBinding.ctor(self, source, target)
    
    self.bindingMode = BindingMode.Default
    self.bindingDescription = bindingDescription

    self.sourceProxyFactory = sourceProxyFactory
    self.targetProxyFactory = targetProxyFactory

    self:CreateTargetProxy(target, self.bindingDescription)
    self:CreateSourceProxy(self.dataContext, self.bindingDescription.Source)
    self:UpdateDataOnBind()
end

function Binding:CreateTargetProxy(target: LuaObject, description: BindingDescriptionType)
    self:DisposeTargetProxy()

    self.targetProxy = self.targetProxyFactory:CreateProxy(target, description)

    if "table" == type(self.targetProxy) then
        if self:IsSubscribeTargetValueChanged(self.BindingMode) and (self.targetProxy as LuaObject).is(INotifiable) then
            local targetProxy = self.targetProxy as INotifiableType
            targetProxy.ValueChanged = {this = self, callback = self.UpdateSourceFromTarget}
        end
    end
end

function Binding:IsSubscribeTargetValueChanged(bindingMode: number): boolean
    if bindingMode == BindingMode.Default then
        return true
    elseif bindingMode == BindingMode.OneWay then
        return false
    elseif bindingMode == BindingMode.OneTime then
        return false
    elseif bindingMode == BindingMode.TwoWay then
        return true
    elseif bindingMode == BindingMode.OneWayToSource then
        return true
    end
end

function Binding:DisposeTargetProxy()
    if self.targetProxy then
        self.targetProxy:delete()
        self.targetProxy = nil
    end 
end

function Binding:CreateSourceProxy(source: LuaObject, description: SourceDescriptionType)
    self:DisposeSourceProxy()

    self.sourceProxy = self.sourceProxyFactory:CreateProxy(source, description)

    if "table" == type(self.sourceProxy) then
        if self:IsSubscribeSourceValueChanged(self.BindingMode) and (self.sourceProxy as LuaObject).is(INotifiable) then
            local sourceProxy = self.sourceProxy as INotifiableType
            sourceProxy.ValueChanged = {this = self, callback = self.UpdateTargetFromSource}
        end
    end
end

function Binding:IsSubscribeSourceValueChanged(bindingMode: number): boolean
    if bindingMode == BindingMode.Default then
        return true
    elseif bindingMode == BindingMode.OneWay then
        return true
    elseif bindingMode == BindingMode.TwoWay then
        return true
    elseif bindingMode == BindingMode.OneTime then
        return false
    elseif bindingMode == BindingMode.OneWayToSource then
        return false
    end
end

function Binding:DisposeSourceProxy()
    if self.sourceProxy then
        self.sourceProxy:delete()
        self.sourceProxy = nil
    end 
end

function Binding:UpdateTargetFromSource()
    local sourceProxy = self.sourceProxy as IObtainableType
    local value = sourceProxy:GetValue()
    self:SetTargetValue(self.targetProxy as LuaObject, value)
end

function Binding:SetTargetValue(modifier: LuaObject, value: any)
    if modifier then
        (modifier as IModifiableType):SetValue(value)
    end
end

function Binding:UpdateSourceFromTarget()
    local targetProxy = self.targetProxy as IObtainableType
    local value = targetProxy:GetValue()
    self:SetSourceValue(self.sourceProxy as LuaObject, value)
end

function Binding:SetSourceValue(modifier: LuaObject, value: any)
    if modifier then
        (modifier as IModifiableType):SetValue(value)
    end 
end

function Binding:UpdateDataOnBind()
    if self:UpdateTargetOnFirstBind(self.BindingMode) and self.sourceProxy then
        self:UpdateTargetFromSource()
    end

    if self:UpdateSourceOnFirstBind(self.BindingMode) and self.targetProxy then
        self:UpdateSourceFromTarget()
    end
end

function Binding:UpdateTargetOnFirstBind(bindingMode: number): boolean
    if bindingMode == BindingMode.Default then
        return true
    elseif bindingMode == BindingMode.OneWay then
        return true
    elseif bindingMode == BindingMode.OneTime then
        return true
    elseif bindingMode == BindingMode.TwoWay then
        return true
    elseif bindingMode == BindingMode.OneWayToSource then
        return false
    end
end

function Binding:UpdateSourceOnFirstBind(bindingMode: number): boolean
    if bindingMode == BindingMode.OneWayToSource then
        return true
    elseif bindingMode == BindingMode.Default then
        return false
    elseif bindingMode == BindingMode.OneWay then
        return false
    elseif bindingMode == BindingMode.OneTime then
        return false
    elseif bindingMode == BindingMode.TwoWay then
        return false
    end
end

function Binding:dtor()
end

return Binding