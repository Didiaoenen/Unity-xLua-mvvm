local ComponentBind = require("LuaFramework.Views.ComponentBinds.ComponentBind")
local GameObjectBind = require("LuaFramework.Views.ComponentBinds.GameObjectBind")
local InputFieldExt = require("LuaFramework.Views.ComponentExts.InputFieldExt")
local SimpleCommand = require("LuaFramework.Commands.SimpleCommand")

local InputFieldBind = class("InputFieldBind", ComponentBind) as InputFieldBindType

function InputFieldBind.get:Text(): string
    return self.text
end

function InputFieldBind.set:Text(value: string)
    self:Set({name = "text"}, value, "Text")
end

function InputFieldBind.get:OnValueChanged(): function
    return self.onValueChanged
end

function InputFieldBind.set:OnValueChanged(value: function)
    self:Set({name = "onValueChanged"}, value, "OnValueChanged")
end

function InputFieldBind.get:SimpleCommand(): SimpleCommandType
    return self.simpleCommand
end

function InputFieldBind.set:SimpleCommand(value: SimpleCommandType)
    self:Set({name = "simpleCommand"}, value, "SimpleCommand")
end

function InputFieldBind:ctor(name: string)
    ComponentBind.ctor(self, name)
    self.gameObject = GameObjectBind.new()
    self.text = ""
    self.onValueChanged = function() end
    self.simpleCommand = SimpleCommand.new(function() end)
end

function InputFieldBind:BindWithName(view: ViewBaseType, modes: {number})
    self.componentExt = view:GetComponentWithName(InputFieldExt as ComponentExtType, self.name) as InputFieldExtType
    -- local bindingSet = view.bindingSet as BindingSetType

    local index: integer = 0
    local _Mode = function(): number
        index = #(modes) > 1 and index + 1 or 1
        return modes[index]
    end

    self.bindingSet = view.bindingExt:CreateBindingSetWithContext(self)
    
    local builder = self.bindingSet:BindByTarget(self.componentExt as LuaObject)
    builder:For(self.componentExt.Text, self.componentExt.OnEndEdit):To("Text"):SetMode(_Mode())

    builder = self.bindingSet:BindByTarget(self.componentExt as LuaObject)
    builder:For(self.componentExt.OnValueChanged):To("OnValueChanged"):SetMode(_Mode())

    builder = self.bindingSet:BindByTarget(self.componentExt as LuaObject)
    builder:For(self.componentExt.OnValueChanged):To("SimpleCommand"):SetMode(_Mode())

    builder = self.bindingSet:BindByTarget(self.componentExt.gameObject as LuaObject)
    builder:For(self.componentExt.GameObject.ActiveSelf):To("GameObject.ActiveSelf"):SetMode(_Mode())

    self.bindingSet:Build()
end

function InputFieldBind:dtor()
end

return InputFieldBind