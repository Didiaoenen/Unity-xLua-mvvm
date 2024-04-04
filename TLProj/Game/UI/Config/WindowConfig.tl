local ListExtention = require("LuaFramework.Common.ListExtention")
local TestConfig = require("Game.UI.Test.TestConfig") as {{WindowConfigTable}, {ViewConfigTable}}

local WindowConfigTableList: {{WindowConfigTable}} = {
    TestConfig[1],
}

local ViewConfigTableList: {{ViewConfigTable}} = {
    TestConfig[2],
}

WindowConfig = class("WindowConfig") as WindowConfigType

function WindowConfig.get:WindowConfig(): {string: WindowConfigTable}
    return self.windowConfig
end

function WindowConfig.get:ViewConfig(): {string: ViewConfigTable}
    return self.viewConfig
end

function WindowConfig:ctor()
    self.windowConfig = {}
    self.viewConfig = {}
    
    self:InitWindowConfig()
    self:InitViewConfig()
end

function WindowConfig:__singleton(): WindowConfigType
    return WindowConfig.new()
end

function WindowConfig:InitWindowConfig()
    ListExtention.Foreach(WindowConfigTableList, function(_, configs: {WindowConfigTable})
        ListExtention.Foreach(configs, function(_, config: WindowConfigTable)
            self.windowConfig[config.Name] = config
        end)
    end)
end

function WindowConfig:InitViewConfig()
    ListExtention.Foreach(ViewConfigTableList, function(_, configs: {ViewConfigTable})
        ListExtention.Foreach(configs, function(_, config: ViewConfigTable)
            self.viewConfig[config.Name] = config
        end)
    end)
end