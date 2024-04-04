local WindowEnum = require("LuaFramework.Views.WindowEnum")

local TestV = require("Game.UI.Test.TestV")
local TestVM = require("Game.UI.Test.TestVM")

local TestViewConfig: ViewConfigTable = {
    Name = WindowNames.TestV,
    PrefabPath = "TestV",
    ViewType = WindowEnum.ViewType.VIEW,
    State = WindowEnum.ViewState.NONE,
    View = TestV as ViewBaseType,
}

local TestSubViewConfig: ViewConfigTable = {
    Name = WindowNames.TestSubV,
    PrefabPath = "TestSubV",
    ViewType = WindowEnum.ViewType.VIEW,
    State = WindowEnum.ViewState.NONE,
    View = TestV as ViewBaseType,
}

local TestWindowConfig: WindowConfigTable = {
    Name = WindowNames.Test,
    WindowType = WindowEnum.WindowType.FULL,
    ViewConfig = TestViewConfig,
    ViewModel = TestVM as ViewModelBaseType,
}

local WindwoConifg: {WindowConfigTable} = {
    TestWindowConfig,
}

local ViewConfig: {ViewConfigTable} = {
    TestSubViewConfig
}

return {WindwoConifg, ViewConfig}