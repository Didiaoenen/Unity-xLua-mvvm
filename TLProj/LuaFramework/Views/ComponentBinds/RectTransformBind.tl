local TransformBind = require("LuaFramework.Views.ComponentBinds.TransformBind")
local RectTransformExt = require("LuaFramework.Views.ComponentExts.RectTransformExt")

local RectTransformBind = class("RectTransformBind", TransformBind) as RectTransformBindType

function RectTransformBind.get:OffsetMax(): CS.UnityEngine.Vector2
    return self.offsetMax
end

function RectTransformBind.set:OffsetMax(value: CS.UnityEngine.Vector2)
    self:Set({name = "offsetMax"}, value, "OffsetMax")
end

function RectTransformBind.get:OffsetMin(): CS.UnityEngine.Vector2
    return self.offsetMin
end

function RectTransformBind.set:OffsetMin(value: CS.UnityEngine.Vector2)
    self:Set({name = "offsetMin"}, value, "OffsetMin")
end

function RectTransformBind:ctor(name: string, parent: TransformExtType)
    TransformBind.ctor(self, name, parent)
    self.offsetMax = CS.UnityEngine.Vector2.zero
    self.offsetMin = CS.UnityEngine.Vector2.zero
end

function RectTransformBind:BindWithName(view: ViewBaseType, modes: {number})
    TransformBind.BindWithName(self as TransformBindType, view, modes)

    self.componentExt = view:GetComponentWithName(RectTransformExt as ComponentExtType, self.name) as RectTransformExtType
    -- local bindingSet = view.bindingSet as BindingSetType

    local index: integer = 0
    local _Mode = function(): number
        index = #(modes) > 1 and index + 1 or 1
        return modes[index]
    end
    
    self.bindingSet = view.bindingExt:CreateBindingSetWithContext(self)

    local builder = self.bindingSet:BindByTarget(self.componentExt as LuaObject)
    builder:For(self.componentExt.OffsetMax):To("OffsetMax"):SetMode(_Mode())

    builder = self.bindingSet:BindByTarget(self.componentExt as LuaObject)
    builder:For(self.componentExt.OffsetMin):To("OffsetMin"):SetMode(_Mode())

    self.bindingSet:Build()
end

function RectTransformBind:BindWithComponent(view: ViewBaseType, modes: {number})
    TransformBind.BindWithComponent(self as TransformBindType, view, modes)

    self.componentExt = view:GetComponent(RectTransformExt as ComponentExtType) as RectTransformExtType
    -- local bindingSet = view.bindingSet as BindingSetType

    local index: integer = 0
    local _Mode = function(): number
        index = #(modes) > 1 and index + 1 or 1
        return modes[index]
    end
    
    self.bindingSet = view.bindingExt:CreateBindingSetWithContext(self)

    local builder = self.bindingSet:BindByTarget(self.componentExt as LuaObject)
    builder:For(self.componentExt.OffsetMax):To("OffsetMax"):SetMode(_Mode())

    builder = self.bindingSet:BindByTarget(self.componentExt as LuaObject)
    builder:For(self.componentExt.OffsetMin):To("OffsetMin"):SetMode(_Mode())

    self.bindingSet:Build()
end

function RectTransformBind:dtor()
end

return RectTransformBind