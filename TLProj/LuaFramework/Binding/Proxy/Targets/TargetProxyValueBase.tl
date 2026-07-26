local TargetProxyBase = require("LuaFramework.Binding.Proxy.Targets.TargetProxyBase")
local TableOperationMode = require("LuaFramework.Binding.TableOperationMode")
local IObtainable = require("LuaFramework.Binding.Proxy.IObtainable")
local IModifiable = require("LuaFramework.Binding.Proxy.IModifiable")
local INotifiable = require("LuaFramework.Binding.Proxy.INotifiable")
local MapExtension = require("LuaFramework.Common.MapExtension")

local TargetProxyValueBase = class("TargetProxyValueBase", TargetProxyBase, IModifiable, IObtainable, INotifiable) as TargetValueProxyBaseType

function TargetProxyValueBase.opt:ValueChanged(value: OptHandlerType)
    if value.opt == TableOperationMode.Add then
        self.valueChanged[value.save] = value
        if not self.subScribed then
            self:Subscribe()
        end
    end
    
    if value.opt == TableOperationMode.Remove then
        self.valueChanged[value.save] = nil

        if self.subScribed then
            self:Unsubscribe()
        end
    end
end

function TargetProxyValueBase:ctor(target: LuaObject)
    TargetProxyBase.ctor(self, target)
    self.subScribed = false
    self.valueChanged = {}
end

function TargetProxyValueBase:Subscribe()
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

function TargetProxyValueBase:DoSubscribeForValueChange(target: LuaObject)
    assert({target}, "")
end

function TargetProxyValueBase:Unsubscribe()
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

function TargetProxyValueBase:DoUnsubscribeForValueChange(target: LuaObject)
    assert({target}, "")
end

function TargetProxyValueBase:RaiseValueChanged()
    MapExtension.Foreach(self.valueChanged, function(_: number, v: OptHandlerType)
        v.callback(v.this)
    end)
end

function TargetProxyValueBase:GetValue(): any
end

function TargetProxyValueBase:SetValue(value: any)
    assert({value}, "")
end

function TargetProxyValueBase:dtor()
end

return TargetProxyValueBase