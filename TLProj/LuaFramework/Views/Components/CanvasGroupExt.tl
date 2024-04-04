local ComponentExt = require("LuaFramework.Views.Components.ComponentExt")
local GameObjectExt = require("LuaFramework.Views.Components.GameObjectExt")

local CanvasGroupExt = class("CanvasGroupExt", ComponentExt) as CanvasGroupExtType

CanvasGroupExt.CSObject = CS.UnityEngine.CanvasGroup as CS.UnityEngine.Component

CanvasGroupExt.Alpha = "alpha"

function CanvasGroupExt:ctor(handler: CS.UnityEngine.Component)
    ComponentExt.ctor(self, handler)
    self.gameObject = GameObjectExt.new(handler.gameObject)
end

function CanvasGroupExt:dtor()
end

return CanvasGroupExt