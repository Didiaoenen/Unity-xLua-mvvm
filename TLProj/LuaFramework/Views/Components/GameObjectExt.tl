local RectTransformExt = require("LuaFramework.Views.Components.RectTransformExt")

local GameObjectExt = class("GameObjectExt") as GameObjectExtType

GameObjectExt.CSObject = CS.UnityEngine.GameObject

GameObjectExt.ActiveSelf = "activeSelf"

function GameObjectExt.get:name(): string
    return self.handler.name
end

function GameObjectExt.get:activeSelf(): boolean
    return self.handler.activeSelf
end

function GameObjectExt:ctor(handler: CS.UnityEngine.GameObject)
    self.handler = handler
    self.transform = RectTransformExt.new(handler.transform) as TransformExtType
end

function GameObjectExt:GetComponent(cType: CS.System.Type): CS.UnityEngine.Component
    return self.handler:GetComponent(cType)
end

function GameObjectExt:AddComponent(cType: CS.System.Type): CS.UnityEngine.Component
    return self.handler:AddComponent(cType)
end

function GameObjectExt:SetActive(value: boolean)
    self.handler:SetActive(value)
end

function GameObjectExt:dtor()
end

return GameObjectExt