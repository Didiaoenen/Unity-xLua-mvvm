
local TestV = require("Game.UI.Test.TestV")
-- local TestW = require("Game.UI.Test.TestW")
local TestWin = require("Game.UI.Test.TestWin")

WindowConfig = class("WindowConfig") as WindowConfigType

local ViewCfg: {string: LuaObject} =
{
    [WindowNames.TestV] = TestV,
}

local WindowCfg: {string: LuaObject} =
{
    [WindowNames.TestWin] = TestWin,
}

function WindowConfig:ctor()
    self.viewConfig = ViewCfg
    self.windowConfig = WindowCfg
end

function WindowConfig:__singleton(): WindowConfigType
    return WindowConfig.new()
end

return WindowConfig
