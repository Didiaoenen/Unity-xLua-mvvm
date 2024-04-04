local BindComponent = require("LuaFramework.Views.BindComponents.BindComponent")
local BindGameObject = require("LuaFramework.Views.BindComponents.BindGameObject")
local ImageExt = require("LuaFramework.Views.Components.ImageExt")

local BindImage = class("BindImage", BindComponent) as BindImageType

function BindImage.get:Sprite(): CS.UnityEngine.Sprite
    return self.sprite
end

function BindImage.set:Sprite(value: CS.UnityEngine.Sprite)
    self:Set({name = "sprite"}, value, "Sprite")
end

function BindImage.get:FillAmount(): number
    return self.fillAmount
end

function BindImage.set:FillAmount(value: number)
    self:Set({name = "fillAmount"}, value, "FillAmount")
end

function BindImage:ctor(name: string)
    BindComponent.ctor(self, name)
    self.gameObject = BindGameObject.new()
end

function BindImage:BindWithName(view: ViewBaseType, modes: {number})
    self.componentExt = view:GetComponentWithName(ImageExt as ComponentExtType, self.name) as ImageExtType
    local bindingSet = view.bindingSet as BindingSetType

    local index: integer = 0
    local _Mode = function(): number
        index = #(modes) > 1 and index + 1 or 1
        return modes[index]
    end

    local builder = bindingSet:BindByTarget(self.componentExt as LuaObject)
    builder:For(self.componentExt.Sprite):To(self.name .. ".Sprite"):SetMode(_Mode())

    builder = bindingSet:BindByTarget(self.componentExt as LuaObject)
    builder:For(self.componentExt.FillAmount):To(self.name .. ".FillAmount"):SetMode(_Mode())

    builder = bindingSet:BindByTarget(self.componentExt.gameObject as LuaObject)
    builder:For(self.componentExt.GameObject.ActiveSelf):To(self.name .. ".GameObject.ActiveSelf"):SetMode(_Mode())
end

function BindImage:dtor()
end

return BindImage