local SourceProxyBase = require("LuaFramework.Binding.Proxy.Sources.SourceProxyBase")
local IModifiable = require("LuaFramework.Binding.Proxy.IModifiable")
local TableOprationMode = require("LuaFramework.Binding.TableOprationMode")

local InteractionNodeProxy = class("InteractionNodeProxy", SourceProxyBase, IModifiable) as InteractionNodeProxyType

function InteractionNodeProxy:ctor(source: LuaObject, request: string)
    SourceProxyBase.ctor(self, source)
    self.request = request
    self.invoker = nil
    self:BindEvent()
end

function InteractionNodeProxy:BindEvent()
    local request = classget(self.source, self.request) as InteractionRequestType
    if request then
        request.Raised = {opt = TableOprationMode.Add, save = self.request, this = self, callback = self.OnRaised}
    end
end

function InteractionNodeProxy:UnbindEvent()
    local request = classget(self.source, self.request) as InteractionRequestType
    if request then
        request.Raised = {opt = TableOprationMode.Remove, save = self.request}
    end
end

function InteractionNodeProxy:OnRaised(sender: LuaObject, ...: any)
    if self.invoker then
        local invoker = self.invoker as ProxyInvokerType
        invoker:Invoke(sender, ...)
    end
end

function InteractionNodeProxy:SetValue(value: LuaObject)
    self.invoker = value
end

function InteractionNodeProxy:dtor()
end

return InteractionNodeProxy