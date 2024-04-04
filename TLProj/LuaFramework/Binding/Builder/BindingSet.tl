local BindingSetBase = require("LuaFramework.Binding.Builder.BindingSetBase")
local BindingBuilder = require("LuaFramework.Binding.Builder.BindingBuilder")

local BindingSet = class("BindingSet", BindingSetBase) as BindingSetType

function BindingSet:ctor(context: BindingContextType, target: LuaObject)
    BindingSetBase.ctor(self, context)
    self.target = target
end

function BindingSet:Bind(): BindingBuilderType
    local builder = BindingBuilder.new(self.context, self.target)
    table.insert(self.builders, builder as BindingBuilderBaseType)
    return builder
end

function BindingSet:BindByTarget(target: LuaObject): BindingBuilderType
    local builder = BindingBuilder.new(self.context, target)
    table.insert(self.builders, builder as BindingBuilderBaseType)
    return builder
end

function BindingSet:dtor()
end

return BindingSet