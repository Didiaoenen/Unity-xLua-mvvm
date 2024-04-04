local TargetProxyBase = require("LuaFramework.Binding.Proxy.Targets.TargetProxyBase")
local IObtainable = require("LuaFramework.Binding.Proxy.IObtainable")
local BindingMode = require("LuaFramework.Binding.BindingMode")

local InteractionTargetProxy = class("InteractionTargetProxy", TargetProxyBase, IObtainable) as InteractionTargetProxyType

function InteractionTargetProxy.get:DefaultMode(): number
    return BindingMode.OneWayToSource
end

function InteractionTargetProxy:ctor(target: LuaObject, interactionAction: string)
    TargetProxyBase.ctor(self, target)
    self.interactionAction = interactionAction
    self.handler = bindevent(self, self.OnRequest)
end

function InteractionTargetProxy:GetValue(): any
    return self.handler
end

function InteractionTargetProxy:OnRequest(sender: LuaObject, args: InteractionEventArgsType)
    local target = self.target
    if nil == target then
        return
    end

    local action = classget(self.target, self.interactionAction) as IInteractionActionType
    if action then
        action:OnRequest(sender, args)
    end
end

return InteractionTargetProxy