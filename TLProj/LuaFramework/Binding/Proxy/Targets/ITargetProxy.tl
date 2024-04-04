local BindingMode = require("LuaFramework.Binding.BindingMode")

local ITargetProxy = class("ITargetProxy") as ITargetProxyType

function ITargetProxy.get:Target(): any
    return nil
end

function ITargetProxy.get:DefaultMode(): number
    return BindingMode.Default
end

function ITargetProxy:ctor()
end

return ITargetProxy