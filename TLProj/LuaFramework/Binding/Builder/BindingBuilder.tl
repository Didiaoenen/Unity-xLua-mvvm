local BindingBuilderBase = require("LuaFramework.Binding.Builder.BindingBuilderBase")
local BindingMode = require("LuaFramework.Binding.BindingMode")

local BindingBuilder = class("BindingBuilder", BindingBuilderBase) as BindingBuilderType

function BindingBuilder:ctor(context: BindingContextType, target: LuaObject)
    BindingBuilderBase.ctor(self, context, target)
end

function BindingBuilder:For(targetName: string, updateTrigger: string): BindingBuilderType
    self.description.TargetName = targetName
    self.description.UpdateTrigger = updateTrigger
    local target = classget(self.target, self.description.TargetName)
    if "function" == type(target) then
        self:OneWayToSource()
    end
    return self
end

function BindingBuilder:To(path: string): BindingBuilder
    self:SetMemberPath(path)
    return self    
end

function BindingBuilder:OneWay(): BindingBuilder
    self:SetMode(BindingMode.OneWay)
    return self    
end

function BindingBuilder:OneWayToSource(): BindingBuilder
    self:SetMode(BindingMode.OneWayToSource)
    return self    
end

function BindingBuilder:TwoWay(): BindingBuilder
    self:SetMode(BindingMode.TwoWay)
    return self    
end

function BindingBuilder:OneTime(): BindingBuilder
    self:SetMode(BindingMode.OneTime)
    return self    
end

function BindingBuilder:CommandParameter(...: any): BindingBuilder
    self:SetCommandParameter(...)
    return self    
end

function BindingBuilder:dtor()
end

return BindingBuilder