local WindowFactory = class("WindowFactory") as WindowFactoryType

local WindowEnum = require("LuaFramework.Views.WindowEnum")

function WindowFactory:ctor()
    self.name = ""
    self.windowType = WindowEnum.WindowType.NONE
    
    self.view = nil
    self.viewModel = nil
end

function WindowFactory:dtor()
end

return WindowFactory