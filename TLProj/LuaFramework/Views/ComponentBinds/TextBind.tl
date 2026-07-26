local ComponentBind = require("LuaFramework.Views.ComponentBinds.ComponentBind")
local GameObjectBind = require("LuaFramework.Views.ComponentBinds.GameObjectBind")
local TextExt = require("LuaFramework.Views.ComponentExts.TextExt")

local TextBind = class("TextBind", ComponentBind) as TextBindType

function TextBind.get:Text(): string
    return self.text
end

function TextBind.set:Text(value: string)
    self:Set({name = "text"}, value, "Text")
end

function TextBind.get:Color(): CS.UnityEngine.Color
    return self.color
end

function TextBind.set:Color(value: CS.UnityEngine.Color)
    self:Set({name = "color"}, value, "Color")
end

function TextBind:ctor(name: string)
    ComponentBind.ctor(self, name)
    self.gameObject = GameObjectBind.new()
    self.text = ""
    self.color = CS.UnityEngine.Color.white
end

function TextBind:BindWithName(view: ViewBaseType, modes: {number})
    self.componentExt = view:GetComponentWithName(TextExt as ComponentExtType, self.name) as TextExtType
    -- local bindingSet = view.bindingSet as BindingSetType

    local index: integer = 0
    local _Mode = function(): number
        index = #(modes) > 1 and index + 1 or 1
        return modes[index]
    end

    self.bindingSet = view.bindingExt:CreateBindingSetWithContext(self)

    local builder = self.bindingSet:BindByTarget(self.componentExt as LuaObject)
    builder:For(self.componentExt.Text):To("Text"):SetMode(_Mode())

    builder = self.bindingSet:BindByTarget(self.componentExt as LuaObject)
    builder:For(self.componentExt.Color):To("Color"):SetMode(_Mode())

    builder = self.bindingSet:BindByTarget(self.componentExt.gameObject as LuaObject)
    builder:For(self.componentExt.GameObject.ActiveSelf):To("GameObject.ActiveSelf"):SetMode(_Mode())

    self.bindingSet:Build()
end

function TextBind:dtor()
end

return TextBind