local ComponentBind = require("LuaFramework.Views.ComponentBinds.ComponentBind")
local GameObjectBind = require("LuaFramework.Views.ComponentBinds.GameObjectBind")
local SimpleCommand = require("LuaFramework.Commands.SimpleCommand")
local ButtonExt = require("LuaFramework.Views.ComponentExts.ButtonExt")

local ButtonBind = class("ButtonBind", ComponentBind) as ButtonBindType

function ButtonBind.get:OnClick(): function
    return self.onClick
end

function ButtonBind.set:OnClick(value: function)
    self:Set({name = "onClick"}, value, "OnClick")
end

function ButtonBind.get:SimpleCommand(): SimpleCommandType
    return self.simpleCommand
end

function ButtonBind.set:SimpleCommand(value: SimpleCommandType)
    self:Set({name = "simpleCommand"}, value, "SimpleCommand")
end

function ButtonBind:ctor(name: string)
    ComponentBind.ctor(self, name)
    self.gameObject = GameObjectBind.new()
    self.onClick = function() end
    self.simpleCommand = SimpleCommand.new(function() end)
end

function ButtonBind:BindWithName(view: ViewBaseType, modes: {number})
    self.componentExt = view:GetComponentWithName(ButtonExt as ComponentExtType, self.name) as ButtonExtType
    -- local bindingSet = view.bindingSet as BindingSetType

    local index: integer = 0
    local _Mode = function(): number
        index = #(modes) > 1 and index + 1 or 1
        return modes[index]
    end

    self.bindingSet = view.bindingExt:CreateBindingSetWithContext(self)

    local builder = self.bindingSet:BindByTarget(self.componentExt as LuaObject)
    builder:For(self.componentExt.OnClick):To("OnClick"):SetMode(_Mode())

    builder = self.bindingSet:BindByTarget(self.componentExt as LuaObject)
    builder:For(self.componentExt.OnClick):To("SimpleCommand"):SetMode(_Mode())

    builder = self.bindingSet:BindByTarget(self.componentExt.gameObject as LuaObject)
    builder:For(self.componentExt.GameObject.ActiveSelf):To("GameObject.ActiveSelf"):SetMode(_Mode())

    self.bindingSet:Build()
end

function ButtonBind:dtor()
end

return ButtonBind