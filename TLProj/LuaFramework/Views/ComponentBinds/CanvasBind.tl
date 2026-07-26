local ComponentBind = require("LuaFramework.Views.ComponentBinds.ComponentBind")
local GameObjectBind = require("LuaFramework.Views.ComponentBinds.GameObjectBind")
local CanvasExt = require("LuaFramework.Views.ComponentExts.CanvasExt")

local CanvasBind = class("CanvasBind", ComponentBind) as CanvasBindType

function CanvasBind.get:OverrideSorting(): boolean
    return self.overrideSorting
end

function CanvasBind.set:OverrideSorting(value: boolean)
    self:Set({name = "overrideSorting"}, value, "OverrideSorting")
end

function CanvasBind.get:SortingOrder(): number
    return self.sortingOrder
end

function CanvasBind.set:SortingOrder(value: number)
    self:Set({name = "sortingOrder"}, value, "SortingOrder")
end

function CanvasBind:ctor(name: string)
    ComponentBind.ctor(self, name)
    self.gameObject = GameObjectBind.new()
    self.overrideSorting = true
    self.sortingOrder = 0
end

function CanvasBind:BindWithName(view: ViewBaseType, modes: {number})
    self.componentExt = view:GetComponentWithName(CanvasExt as ComponentExtType, self.name) as CanvasExtType
    -- local bindingSet = view.bindingSet as BindingSetType

    local index: integer = 0
    local _Mode = function(): number
        index = #(modes) > 1 and index + 1 or 1
        return modes[index]
    end

    self.bindingSet = view.bindingExt:CreateBindingSetWithContext(self)

    local builder = self.bindingSet:BindByTarget(self.componentExt as LuaObject)
    builder:For(self.componentExt.OverrideSorting):To("OverrideSorting"):SetMode(_Mode())
    
    builder = self.bindingSet:BindByTarget(self.componentExt as LuaObject)
    builder:For(self.componentExt.SortingOrder):To("SortingOrder"):SetMode(_Mode())

    self.bindingSet:Build()
end

function CanvasBind:BindWithComponent(view: ViewBaseType, modes: {number})
    self.componentExt = view:GetComponent(CanvasExt as ComponentExtType) as CanvasExtType
    -- local bindingSet = view.bindingSet as BindingSetType

    if nil == self.componentExt then
        self.componentExt = view:AddComponent(CanvasExt) as CanvasExtType
    end

    local index: integer = 0
    local _Mode = function(): number
        index = #(modes) > 1 and index + 1 or 1
        return modes[index]
    end

    self.bindingSet = view.bindingExt:CreateBindingSetWithContext(self)

    local builder = self.bindingSet:BindByTarget(self.componentExt as LuaObject)
    builder:For(self.componentExt.OverrideSorting):To("OverrideSorting"):SetMode(_Mode())
    
    builder = self.bindingSet:BindByTarget(self.componentExt as LuaObject)
    builder:For(self.componentExt.SortingOrder):To("SortingOrder"):SetMode(_Mode())

    self.bindingSet:Build()
end

function CanvasBind:dtor()
end

return CanvasBind