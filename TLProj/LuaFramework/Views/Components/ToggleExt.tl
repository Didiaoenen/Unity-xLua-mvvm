local ComponentExt = require("LuaFramework.Views.Components.ComponentExt")
local GameObjectExt = require("LuaFramework.Views.Components.GameObjectExt")

local ToggleExt = class("ToggleExt", ComponentExt) as ToggleExtType

ToggleExt.CSObject = CS.UnityEngine.UI.Toggle as CS.UnityEngine.Component

ToggleExt.OnValueChanged = "onValueChanged"

function ToggleExt.get:onValueChanged(): CS.UnityEngine.UI.Toggle.ToggleEvent
    local handler = self.handler as CS.UnityEngine.UI.Toggle
    return handler.onValueChanged
end

function ToggleExt.set:onValueChanged(value: CS.UnityEngine.UI.Toggle.ToggleEvent)
    local handler = self.handler as CS.UnityEngine.UI.Toggle
    handler.onValueChanged = value
end

function ToggleExt.get:GameObject(): GameObjectExtType
    return self.gameObject
end

function ToggleExt:ctor(handler: CS.UnityEngine.Component)
    ComponentExt.ctor(self, handler)
    self.gameObject = GameObjectExt.new(handler.gameObject)
end

function ToggleExt:dtor()
end

return ToggleExt