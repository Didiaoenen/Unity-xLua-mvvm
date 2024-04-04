local ICommand = require("LuaFramework.Commands.ICommand")
local TableOprationMode = require("LuaFramework.Binding.TableOprationMode")
local MapExtention = require("LuaFramework.Common.MapExtention")

local CommandBase = class("CommandBase", ICommand) as CommandBaseType

function CommandBase.opt:CanExecuteChanged(value: OptHandlerType)
    if value.opt == TableOprationMode.Add then
        self.canExecuteChanged[value.save] = value
    end
    
    if value.opt == TableOprationMode.Remove then
        self.canExecuteChanged[value.save] = nil
    end
end

function CommandBase:ctor()
    ICommand.ctor(self)
    self.canExecuteChanged = {}
end

function CommandBase:RaiseExecuteChanged()
    MapExtention.Foreach(self.canExecuteChanged, function(_: number, v: OptHandlerType)
        v.callback(v.this)
    end)
end

function CommandBase:CanExecute(...: any)
    assert({...}, "")
end

function CommandBase:Execute(...: any)
    assert({...}, "")
end

function CommandBase:dtor()
end

return CommandBase