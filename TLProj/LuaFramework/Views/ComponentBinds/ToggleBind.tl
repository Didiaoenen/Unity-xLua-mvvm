local ComponentBind = require("LuaFramework.Views.ComponentBinds.ComponentBind")
local GameObjectBind = require("LuaFramework.Views.ComponentBinds.GameObjectBind")
local SimpleCommand = require("LuaFramework.Commands.SimpleCommand")
local ToggleExt = require("LuaFramework.Views.ComponentExts.ToggleExt")

local ToggleBind = class("ToggleBind", ComponentBind) as ToggleBindType

function ToggleBind.get:OnValueChanged(): function
    return self.onValueChanged
end

function ToggleBind.set:OnValueChanged(value: function)
    self:Set({name = "onValueChanged"}, value, "OnValueChanged")
end

function ToggleBind.get:SimpleCommand(): SimpleCommandType
    return self.simpleCommand
end

function ToggleBind.set:SimpleCommand(value: SimpleCommandType)
    self:Set({name = "simpleCommand"}, value, "SimpleCommand")
end

function ToggleBind:ctor(name: string)
    ComponentBind.ctor(self, name)
    self.gameObject = GameObjectBind.new()
    self.onValueChanged = function() end
    self.simpleCommand = SimpleCommand.new(function() end)
end

function ToggleBind:BindWithName(view: ViewBaseType, modes: {number})
    self.componentExt = view:GetComponentWithName(ToggleExt as ComponentExtType, self.name) as ToggleExtType
    -- local bindingSet = view.bindingSet as BindingSetType

    local index: integer = 0
    local _Mode = function(): number
        index = #(modes) > 1 and index + 1 or 1
        return modes[index]
    end

    self.bindingSet = view.bindingExt:CreateBindingSetWithContext(self)

    local builder = self.bindingSet:BindByTarget(self.componentExt as LuaObject)
    builder:For(self.componentExt.OnValueChanged):To("OnValueChanged"):SetMode(_Mode())

    builder = self.bindingSet:BindByTarget(self.componentExt as LuaObject)
    builder:For(self.componentExt.OnValueChanged):To("SimpleCommand"):SetMode(_Mode())

    builder = self.bindingSet:BindByTarget(self.componentExt.gameObject as LuaObject)
    builder:For(self.componentExt.GameObject.ActiveSelf):To("GameObject.ActiveSelf"):SetMode(_Mode())

    self.bindingSet:Build()
end

function ToggleBind:dtor()
end

return ToggleBind