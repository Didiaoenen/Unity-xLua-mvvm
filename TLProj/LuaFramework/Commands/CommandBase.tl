local ICommand = require("LuaFramework.Commands.ICommand")
local TableOperationMode = require("LuaFramework.Binding.TableOperationMode")
local MapExtension = require("LuaFramework.Common.MapExtension")

local CommandBase = class("CommandBase", ICommand) as CommandBaseType

function CommandBase.opt:CanExecuteChanged(value: OptHandlerType)
    if value.opt == TableOperationMode.Add then
        self.canExecuteChanged[value.save] = value
    end
    
    if value.opt == TableOperationMode.Remove then
        self.canExecuteChanged[value.save] = nil
    end
end

function CommandBase:ctor()
    ICommand.ctor(self)
    self.canExecuteChanged = {}
end

function CommandBase:RaiseExecuteChanged()
    MapExtension.Foreach(self.canExecuteChanged, function(_: number, v: OptHandlerType)
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