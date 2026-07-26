local ComponentBind = require("LuaFramework.Views.ComponentBinds.ComponentBind")
local GameObjectBind = require("LuaFramework.Views.ComponentBinds.GameObjectBind")
local CanvasGroupExt = require("LuaFramework.Views.ComponentExts.CanvasGroupExt")

local CanvasGroupBind = class("CanvasGroupBind", ComponentBind) as CanvasGroupBindType

function CanvasGroupBind.get:Alpha(): number
    return self.alpha
end

function CanvasGroupBind.set:Alpha(value: number)
    self:Set({name = "alpha"}, value, "Alpha")
end

function CanvasGroupBind:ctor(name: string)
    ComponentBind.ctor(self, name)
    self.gameObject = GameObjectBind.new()
    self.alpha = 1
end

function CanvasGroupBind:BindWithName(view: ViewBaseType, modes: {number})
    self.componentExt = view:GetComponentWithName(CanvasGroupExt as ComponentExtType, self.name) as CanvasGroupExtType
    -- local bindingSet = view.bindingSet as BindingSetType

    local index: integer = 0
    local _Mode = function(): number
        index = #(modes) > 1 and index + 1 or 1
        return modes[index]
    end

    self.bindingSet = view.bindingExt:CreateBindingSetWithContext(self)

    local builder = self.bindingSet:BindByTarget(self.componentExt as LuaObject)
    builder:For(self.componentExt.Alpha):To("Alpha"):SetMode(_Mode())

    self.bindingSet:Build()
end

function CanvasGroupBind:BindWithComponent(view: ViewBaseType, modes: {number})
    self.componentExt = view:GetComponent(CanvasGroupExt as ComponentExtType) as CanvasGroupExtType
    -- local bindingSet = view.bindingSet as BindingSetType

    if nil == self.componentExt then
        self.componentExt = view:AddComponent(CanvasGroupExt) as CanvasGroupExtType
    end

    local index: integer = 0
    local _Mode = function(): number
        index = #(modes) > 1 and index + 1 or 1
        return modes[index]
    end

    self.bindingSet = view.bindingExt:CreateBindingSetWithContext(self)

    local builder = self.bindingSet:BindByTarget(self.componentExt as LuaObject)
    builder:For(self.componentExt.Alpha):To("Alpha"):SetMode(_Mode())

    self.bindingSet:Build()
end

function CanvasGroupBind:dtor()
end

return CanvasGroupBind