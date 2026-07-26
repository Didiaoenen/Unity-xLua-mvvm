local ViewBase = require("LuaFramework.Views.ViewBase")
local BindingMode = require("LuaFramework.Binding.BindingMode")
local BindingExtension = require("LuaFramework.Binding.BindingExtension")

-- local SimpleCommand = require("LuaFramework.Commands.SimpleCommand")

local TextBind = require("LuaFramework.Views.ComponentBinds.TextBind")

local TestV = class("TestV", ViewBase) as TestVType

TestV.prefabPath = "TestV"

function TestV:ctor(name: string, window: WindowBaseType, parent: TransformExtType)
    ViewBase.ctor(self, name, window, parent)

    self.bindingExt = BindingExtension.new(self)
    self.bindingSet = self.bindingExt:CreateBindingSetWithContext(self.viewModel as LuaObject) as BindingSetBaseType
    -- local builder = bindingSet:Bind()
    -- builder:For("TestFunc"):To("TestRequest")

    -- local builder = set:BindByTarget(text as LuaObject)
    -- builder:For("text"):To("Test"):OneWay()
    
    -- local builder = set:BindByTarget(text)
    -- builder:For("color"):To("TestColor"):OneWay()

    -- local builder = set:BindByTarget(text.transform)
    -- builder:For("localScale"):To("TestLocalScale"):OneWay()

    -- local builder = set:BindByTarget(text.gameObject)
    -- builder:For("activeSelf"):To("TestActive"):TwoWay()

    -- local builder = set:BindByTarget(button)
    -- builder:For("onClick"):To("OnClick"):OneWay()

    -- local builder = set:BindByTarget(button)
    -- builder:For("onClick"):To("TestCommand"):OneWay()

    -- local builder = set:BindByTarget(inputField)
    -- builder:For("text", "onValueChanged"):To("Test"):TwoWay()

    -- set:Build()

    -- testVM.Test = "123"

    -- testVM.TestRequest:Raise()
end

function TestV:TestFunc(sender: any, args: any)
    assert({sender, args}, "")
    print("hahaha")
end

function TestV:OnCreate()
    ViewBase.OnCreate(self as ViewBaseType)
    print("TestV OnCreate")

    -- local text = self:GetComponentWithName(TextExt, "text") as TextExtType
    -- local button = self:GetComponentWithName(ButtonExt, "button") as ButtonExtType

    -- local bindingSet = self.bindingSet as BindingSetType

    -- local builder = bindingSet:BindByTarget(text as LuaObject)
    -- builder:For(text.Text):To("text.Text"):OneWay()

    -- builder = bindingSet:BindByTarget(text.gameObject as LuaObject)
    -- builder:For(text.GameObject.ActiveSelf):To("text.GameObject.ActiveSelf"):OneWay()
    
    -- builder = bindingSet:BindByTarget(button as LuaObject)
    -- builder:For(button.OnClick):To("TestCommand"):OneWay()

    local text = TextBind.new("text")

    text:BindWithName(self as ViewBaseType, {BindingMode.OneWay})

    -- self.viewModel.text:BindWithName(self as ViewBaseType, {BindingMode.OneWay})
    -- self.viewModel.text1:BindWithName(self as ViewBaseType, {BindingMode.OneWay})
    -- self.viewModel.button:BindWithName(self as ViewBaseType, {BindingMode.OneWay})
    -- self.viewModel.inputField:BindWithName(self as ViewBaseType, {BindingMode.TwoWay})
    -- self.viewModel.gameObject:BindWithName(self as ViewBaseType, {BindingMode.OneWay})
    -- self.viewModel.toggle_1:BindWithName(self as ViewBaseType, {BindingMode.OneWay})
    -- self.viewModel.toggle_2:BindWithName(self as ViewBaseType, {BindingMode.OneWay})

    --
    -- self.bindingSet:Build()

    text.Text = "hahaha"
    text.Color = CS.UnityEngine.Color.red
    text.GameObject.ActiveSelf = true
end

function TestV:OnShow()
    ViewBase.OnShow(self as ViewBaseType)
    print("child OnShow")

    -- self.viewModel.text.Text = "hahaha"
    -- self.viewModel.text.Color = CS.UnityEngine.Color.red
    -- self.viewModel.text.gameObject.ActiveSelf = true
    -- self.viewModel.text1.Text = "哈哈哈"
    -- self.viewModel.text1.Color = CS.UnityEngine.Color.green
    -- self.viewModel.button.OnClick = bindevent(self, self.TestButtonSimpleCommand)
    -- self.viewModel.button.SimpleCommand = SimpleCommand.new(bindevent(self, self.TestButtonSimpleCommand))
    -- self.viewModel.inputField.Text = "你好啊"
    -- self.viewModel.inputField.SimpleCommand = SimpleCommand.new(bindevent(self, self.TestInputFieldSimpleCommand, "inputField"))
    -- self.viewModel.toggle_1.SimpleCommand = SimpleCommand.new(bindevent(self, self.TestToggleSimpleCommand, "toggle_1"))
    -- self.viewModel.toggle_2.SimpleCommand = SimpleCommand.new(bindevent(self, self.TestToggleSimpleCommand, "toggle_2"))
    -- self.viewModel.gameObject.ActiveSelf = true
    -- local inputBase = self.viewModel.inputField as ComponentBindType
    -- inputBase.GameObject.ActiveSelf = false

    -- self:AddView(WindowNames.TestSubV, self.viewModel.text.componentExt.gameObject.transform)
    -- self:AddView(WindowNames.TestSubV, self.viewModel.text1.componentExt.gameObject.transform)
    -- self:AddView(WindowNames.TestSubV, self.viewModel.button.componentExt.gameObject.transform)
    -- self:AddView(WindowNames.TestSubV, self.viewModel.inputField.componentExt.gameObject.transform)
    -- self:AddView(WindowNames.TestSubV, self.viewModel.toggle_1.componentExt.gameObject.transform)
    -- self:AddView(WindowNames.TestSubV, self.viewModel.toggle_2.componentExt.gameObject.transform)
    -- self:AddView(WindowNames.TestSubV, self.viewModel.gameObject.gameObjectExt.transform)
end

function TestV:TestButtonSimpleCommand(... :any)
    for key, value in ipairs({...}) do
        print("key : " .. key .. " value : " .. tostring(value))
    end
    print("TestButtonSimpleCommand")
end

function TestV:TestToggleSimpleCommand(...: any)
    for key, value in ipairs({...}) do
        print("key : " .. key .. " value : " .. tostring(value))
    end
    print("TestToggleSimpleCommand")
end

function TestV:TestInputFieldSimpleCommand(...: any)
    for key, value in ipairs({...}) do
        print("key : " .. key .. " value : " .. tostring(value))
    end
    print("TestInputFieldSimpleCommand")
end

function TestV:dtor()
end

return TestV