local ViewModelBase = require("LuaFramework.Views.ViewModelBase")
local SimpleCommand = require("LuaFramework.Commands.SimpleCommand")
local InteractionRequest = require("LuaFramework.Interactivity.InteractionRequest")

local TextBind = require("LuaFramework.Views.ComponentBinds.TextBind")
local ButtonBind = require("LuaFramework.Views.ComponentBinds.ButtonBind")
local InputFieldBind = require("LuaFramework.Views.ComponentBinds.InputFieldBind")
local GameObjectBind = require("LuaFramework.Views.ComponentBinds.GameObjectBind")
local ToggleBind = require("LuaFramework.Views.ComponentBinds.ToggleBind")

local TestVM = class("TestVM", ViewModelBase) as TestVMType

function TestVM.get:Test(): string
    return self.test
end

function TestVM.set:Test(value)
    self:Set({name = "test"}, value, "Test")
end

function TestVM.get:TestColor(): CS.UnityEngine.Color
    return self.testColor
end

function TestVM.set:TestColor(value)
    self:Set({name = "testColor"}, value, "TestColor")
end

function TestVM.get:TestLocalScale(): CS.UnityEngine.Vector3
    return self.testLocalScale
end

function TestVM.set:TestLocalScale(value)
    self:Set({name = "testLocalScale"}, value, "TestLocalScale")
end

function TestVM.get:TestActive(): boolean
    return self.testActive
end

function TestVM.set:TestActive(value)
    self:Set({name = "testActive"}, value, "TestActive")
end

function TestVM.get:TestRequest(): InteractionRequestType
    return self.testRequest
end

function TestVM.set:TestRequest(value: InteractionRequestType)
    self.testRequest = value
end

function TestVM.get:TestCommand(): SimpleCommandType
    return self.testCommand
end

function TestVM.set:TestCommand(value: SimpleCommandType)
    self.testCommand = value
end

function TestVM:ctor(window: WindowFactoryType)
    ViewModelBase.ctor(self, window)

    self.window = window

    self.text = TextBind.new("text")
    self.text1 = TextBind.new("text1")
    self.button = ButtonBind.new("button")
    self.inputField = InputFieldBind.new("inputField")
    self.gameObject = GameObjectBind.new("gameObject")
    self.toggle_1 = ToggleBind.new("toggle_1")
    self.toggle_2 = ToggleBind.new("toggle_2")

    --
    self.test = ""
    self.test1 = ""
    self.testColor = CS.UnityEngine.Color.red
    self.testColor1 = CS.UnityEngine.Color.green
    self.testLocalScale = CS.UnityEngine.Vector3(0.5, 0.5, 0.5)
    self.testActive = false
    self.testRequest = InteractionRequest.new(self)
    self.testCommand = SimpleCommand.new(bindevent(self, self.TestSimpleCommand))
end

function TestVM:TestSimpleCommand()
    print("SimpleCommand")
end

function TestVM:OnClick()
    print("OnClick")
end

function TestVM:dtor()
end

return TestVM