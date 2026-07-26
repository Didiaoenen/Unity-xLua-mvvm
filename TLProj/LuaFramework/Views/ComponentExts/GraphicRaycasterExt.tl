local ComponentExt = require("LuaFramework.Views.ComponentExts.ComponentExt")
local GameObjectExt = require("LuaFramework.Views.ComponentExts.GameObjectExt")

local GraphicRaycasterExt = class("GraphicRaycasterExt", ComponentExt) as GraphicRaycasterExtType

GraphicRaycasterExt.CSObject = CS.UnityEngine.UI.GraphicRaycaster as CS.UnityEngine.Component

function GraphicRaycasterExt:ctor(handler: CS.UnityEngine.Component)
    ComponentExt.ctor(self, handler)
    self.gameObject = GameObjectExt.new(handler.gameObject)
end

function GraphicRaycasterExt:dtor()
end

return GraphicRaycasterExt