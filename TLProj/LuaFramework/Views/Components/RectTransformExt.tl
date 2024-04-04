local TransformExt = require("LuaFramework.Views.Components.TransformExt")

local RectTransformExt = class("RectTransformExt", TransformExt) as RectTransformExtType

RectTransformExt.CSObject = CS.UnityEngine.RectTransform as CS.UnityEngine.Component

RectTransformExt.OffsetMax = "offsetMax"

RectTransformExt.OffsetMin = "offsetMin"

function RectTransformExt.get:offsetMax(): CS.UnityEngine.Vector2
    local handler = self.handler as CS.UnityEngine.RectTransform
    return handler.offsetMax
end

function RectTransformExt.set:offsetMax(value: CS.UnityEngine.Vector2)
    local handler = self.handler as CS.UnityEngine.RectTransform
    handler.offsetMax = value
end

function RectTransformExt.get:offsetMin(): CS.UnityEngine.Vector2
    local handler = self.handler as CS.UnityEngine.RectTransform
    return handler.offsetMin
end

function RectTransformExt.set:offsetMin(value: CS.UnityEngine.Vector2)
    local handler = self.handler as CS.UnityEngine.RectTransform
    handler.offsetMin = value
end

function RectTransformExt:ctor(handler: CS.UnityEngine.Component)
    TransformExt.ctor(self, handler)
end

function RectTransformExt:dtor()
end

return RectTransformExt