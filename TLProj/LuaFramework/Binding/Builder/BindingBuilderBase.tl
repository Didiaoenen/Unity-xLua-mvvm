local PathParse = require("LuaFramework.Binding.Paths.PathParse")
local StringExtension = require("LuaFramework.Common.StringExtension")
local BindingDescription = require("LuaFramework.Binding.BindingDescription")
local ObjectSourceDescription = require("LuaFramework.Binding.Proxy.Sources.Object.ObjectSourceDescription")
local BindingMode = require("LuaFramework.Binding.BindingMode")

local BindingBuilderBase = class("BindingBuilderBase") as BindingBuilderBaseType

function BindingBuilderBase:ctor(context: BindingContextType, target: LuaObject)
    assert(context and target, "")

    self.context = context
    self.target = target

    self.builded = false
    self.scopeKey = ""
    self.description = BindingDescription.new()
    self.description.Mode = BindingMode.Default
end

function BindingBuilderBase:SetMode(mode: number)
    self.description.Mode = mode
end

function BindingBuilderBase:SetScopeKey(scopeKey: string)
    self.scopeKey = scopeKey
end

function BindingBuilderBase:SetMemberPath(pathText: string)
    local paths = PathParse.Parse(pathText)
    self:SetMemberPathWithPath(paths)
end

function BindingBuilderBase:SetMemberPathWithPath(paths: {string})
    self.description.Source = ObjectSourceDescription.new(paths) as SourceDescriptionType
end

-- function BindingBuilderBase:SetStaticMemberPath(pathText: string)
--     local paths = PathParse.Parse(pathText)
--     self:SetStaticMemberPathWithPath(paths)
-- end

-- function BindingBuilderBase:SetStaticMemberPathWithPath(paths: {string})
--     self.description.Source = ObjectSourceDescription.new(paths) as SourceDescriptionType
-- end

function BindingBuilderBase:SetCommandParameter(...: any)
    assert({...}, "")
end

-- function BindingBuilderBase:SetSourceDescription(source: SourceDescriptionType)
--     self.description.Source = source;
-- end

-- function BindingBuilderBase:SetDescription(bindingDescription: BindingDescriptionType)
--     self.description.Mode = bindingDescription.Mode;
--     self.description.TargetName = bindingDescription.TargetName;
--     self.description.TargetType = bindingDescription.TargetType;
--     self.description.UpdateTrigger = bindingDescription.UpdateTrigger;
--     self.description.Converter = bindingDescription.Converter;
--     self.description.Source = bindingDescription.Source;
-- end

-- function BindingBuilderBase:ConverterByName(name: string)
-- end

function BindingBuilderBase:CheckBindingDescription()
    assert(not StringExtension.IsNilOrEmpty(self.description.TargetName), "")
    assert(self.description.Source, "")
end

function BindingBuilderBase:Build()
    if self.builded then
        return                
    end

    self:CheckBindingDescription()
    self.context:AddWithSingleDesc(self.target, self.description, self.scopeKey)
    self.builded = true
end

function BindingBuilderBase:dtor()
end

return BindingBuilderBase