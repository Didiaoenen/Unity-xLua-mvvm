local ObservableObject = require("LuaFramework.Observables.ObservableObject")

local BindComponent = class("BindComponent", ObservableObject) as BindComponentType

function BindComponent.get:GameObject(): BindGameObjectType
    return self.gameObject
end

function BindComponent:ctor(name: string)
    ObservableObject.ctor(self)
    self.name = name
    self.componentExt = nil
end

function BindComponent:BindWithName(view: ViewBaseType, modes: {number})
    assert({view, modes}, "")
end

function BindComponent:dtor()
end

return BindComponent