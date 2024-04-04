local IObservableProperty = class("IObservableProperty") as IObservablePropertyType

function IObservableProperty.get:ValueChanged() : any
    return nil
end

function IObservableProperty.set:ValueChanged(value: any) : any
    assert({value}, "")
end

function IObservableProperty.get:Value() : any
    return nil
end

function IObservableProperty.set:Value(value: any) : any
    assert({value}, "")
end

function IObservableProperty:ctor()
end

return IObservableProperty