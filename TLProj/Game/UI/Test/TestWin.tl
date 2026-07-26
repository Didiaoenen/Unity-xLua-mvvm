local WindowBase = require("LuaFramework.Views.WindowBase")
local WindowEnum = require("LuaFramework.Views.WindowEnum")

local BindingMode = require("LuaFramework.Binding.BindingMode")

local TextBind = require("LuaFramework.Views.ComponentBinds.TextBind")

local TestWin = class("TestWin", WindowBase) as TestWinType

TestWin.prefabPath = "TestW"
TestWin.windowType = WindowEnum.WindowType.FULL

function TestWin:OnInit()
    --[[AutoGenerate Begin]]
    self.Text = TextBind.new("Text")
    --[[AutoGenerate End]]
end

function TestWin:OnBind()
    self.Text:BindWithName(self as ViewBaseType, {BindingMode.OneWay})
end

--
function TestWin:OnStart()
    print("TestWin OnStart")
end

function TestWin:OnShow()
    print("TestWin OnShow")

    self.Text.Text = "Hello World"
    self.Text.Color = CS.UnityEngine.Color.green

    local viewBase = self as ViewBaseType
    viewBase:ShowView(WindowNames.TestV, viewBase, viewBase.rectTransform.componentExt)
end

function TestWin:OnHide()
    print("TestWin OnHide")

    local viewBase = self as ViewBaseType
    viewBase:HideView(WindowNames.TestV)
end

return TestWin
