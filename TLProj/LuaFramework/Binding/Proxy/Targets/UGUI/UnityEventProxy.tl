local UnityEventProxyBase = require("LuaFramework.Binding.Proxy.Targets.UGUI.UnityEventProxyBase")

local UnityEventProxy = class("UnityEventProxy", UnityEventProxyBase) as UnityEventProxyType

function UnityEventProxy:ctor(target: LuaObject, unityEvent: string)
    UnityEventProxyBase.ctor(self, target, unityEvent)
    self:BindEvent()
end

function UnityEventProxy:BindEvent()
    local target = self.target
    if nil == target then
        return
    end

    local unityEvent = classget(target, self.unityEvent) as CS.UnityEngine.Events.UnityEvent
    if unityEvent then
        unityEvent:AddListener(bindevent(self, self.OnEvent))
    end
end

function UnityEventProxy:UnbindEvent()
    local target = self.target
    if nil == target then
        return
    end

    local unityEvent = classget(target, self.unityEvent) as CS.UnityEngine.Events.UnityEvent
    if unityEvent then
        unityEvent:RemoveAllListeners()
    end
end

function UnityEventProxy:IsValidInvoker(invoker: IProxyInvokerType)
    assert({invoker}, "")
end

function UnityEventProxy:OnEvent(...: any)
    if self.invoker then
        self.invoker:Invoke(...)
    end

    if self.command then
        self.command:Execute(...)
    end
end

function UnityEventProxy:dtor()
end

return UnityEventProxy