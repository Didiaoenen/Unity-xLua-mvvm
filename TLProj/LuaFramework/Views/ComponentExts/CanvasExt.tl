local ComponentExt = require("LuaFramework.Views.ComponentExts.ComponentExt")
local GameObjectExt = require("LuaFramework.Views.ComponentExts.GameObjectExt")

local CanvasExt = class("CanvasExt", ComponentExt) as CanvasExtType

CanvasExt.CSObject = CS.UnityEngine.Canvas as CS.UnityEngine.Component

CanvasExt.OverrideSorting = "overrideSorting"

CanvasExt.SortingOrder = "sortingOrder"

function CanvasExt.get:sortingOrder(): number
    local handler = self.handler as CanvasExtType
    return handler.sortingOrder
end

function CanvasExt.set:sortingOrder(sortingOrder: number)
    local handler = self.handler as CanvasExtType
    handler.sortingOrder = sortingOrder
end

function CanvasExt.get:overrideSorting(): boolean
    local handler = self.handler as CanvasExtType
    return handler.overrideSorting
end

function CanvasExt.set:overrideSorting(overrideSorting: boolean)
    local handler = self.handler as CanvasExtType
    handler.overrideSorting = overrideSorting
end

function CanvasExt:ctor(handler: CS.UnityEngine.Component)
    ComponentExt.ctor(self, handler)
    self.gameObject = GameObjectExt.new(handler.gameObject)
end

function CanvasExt:dtor()
end

return CanvasExt