local TargetProxyBase = require("LuaFramework.Binding.Proxy.Targets.TargetProxyBase")
local TableOprationMode = require("LuaFramework.Binding.TableOprationMode")
local IObtainable = require("LuaFramework.Binding.Proxy.IObtainable")
local IModifiable = require("LuaFramework.Binding.Proxy.IModifiable")
local INotifiable = require("LuaFramework.Binding.Proxy.INotifiable")
local MapExtention = require("LuaFramework.Common.MapExtention")

local ValueTargetProxyBase = class("ValueTargetProxyBase", TargetProxyBase, IModifiable, IObtainable, INotifiable) as ValueTargetProxyBaseType

function ValueTargetProxyBase.opt:ValueChanged(value: OptHandlerType)
    if value.opt == TableOprationMode.Add then
        self.valueChanged[value.save] = value
        if not self.subScribed then
            self:Subscribe()
        end
    end
    
    if value.opt == TableOprationMode.Remove then
        self.valueChanged[value.save] = nil

        if self.subScribed then
            self:Unsubscribe()
        end
    end
end

function ValueTargetProxyBase:ctor(target: LuaObject)
    TargetProxyBase.ctor(self, target)
    self.subScribed = false
    self.valueChanged = {}
end

function ValueTargetProxyBase:Subscribe()
    if self.subScribed then
        return
    end

    local target = self.target
    if nil == target then
        return
    end

    self.subScribed = true
    self:DoSubscribeForValueChange(target)
end

function ValueTargetProxyBase:DoSubscribeForValueChange(target: LuaObject)
    assert({target}, "")
end

function ValueTargetProxyBase:Unsubscribe()
    if not self.subScribed then
        return
    end

    local target = self.target
    if nil == target then
        return
    end

    self.subScribed = false
    self:DoUnsubscribeForValueChange(target)
end

function ValueTargetProxyBase:DoUnsubscribeForValueChange(target: LuaObject)
    assert({target}, "")
end

function ValueTargetProxyBase:RaiseValueChanged()
    MapExtention.Foreach(self.valueChanged, function(_: number, v: OptHandlerType)
        v.callback(v.this)
    end)
end

function ValueTargetProxyBase:GetValue(): any
end

function ValueTargetProxyBase:SetValue(value: any)
    assert({value}, "")
end

function ValueTargetProxyBase:dtor()
end

return ValueTargetProxyBase