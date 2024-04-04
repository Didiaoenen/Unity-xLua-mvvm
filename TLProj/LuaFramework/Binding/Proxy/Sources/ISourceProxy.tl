local ISourceProxy = class("ISourceProxy") as ISourceProxyType

function ISourceProxy.get:Source(): any
    return nil
end

function ISourceProxy:ctor()
end

return ISourceProxy