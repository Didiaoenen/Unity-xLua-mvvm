local NotifiableSourceProxyBase = require("LuaFramework.Binding.Proxy.Sources.NotifiableSourceProxyBase")
local IObtainable = require("LuaFramework.Binding.Proxy.IObtainable")
local INotifiable = require("LuaFramework.Binding.Proxy.INotifiable")

local ChainedObjectSourceProxy = class("ChainedObjectSourceProxy", NotifiableSourceProxyBase) as ChainedObjectSourceProxyType

local ProxyEntry = class("ProxyEntry") as ChainedObjectSourceProxyType.ProxyEntryType

function ChainedObjectSourceProxy:ctor(source: LuaObject, token: PathTokenType, factory: INodeProxyFactoryType)
    NotifiableSourceProxyBase.ctor(self, source)
    self.factory = factory
    self.proxies = {}
    self:Bind(source, token)
end

function ChainedObjectSourceProxy:Bind(source: LuaObject, token: PathTokenType)
    local index = token.Index
    local proxy = self.factory:Create(source, token)
    if nil == proxy then
        return
    end

    local entry = ProxyEntry.new(proxy, token)
    self.proxies[index] = entry

    if token:HasNext() then
        if (proxy as LuaObject).is(INotifiable) then
            entry.Handler = {this = self, callback = function(sender: LuaObject, ...: any)
                assert({...}, "")
                local proxyEntry = self.proxies[index]
                if nil == proxyEntry or sender ~= proxyEntry.Proxy as LuaObject then
                    return
                end

                self:Rebind(index)
            end}
        end

        local child = (proxy as IObtainableType):GetValue()
        if nil ~= child then
            self:Bind(child as LuaObject, token:NextToken())
        else
            self:RaiseValueChanged()
        end
    else
        if (proxy as LuaObject).is(IObtainable) then
            entry.Handler = {this = self, callback = function(sender: LuaObject, ...: any)
                assert({sender, ...}, "")
                self:RaiseValueChanged()
            end}
        end
        self:RaiseValueChanged()
    end    
end

function ChainedObjectSourceProxy:Rebind(index: integer)
    for i = #(self.proxies), index, -1 do
        local proxyEntry = self.proxies[i]
        if proxyEntry then
            local proxy = proxyEntry.Proxy
            proxyEntry.Proxy = nil
            if nil ~= proxy then
                
            end 
        end
    end

    local entry = self.proxies[index]
    local bObtainable = (entry.Proxy as LuaObject).is(IObtainable)
    if not bObtainable then
        self:RaiseValueChanged()
        return
    end

    local source = (entry.Proxy as IObtainableType):GetValue()
    if nil == source then
        self:RaiseValueChanged()
        return
    end

    self:Bind(source as LuaObject, entry.Token:NextToken())
end

function ChainedObjectSourceProxy:Unbind()
    for i = #(self.proxies), 1, -1 do
        local proxyEntry = self.proxies[i]
        if proxyEntry then
            
        end
    end
end

function ChainedObjectSourceProxy:GetValue(): any
    local obtainable = self:GetObtainable()
    if nil == obtainable then
        return
    end

    return obtainable:GetValue()
end

function ChainedObjectSourceProxy:SetValue(value: any)
    local modifiable = self:GetModifiable()
    if nil == modifiable then
        return
    end

    modifiable:SetValue(value)
end

function ChainedObjectSourceProxy:GetObtainable(): IObtainableType
    local proxyEntry = self.proxies[#(self.proxies)]
    if nil == proxyEntry then
        return
    end

    return proxyEntry.Proxy as IObtainableType
end

function ChainedObjectSourceProxy:GetModifiable(): IModifiableType
    local proxyEntry = self.proxies[#(self.proxies)]
    if nil == proxyEntry then
        return
    end

    return proxyEntry.Proxy as IModifiableType
end

function ChainedObjectSourceProxy:dtor()
end

---------------------------------------------------------

function ProxyEntry.get:Proxy(): BindingProxyBaseType
    return self.proxy
end

function ProxyEntry.set:Proxy(value: BindingProxyBaseType)
    if self.proxy == value then
        return
    end


    if nil ~= self.handler then
        local bNotifiable = (self.proxy as LuaObject).is(IObtainable)
        if bNotifiable then
            (self.proxy as INotifiableType).ValueChanged = {this = self.handler.this}
        end
        
        bNotifiable = (value as LuaObject).is(IObtainable)
        if bNotifiable then
            (value as INotifiableType).ValueChanged = self.handler
        end
    end
    self.proxy = value
end

function ProxyEntry.get:Token(): PathTokenType
    return self.token
end

function ProxyEntry.set:Token(value: PathTokenType)
    self.token = value
end

function ProxyEntry.get:Handler(): EventHandlerType
    return self.handler
end

function ProxyEntry.set:Handler(value: EventHandlerType)
    if self.handler == value then
        return
    end

    local bNotifiable = (self.proxy as LuaObject).is(IObtainable)
    if bNotifiable then
        if nil ~= self.handler then
            (self.proxy as INotifiableType).ValueChanged = {this = self.handler.this}
        end

        if nil ~= value then
            (self.proxy as INotifiableType).ValueChanged = value
        end
    end
    
    self.handler = value
end

function ProxyEntry:ctor(proxy: BindingProxyBaseType, token: PathTokenType)
    self.proxy = proxy
    self.token = token
end

function ProxyEntry:dtor()
end

return ChainedObjectSourceProxy