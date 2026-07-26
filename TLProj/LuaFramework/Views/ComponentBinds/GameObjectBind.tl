local ObservableObject = require("LuaFramework.Observables.ObservableObject")
local RectTransformBind = require("LuaFramework.Views.ComponentBinds.RectTransformBind")
local GameObjectExt = require("LuaFramework.Views.ComponentExts.GameObjectExt")

local GameObjectBind = class("GameObjectBind", ObservableObject) as GameObjectBindType

function GameObjectBind.get:ActiveSelf(): boolean
    return self.activeSelf
end

function GameObjectBind.set:ActiveSelf(value: boolean)
    self:Set({name = "activeSelf"}, value, "ActiveSelf")
end

function GameObjectBind:ctor(name: string)
    ObservableObject.ctor(self)
    self.name = name
    self.transform = RectTransformBind.new()
    self.activeSelf = true
end

function GameObjectBind:BindWithName(view: ViewBaseType, modes: {number})
    self.gameObjectExt = view:GetGameObjectWithName(GameObjectExt, self.name)
    -- local bindingSet = view.bindingSet as BindingSetType

    local index: integer = 0
    local _Mode = function(): number
        index = #(modes) > 1 and index + 1 or 1
        return modes[index]
    end

    self.bindingSet = view.bindingExt:CreateBindingSetWithContext(self)
    
    local builder = self.bindingSet:BindByTarget(self.gameObjectExt as LuaObject)
    builder:For(self.gameObjectExt.ActiveSelf):To("ActiveSelf"):SetMode(_Mode())

    self.bindingSet:Build()
end

function GameObjectBind:BindWithObject(view: ViewBaseType, luaObject: LuaObject, modes: {number})
    self.gameObjectExt = luaObject as GameObjectExtType
    -- local bindingSet = view.bindingSet as BindingSetType

    local index: integer = 0
    local _Mode = function(): number
        index = #(modes) > 1 and index + 1 or 1
        return modes[index]
    end

    self.bindingSet = view.bindingExt:CreateBindingSetWithContext(self)
    
    local builder = self.bindingSet:BindByTarget(self.gameObjectExt as LuaObject)
    builder:For(self.gameObjectExt.ActiveSelf):To("ActiveSelf"):SetMode(_Mode())

    self.bindingSet:Build()
end

function GameObjectBind:dtor()
end

return GameObjectBind