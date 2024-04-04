local BindComponent = require("LuaFramework.Views.BindComponents.BindComponent")
local BindGameObject = require("LuaFramework.Views.BindComponents.BindGameObject")
local CanvasExt = require("LuaFramework.Views.Components.CanvasExt")

local BindCanvas = class("BindCanvas", BindComponent) as BindCanvasType

function BindCanvas.get:OverrideSorting(): boolean
    return self.overrideSorting
end

function BindCanvas.set:OverrideSorting(value: boolean)
    self:Set({name = "overrideSorting"}, value, "OverrideSorting")
end

function BindCanvas.get:SortingOrder(): number
    return self.sortingOrder
end

function BindCanvas.set:SortingOrder(value: number)
    self:Set({name = "sortingOrder"}, value, "SortingOrder")
end

function BindCanvas:ctor(name: string)
    BindComponent.ctor(self, name)
    self.gameObject = BindGameObject.new()
    self.overrideSorting = true
    self.sortingOrder = 0
end

function BindCanvas:BindWithName(view: ViewBaseType, modes: {number})
    self.componentExt = view:GetComponentWithName(CanvasExt as ComponentExtType, self.name) as CanvasExtType
    local bindingSet = view.bindingSet as BindingSetType

    local index: integer = 0
    local _Mode = function(): number
        index = #(modes) > 1 and index + 1 or 1
        return modes[index]
    end

    local builder = bindingSet:BindByTarget(self.componentExt as LuaObject)
    builder:For(self.componentExt.OverrideSorting):To(self.name .. ".OverrideSorting"):SetMode(_Mode())
    
    builder = bindingSet:BindByTarget(self.componentExt as LuaObject)
    builder:For(self.componentExt.SortingOrder):To(self.name .. ".SortingOrder"):SetMode(_Mode())
end

function BindCanvas:dtor()
end

return BindCanvas