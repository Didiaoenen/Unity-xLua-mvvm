local CommandBase = require("LuaFramework.Commands.CommandBase")

local SimpleCommand = class("SimpleCommand", CommandBase) as SimpleCommandType

function SimpleCommand.get:Enabled(): boolean
    return self.enabled
end

function SimpleCommand.set:Enabled(value: boolean)
    if value ~= self.enabled then
        self.enabled = value
        self:RaiseCanExecuteChanged()
    end
end

function SimpleCommand:ctor(execute: function)
    CommandBase.ctor(self)
    self.execute = execute
    self.enabled = true
end

function SimpleCommand:CanExecute(...: any): boolean
    assert({...}, "")
    return self.Enabled
end

function SimpleCommand:Execute(...: any)
    if self:CanExecute(...) and self.execute then
        self.execute(...)
    end
end

function SimpleCommand:dtor()
end

return SimpleCommand