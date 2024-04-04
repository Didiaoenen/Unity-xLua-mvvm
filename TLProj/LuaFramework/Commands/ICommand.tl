local ICommand = class("ICommand") as ICommandType

function ICommand.opt:CanExecuteChanged(value: OptHandlerType)
    assert({value}, "")
end

function ICommand:ctor()
end

function ICommand:CanExecute(...: any)
    assert({...}, "")
end

function ICommand:Execute(...: any)
    assert({...}, "")
end

return ICommand