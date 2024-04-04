local ComponentExt = require("LuaFramework.Views.Components.ComponentExt")
local GameObjectExt = require("LuaFramework.Views.Components.GameObjectExt")

local ImageExt = class("ImageExt", ComponentExt) as ImageExtType

ImageExt.CSObject = CS.UnityEngine.UI.Text as CS.UnityEngine.Component

ImageExt.Sprite = "sprite"

ImageExt.FillAmount = "fillAmount"

function ImageExt.get:sprite(): CS.UnityEngine.Sprite
    local handler = self.handler as CS.UnityEngine.UI.Image
    return handler.sprit
end

function ImageExt.set:sprite(value: CS.UnityEngine.Sprite)
    local handler = self.handler as CS.UnityEngine.UI.Image
    handler.sprit = value
end

function ImageExt.get:fillAmount(): number
    local handler = self.handler as CS.UnityEngine.UI.Image
    return handler.fillAmount
end

function ImageExt.set:fillAmount(value: number)
    local handler = self.handler as CS.UnityEngine.UI.Image
    handler.fillAmount = value
end

function ImageExt.get:GameObject(): GameObjectExtType
    return self.gameObject
end

function ImageExt:ctor(handler: CS.UnityEngine.Component)
    ComponentExt.ctor(self, handler)
    self.gameObject = GameObjectExt.new(handler.gameObject)
end

function ImageExt:dtor()
end

return ImageExt