local ComponentExt = require("LuaFramework.Views.Components.ComponentExt")
local GameObjectExt = require("LuaFramework.Views.Components.GameObjectExt")

local CanvasExt = class("CanvasExt", ComponentExt) as CanvasExtType

CanvasExt.CSObject = CS.UnityEngine.Canvas as CS.UnityEngine.Component

CanvasExt.OverrideSorting = "overrideSorting"

CanvasExt.SortingOrder = "sortingOrder"

function CanvasExt:ctor(handler: CS.UnityEngine.Component)
    ComponentExt.ctor(self, handler)
    self.gameObject = GameObjectExt.new(handler.gameObject)
end

function CanvasExt:dtor()
end

return CanvasExt