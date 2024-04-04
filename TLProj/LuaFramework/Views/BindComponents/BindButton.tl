local BindComponent = require("LuaFramework.Views.BindComponents.BindComponent")
local BindGameObject = require("LuaFramework.Views.BindComponents.BindGameObject")
local SimpleCommand = require("LuaFramework.Commands.SimpleCommand")
local ButtonExt = require("LuaFramework.Views.Components.ButtonExt")

local BindButton = class("BindButton", BindComponent) as BindButtonType

function BindButton.get:OnClick(): function
    return self.onClick
end

function BindButton.set:OnClick(value: function)
    self:Set({name = "onClick"}, value, "OnClick")
end

function BindButton.get:SimpleCommand(): SimpleCommandType
    return self.simpleCommand
end

function BindButton.set:SimpleCommand(value: SimpleCommandType)
    self:Set({name = "simpleCommand"}, value, "SimpleCommand")
end

function BindButton:ctor(name: string)
    BindComponent.ctor(self, name)
    self.gameObject = BindGameObject.new()
    self.onClick = function() end
    self.simpleCommand = SimpleCommand.new(function() end)
end

function BindButton:BindWithName(view: ViewBaseType, modes: {number})
    self.componentExt = view:GetComponentWithName(ButtonExt as ComponentExtType, self.name) as ButtonExtType
    local bindingSet = view.bindingSet as BindingSetType

    local index: integer = 0
    local _Mode = function(): number
        index = #(modes) > 1 and index + 1 or 1
        return modes[index]
    end

    local builder = bindingSet:BindByTarget(self.componentExt as LuaObject)
    builder:For(self.componentExt.OnClick):To(self.name .. ".OnClick"):SetMode(_Mode())

    builder = bindingSet:BindByTarget(self.componentExt as LuaObject)
    builder:For(self.componentExt.OnClick):To(self.name .. ".SimpleCommand"):SetMode(_Mode())

    builder = bindingSet:BindByTarget(self.componentExt.gameObject as LuaObject)
    builder:For(self.componentExt.GameObject.ActiveSelf):To(self.name .. ".GameObject.ActiveSelf"):SetMode(_Mode())
end

function BindButton:dtor()
end

return BindButton