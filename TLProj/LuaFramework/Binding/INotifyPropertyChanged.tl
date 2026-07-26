local INotifyPropertyChanged = class("INotifyPropertyChanged") as INotifyPropertyChangedType

local TableOperationMode = require("LuaFramework.Binding.TableOperationMode")

function INotifyPropertyChanged.opt:PropertyChanged(value: OptHandlerType)
    if value.opt == TableOperationMode.Add then
        self.propertyChanged[value.save] = value
    end
    
    if value.opt == TableOperationMode.Remove then
        self.propertyChanged[value.save] = nil
    end
end

function INotifyPropertyChanged:ctor()
    self.propertyChanged = {}
end

function INotifyPropertyChanged:dtor()
end

return INotifyPropertyChanged