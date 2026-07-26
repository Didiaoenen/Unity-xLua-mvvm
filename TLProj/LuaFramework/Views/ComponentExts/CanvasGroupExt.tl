local ComponentExt = require("LuaFramework.Views.ComponentExts.ComponentExt")
local GameObjectExt = require("LuaFramework.Views.ComponentExts.GameObjectExt")

local CanvasGroupExt = class("CanvasGroupExt", ComponentExt) as CanvasGroupExtType

CanvasGroupExt.CSObject = CS.UnityEngine.CanvasGroup as CS.UnityEngine.Component

CanvasGroupExt.Alpha = "alpha"

function CanvasGroupExt.get:alpha(): number
    local handler = self.handler as CanvasGroupExt
    return handler.alpha
end

function CanvasGroupExt.set:alpha(alpha: number)
    local handler = self.handler as CanvasGroupExt
    handler.alpha = alpha
end

function CanvasGroupExt:ctor(handler: CS.UnityEngine.Component)
    ComponentExt.ctor(self, handler)
    self.gameObject = GameObjectExt.new(handler.gameObject)
end

function CanvasGroupExt:dtor()
end

return CanvasGroupExt