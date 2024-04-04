local INotifiable = class("INotifiable") as INotifiableType

function INotifiable.opt:ValueChanged(value: OptHandlerType)
    assert({value}, "")
end

function INotifiable:ctor()
end

function INotifiable:dtor()
end

return INotifiable