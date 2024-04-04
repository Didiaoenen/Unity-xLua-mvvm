local INotifyPropertyChanged = require("LuaFramework.Binding.INotifyPropertyChanged")
local PropertyChangedEventArgs = require("LuaFramework.Binding.PropertyChangedEventArgs")

local ObservableObject = class("ObservableObject", INotifyPropertyChanged) as ObservableObjectType

function ObservableObject:ctor()
    INotifyPropertyChanged.ctor(self)
end

function ObservableObject:RaisePropertyChanged(property: string)
    self:RaisePropertyChangedWithParam(PropertyChangedEventArgs.new(property))
end

function ObservableObject:RaisePropertyChangedWithParam(param: PropertyChangedEventArgsType)
    local name = param.PropertyName
    local property = self.propertyChanged[name]
    if property then
        property.callback(property.this, self, param)
    end
end

function ObservableObject:Set(field: SetType, newValue: any, property: string, broadcast: boolean)
    local oldValue = classget(self as LuaObject, field.name)
    if oldValue ~= newValue then
        classset(self, field.name, newValue)
        self:RaisePropertyChanged(property)
    end

    if broadcast then
    end 
end

function ObservableObject:dtor()
    
end

return ObservableObject