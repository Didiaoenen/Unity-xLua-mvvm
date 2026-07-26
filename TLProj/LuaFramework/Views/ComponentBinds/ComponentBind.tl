local ObservableObject = require("LuaFramework.Observables.ObservableObject")

local ComponentBind = class("ComponentBind", ObservableObject) as ComponentBindType

function ComponentBind.get:GameObject(): GameObjectBindType
    return self.gameObject
end

function ComponentBind:ctor(name: string)
    ObservableObject.ctor(self)
    self.name = name
    self.gameObject = nil
    self.componentExt = nil
end

function ComponentBind:BindWithName(view: ViewBaseType, modes: {number})
    assert({view, modes}, "")
end

function ComponentBind:dtor()
end

return ComponentBind