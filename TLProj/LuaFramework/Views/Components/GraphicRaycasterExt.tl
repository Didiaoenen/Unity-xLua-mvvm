local ComponentExt = require("LuaFramework.Views.Components.ComponentExt")
local GameObjectExt = require("LuaFramework.Views.Components.GameObjectExt")

local GraphicRaycasterExt = class("GraphicRaycasterExt", ComponentExt) as GraphicRaycasterExtType

GraphicRaycasterExt.CSObject = CS.UnityEngine.UI.GraphicRaycaster as CS.UnityEngine.Component

function GraphicRaycasterExt:ctor(handler: CS.UnityEngine.Component)
    ComponentExt.ctor(self, handler)
    self.gameObject = GameObjectExt.new(handler.gameObject)
end

function GraphicRaycasterExt:dtor()
end

return GraphicRaycasterExt