local IProxyInvoker = class("IProxyInvoker") as IProxyInvokerType

function IProxyInvoker.get:ProxyMethodInfo(): string
    return self.proxyMethodInfo
end

function IProxyInvoker:ctor()
end

function IProxyInvoker:Invoke(...: any): any
    assert({...}, "")
end

return IProxyInvoker