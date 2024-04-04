local ComponentExt = require("LuaFramework.Views.Components.ComponentExt")

local TransformExt = class("TransformExt", ComponentExt) as TransformExtType

TransformExt.CSObject = CS.UnityEngine.Transform as CS.UnityEngine.Component

TransformExt.LocalRotation = "localRotation"

TransformExt.LocalPosition = "localPosition"

TransformExt.LocalScale = "localScale"

TransformExt.Parent = "parent"

function TransformExt.get:localRotation(): CS.UnityEngine.Quaternion
    local handler = self.handler as CS.UnityEngine.Transform
    return handler.localRotation
end

function TransformExt.set:localRotation(value: CS.UnityEngine.Quaternion)
    local handler = self.handler as CS.UnityEngine.Transform
    handler.localRotation = value
end

function TransformExt.get:localPosition(): CS.UnityEngine.Vector3
    local handler = self.handler as CS.UnityEngine.Transform
    return handler.localPosition
end

function TransformExt.set:localPosition(value: CS.UnityEngine.Vector3)
    local handler = self.handler as CS.UnityEngine.Transform
    handler.localPosition = value
end

function TransformExt.get:localScale(): CS.UnityEngine.Vector3
    local handler = self.handler as CS.UnityEngine.Transform
    return handler.localScale
end

function TransformExt.set:localScale(value: CS.UnityEngine.Vector3)
    local handler = self.handler as CS.UnityEngine.Transform
    handler.localScale = value
end

function TransformExt.set:parent(value: CS.UnityEngine.Transform)
    local handler = self.handler as CS.UnityEngine.Transform
    handler.parent = value
end

function TransformExt.get:parent(): CS.UnityEngine.Transform
    local handler = self.handler as CS.UnityEngine.Transform
    return handler.parent
end

function TransformExt:ctor(handler: CS.UnityEngine.Component)
    ComponentExt.ctor(self, handler)
end

function TransformExt:SetParent(parent: TransformExtType)
    local handler = self.handler as CS.UnityEngine.Transform
    handler:SetParent(parent.handler as CS.UnityEngine.Transform)
end

function TransformExt:dtor()
end

return TransformExt