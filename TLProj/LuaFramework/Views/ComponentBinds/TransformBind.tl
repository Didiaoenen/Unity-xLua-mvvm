local ComponentBind = require("LuaFramework.Views.ComponentBinds.ComponentBind")
local TransformExt = require("LuaFramework.Views.ComponentExts.TransformExt")

local TransformBind = class("TransformBind", ComponentBind) as TransformBindType

function TransformBind.get:Parent(): TransformExtType
    return self.parent
end

function TransformBind.set:Parent(value: TransformExtType)
    self:Set({name = "parent"}, value, "Parent")
    self.localRotation = self.componentExt.localRotation
    self.localPosition = self.componentExt.localPosition
    self.localScale = self.componentExt.localScale
end

function TransformBind.get:LocalRotation(): CS.UnityEngine.Quaternion
    return self.localRotation
end

function TransformBind.set:LocalRotation(value: CS.UnityEngine.Quaternion)
    self:Set({name = "localRotation"}, value, "LocalRotation")
end

function TransformBind.get:LocalPosition(): CS.UnityEngine.Vector3
    return self.localPosition
end

function TransformBind.set:LocalPosition(value: CS.UnityEngine.Vector3)
    self:Set({name = "localPosition"}, value, "LocalPosition")
end

function TransformBind.get:LocalScale(): CS.UnityEngine.Vector3
    return self.localScale
end

function TransformBind.set:LocalScale(value: CS.UnityEngine.Vector3)
    self:Set({name = "localScale"}, value, "LocalScale")
end

function TransformBind:ctor(name: string, parent: TransformExtType)
    ComponentBind.ctor(self, name)
    self.parent = parent
    
    self.localRotation = CS.UnityEngine.Quaternion.identity
    self.localPosition = CS.UnityEngine.Vector3.zero
    self.localScale = CS.UnityEngine.Vector3.one
end

function TransformBind:BindWithName(view: ViewBaseType, modes: {number})
    self.componentExt = view:GetComponentWithName(TransformExt as ComponentExtType, self.name) as TransformExtType
    -- local bindingSet = view.bindingSet as BindingSetType

    local index: integer = 0
    local _Mode = function(): number
        index = #(modes) > 1 and index + 1 or 1
        return modes[index]
    end

    self.bindingSet = view.bindingExt:CreateBindingSetWithContext(self)

    local builder = self.bindingSet:BindByTarget(self.componentExt as LuaObject)
    builder:For(self.componentExt.Parent):To("Parent"):SetMode(_Mode())

    builder = self.bindingSet:BindByTarget(self.componentExt as LuaObject)
    builder:For(self.componentExt.LocalRotation):To("LocalRotation"):SetMode(_Mode())

    builder = self.bindingSet:BindByTarget(self.componentExt as LuaObject)
    builder:For(self.componentExt.LocalPosition):To("LocalPosition"):SetMode(_Mode())

    builder = self.bindingSet:BindByTarget(self.componentExt as LuaObject)
    builder:For(self.componentExt.LocalScale):To("LocalScale"):SetMode(_Mode())

    self.bindingSet:Build()
end

function TransformBind:BindWithComponent(view: ViewBaseType, modes: {number})
    self.componentExt = view:GetComponent(TransformExt as ComponentExtType) as TransformExtType
    -- local bindingSet = view.bindingSet as BindingSetType

    local index: integer = 0
    local _Mode = function(): number
        index = #(modes) > 1 and index + 1 or 1
        return modes[index]
    end

    self.bindingSet = view.bindingExt:CreateBindingSetWithContext(self)

    local builder = self.bindingSet:BindByTarget(self.componentExt as LuaObject)
    builder:For(self.componentExt.Parent):To("Parent"):SetMode(_Mode())

    builder = self.bindingSet:BindByTarget(self.componentExt as LuaObject)
    builder:For(self.componentExt.LocalRotation):To("LocalRotation"):SetMode(_Mode())

    builder = self.bindingSet:BindByTarget(self.componentExt as LuaObject)
    builder:For(self.componentExt.LocalPosition):To("LocalPosition"):SetMode(_Mode())

    builder = self.bindingSet:BindByTarget(self.componentExt as LuaObject)
    builder:For(self.componentExt.LocalScale):To("LocalScale"):SetMode(_Mode())

    self.bindingSet:Build()
end

function TransformBind:dtor()
end

return TransformBind