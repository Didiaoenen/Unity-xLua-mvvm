local INotifyPropertyChanged = class("INotifyPropertyChanged") as INotifyPropertyChangedType

local TableOprationMode = require("LuaFramework.Binding.TableOprationMode")

function INotifyPropertyChanged.opt:PropertyChanged(value: OptHandlerType)
    if value.opt == TableOprationMode.Add then
        self.propertyChanged[value.save] = value
    end
    
    if value.opt == TableOprationMode.Remove then
        self.propertyChanged[value.save] = nil
    end
end

function INotifyPropertyChanged:ctor()
    self.propertyChanged = {}
end

return INotifyPropertyChanged