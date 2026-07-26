local ListExtension = require("LuaFramework.Common.ListExtension")

local BindingSetBase = class("BindingSetBase") as BindingSetBaseType

function BindingSetBase:ctor(context: BindingContextType)
    self.context = context
    self.builders = {}
end

function BindingSetBase:Build()
    ListExtension.Foreach(self.builders, function(_: number, v: BindingBuilderBaseType)
        v:Build()
    end)
    self.builders = {}
end

function BindingSetBase:dtor()
end

return BindingSetBase