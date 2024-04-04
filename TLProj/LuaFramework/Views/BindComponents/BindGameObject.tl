local ObservableObject = require("LuaFramework.Observables.ObservableObject")
local BindRectTransform = require("LuaFramework.Views.BindComponents.BindRectTransform")
local GameObjectExt = require("LuaFramework.Views.Components.GameObjectExt")

local BindGameObject = class("BindGameObject", ObservableObject) as BindGameObjectType

function BindGameObject.get:ActiveSelf(): boolean
    return self.activeSelf
end

function BindGameObject.set:ActiveSelf(value: boolean)
    self:Set({name = "activeSelf"}, value, "ActiveSelf")
end

function BindGameObject:ctor(name: string)
    ObservableObject.ctor(self)
    self.name = name
    self.transform = BindRectTransform.new() as BindTransformType
    self.activeSelf = true
end

function BindGameObject:BindWithName(view: ViewBaseType, modes: {number})
    self.gameObjectExt = view:GetGameObjectWithName(GameObjectExt, self.name)
    local bindingSet = view.bindingSet as BindingSetType

    local index: integer = 0
    local _Mode = function(): number
        index = #(modes) > 1 and index + 1 or 1
        return modes[index]
    end
    
    local builder = bindingSet:BindByTarget(self.gameObjectExt as LuaObject)
    builder:For(self.gameObjectExt.ActiveSelf):To(self.name .. ".ActiveSelf"):SetMode(_Mode())
end

function BindGameObject:dtor()
end

return BindGameObject