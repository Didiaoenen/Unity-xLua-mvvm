local ComponentBind = require("LuaFramework.Views.ComponentBinds.ComponentBind")
local GameObjectBind = require("LuaFramework.Views.ComponentBinds.GameObjectBind")
local ImageExt = require("LuaFramework.Views.ComponentExts.ImageExt")

local ImageBind = class("ImageBind", ComponentBind) as ImageBindType

function ImageBind.get:Sprite(): CS.UnityEngine.Sprite
    return self.sprite
end

function ImageBind.set:Sprite(value: CS.UnityEngine.Sprite)
    self:Set({name = "sprite"}, value, "Sprite")
end

function ImageBind.get:FillAmount(): number
    return self.fillAmount
end

function ImageBind.set:FillAmount(value: number)
    self:Set({name = "fillAmount"}, value, "FillAmount")
end

function ImageBind:ctor(name: string)
    ComponentBind.ctor(self, name)
    self.gameObject = GameObjectBind.new()
end

function ImageBind:BindWithName(view: ViewBaseType, modes: {number})
    self.componentExt = view:GetComponentWithName(ImageExt as ComponentExtType, self.name) as ImageExtType
    -- local bindingSet = view.bindingSet as BindingSetType

    local index: integer = 0
    local _Mode = function(): number
        index = #(modes) > 1 and index + 1 or 1
        return modes[index]
    end

    self.bindingSet = view.bindingExt:CreateBindingSetWithContext(self)

    local builder = self.bindingSet:BindByTarget(self.componentExt as LuaObject)
    builder:For(self.componentExt.Sprite):To("Sprite"):SetMode(_Mode())

    builder = self.bindingSet:BindByTarget(self.componentExt as LuaObject)
    builder:For(self.componentExt.FillAmount):To("FillAmount"):SetMode(_Mode())

    builder = self.bindingSet:BindByTarget(self.componentExt.gameObject as LuaObject)
    builder:For(self.componentExt.GameObject.ActiveSelf):To("GameObject.ActiveSelf"):SetMode(_Mode())

    self.bindingSet:Build()
end

function ImageBind:dtor()
end

return ImageBind