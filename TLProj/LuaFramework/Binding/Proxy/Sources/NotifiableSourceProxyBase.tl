local SourceProxyBase = require("LuaFramework.Binding.Proxy.Sources.SourceProxyBase")
local IObtainable = require("LuaFramework.Binding.Proxy.IObtainable")
local IModifiable = require("LuaFramework.Binding.Proxy.IModifiable")
local INotifiable = require("LuaFramework.Binding.Proxy.INotifiable")
local ListExtention = require("LuaFramework.Common.ListExtention")

local NotifiableSourceProxyBase = class("NotifiableSourceProxyBase", SourceProxyBase, IObtainable, IModifiable, INotifiable) as NotifiableSourceProxyBaseType

function NotifiableSourceProxyBase.set:ValueChanged(value: LuaObject)
    setcallback(self.valueChanged, value)
end

function NotifiableSourceProxyBase:ctor(source: LuaObject)
    SourceProxyBase.ctor(self, source)
    IObtainable.ctor(self)
    IModifiable.ctor(self)
    INotifiable.ctor(self)
    self.valueChanged = {}
end

function NotifiableSourceProxyBase:RaiseValueChanged()
    ListExtention.Foreach(self.valueChanged, function(_: number, v: EventHandlerType)
        v.callback(v.this)
    end)
end

function NotifiableSourceProxyBase:dtor()
end

return NotifiableSourceProxyBase