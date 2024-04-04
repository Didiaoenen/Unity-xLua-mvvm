local BindComponent = require("LuaFramework.Views.BindComponents.BindComponent")
local TransformExt = require("LuaFramework.Views.Components.TransformExt")

local BindTransform = class("BindTransform", BindComponent) as BindTransformType

function BindTransform.get:Parent(): TransformExtType
    return self.parent
end

function BindTransform.set:Parent(value: TransformExtType)
    self:Set({name = "parent"}, value, "Parent")
end

function BindTransform.get:LocalRotation(): CS.UnityEngine.Quaternion
    return self.localRotation
end

function BindTransform.set:LocalRotation(value: CS.UnityEngine.Quaternion)
    self:Set({name = "localRotation"}, value, "LocalRotation")
end

function BindTransform.get:LocalPosition(): CS.UnityEngine.Vector3
    return self.localPosition
end

function BindTransform.set:LocalPosition(value: CS.UnityEngine.Vector3)
    self:Set({name = "localPosition"}, value, "LocalPosition")
end

function BindTransform.get:LocalScale(): CS.UnityEngine.Vector3
    return self.localScale
end

function BindTransform.set:LocalScale(value: CS.UnityEngine.Vector3)
    self:Set({name = "localScale"}, value, "LocalScale")
end

function BindTransform:ctor(name: string)
    BindComponent.ctor(self, name)
    self.parent = nil
    self.localRotation = CS.UnityEngine.Quaternion.identity
    self.localPosition = CS.UnityEngine.Vector3.zero
    self.localScale = CS.UnityEngine.Vector3.one
end

function BindTransform:BindWithName(view: ViewBaseType, modes: {number})
    self.componentExt = view:GetComponentWithName(TransformExt as ComponentExtType, self.name) as TransformExtType
    local bindingSet = view.bindingSet as BindingSetType

    local index: integer = 0
    local _Mode = function(): number
        index = #(modes) > 1 and index + 1 or 1
        return modes[index]
    end

    local builder = bindingSet:BindByTarget(self.componentExt as LuaObject)
    builder:For(self.componentExt.Parent):To(self.name .. ".Parent"):SetMode(_Mode())

    builder = bindingSet:BindByTarget(self.componentExt as LuaObject)
    builder:For(self.componentExt.LocalRotation):To(self.name .. ".LocalRotation"):SetMode(_Mode())

    builder = bindingSet:BindByTarget(self.componentExt as LuaObject)
    builder:For(self.componentExt.LocalPosition):To(self.name .. ".LocalPosition"):SetMode(_Mode())

    builder = bindingSet:BindByTarget(self.componentExt as LuaObject)
    builder:For(self.componentExt.LocalScale):To(self.name .. ".LocalScale"):SetMode(_Mode())
end

function BindTransform:dtor()
end

return BindTransform