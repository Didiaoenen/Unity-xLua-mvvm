local BindComponent = require("LuaFramework.Views.BindComponents.BindComponent")
local BindGameObject = require("LuaFramework.Views.BindComponents.BindGameObject")
local CanvasGroupExt = require("LuaFramework.Views.Components.CanvasGroupExt")

local BindCanvasGroup = class("BindCanvasGroup", BindComponent) as BindCanvasGroupType

function BindCanvasGroup.get:Alpha(): number
    return self.alpha
end

function BindCanvasGroup.set:Alpha(value: number)
    self:Set({name = "alpha"}, value, "Alpha")
end

function BindCanvasGroup:ctor(name: string)
    BindComponent.ctor(self, name)
    self.gameObject = BindGameObject.new()
    self.alpha = 1
end

function BindCanvasGroup:BindWithName(view: ViewBaseType, modes: {number})
    self.componentExt = view:GetComponentWithName(CanvasGroupExt as ComponentExtType, self.name) as CanvasGroupExtType
    local bindingSet = view.bindingSet as BindingSetType

    local index: integer = 0
    local _Mode = function(): number
        index = #(modes) > 1 and index + 1 or 1
        return modes[index]
    end

    local builder = bindingSet:BindByTarget(self.componentExt as LuaObject)
    builder:For(self.componentExt.Alpha):To(self.name .. ".Alpha"):SetMode(_Mode())
end

function BindCanvasGroup:dtor()
end

return BindCanvasGroup