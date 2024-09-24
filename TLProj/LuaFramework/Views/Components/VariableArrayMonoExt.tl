local ComponentExt = require("LuaFramework.Views.Components.ComponentExt")
local GameObjectExt = require("LuaFramework.Views.Components.GameObjectExt")

local VariableArrayMonoExt = class("VariableArrayMonoExt", ComponentExt) as VariableArrayMonoExtType

VariableArrayMonoExt.CSObject = CS.Views.Variables.VariableArrayMono as CS.UnityEngine.Component

function VariableArrayMonoExt:ctor(handler: CS.UnityEngine.Component)
    ComponentExt.ctor(self, handler)
    self.gameObject = GameObjectExt.new(handler.gameObject)
end

function VariableArrayMonoExt:Get(name: string): CS.UnityEngine.Component
    local handler = self.handler as CS.Views.Variables.VariableArrayMono
    return handler.variableArray:Get(name)
end

function VariableArrayMonoExt:dtor()
end

return VariableArrayMonoExt