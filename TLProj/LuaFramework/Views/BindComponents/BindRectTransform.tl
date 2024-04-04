local BindTransform = require("LuaFramework.Views.BindComponents.BindTransform")
local RectTransformExt = require("LuaFramework.Views.Components.RectTransformExt")

local BindRectTransform = class("BindRectTransform", BindTransform) as BindRectTransformType

function BindRectTransform.get:OffsetMax(): CS.UnityEngine.Vector2
    return self.offsetMax
end

function BindRectTransform.set:OffsetMax(value: CS.UnityEngine.Vector2)
    self:Set({name = "offsetMax"}, value, "OffsetMax")
end

function BindRectTransform.get:OffsetMin(): CS.UnityEngine.Vector2
    return self.offsetMin
end

function BindRectTransform.set:OffsetMin(value: CS.UnityEngine.Vector2)
    self:Set({name = "offsetMin"}, value, "OffsetMin")
end

function BindRectTransform:ctor(name: string)
    BindTransform.ctor(self, name)
    self.offsetMax = CS.UnityEngine.Vector2.zero
    self.offsetMin = CS.UnityEngine.Vector2.zero
end

function BindRectTransform:BindWithName(view: ViewBaseType, modes: {number})
    BindTransform.BindWithName(self as BindTransformType, view, modes)

    self.componentExt = view:GetComponentWithName(RectTransformExt as ComponentExtType, self.name) as RectTransformExtType
    local bindingSet = view.bindingSet as BindingSetType

    local index: integer = 0
    local _Mode = function(): number
        index = #(modes) > 1 and index + 1 or 1
        return modes[index]
    end
    
    local builder = bindingSet:BindByTarget(self.componentExt as LuaObject)
    builder:For(self.componentExt.OffsetMax):To(self.name .. ".OffsetMax"):SetMode(_Mode())

    builder = bindingSet:BindByTarget(self.componentExt as LuaObject)
    builder:For(self.componentExt.OffsetMin):To(self.name .. ".OffsetMin"):SetMode(_Mode())
end

function BindRectTransform:dtor()
end

return BindRectTransform