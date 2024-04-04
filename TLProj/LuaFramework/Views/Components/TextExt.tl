local ComponentExt = require("LuaFramework.Views.Components.ComponentExt")
local GameObjectExt = require("LuaFramework.Views.Components.GameObjectExt")

local TextExt = class("TextExt", ComponentExt) as TextExtType

TextExt.CSObject = CS.UnityEngine.UI.Text as CS.UnityEngine.Component

TextExt.Text = "text"

TextExt.Color = "color"

function TextExt.get:text(): string
    local handler = self.handler as CS.UnityEngine.UI.Text
    return handler.text
end

function TextExt.set:text(value: string)
    local handler = self.handler as CS.UnityEngine.UI.Text
    handler.text = value
end

function TextExt.get:color(): CS.UnityEngine.Color
    local handler = self.handler as CS.UnityEngine.UI.Text
    return handler.color
end

function TextExt.set:color(value: CS.UnityEngine.Color)
    local handler = self.handler as CS.UnityEngine.UI.Text
    handler.color = value
end

function TextExt.get:GameObject(): GameObjectExtType
    return self.gameObject
end

function TextExt:ctor(handler: CS.UnityEngine.Component)
    ComponentExt.ctor(self, handler)
    self.gameObject = GameObjectExt.new(handler.gameObject)
end

function TextExt:dtor()
end

return TextExt