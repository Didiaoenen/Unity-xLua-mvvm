local ListExtention = require("LuaFramework.Common.ListExtention")

local BindingSetBase = class("BindingSetBase") as BindingSetBaseType

function BindingSetBase:ctor(context: BindingContextType)
    self.context = context
    self.builders = {}
end

function BindingSetBase:Build()
    ListExtention.Foreach(self.builders, function(_: number, v: BindingBuilderBaseType)
        v:Build()
    end)
end

function BindingSetBase:dtor()
end

return BindingSetBase