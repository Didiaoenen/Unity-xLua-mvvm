local StandardBinder = require("LuaFramework.Binding.Binders.StandardBinder")
local ListExtention = require("LuaFramework.Common.ListExtention")

local BindingContext = class("BindingContext") as BindingContextType

function BindingContext.get:DataContext(): LuaObject
    return self.dataContext
end

function BindingContext.set:DataContext(value: LuaObject)
    if value ~= self.dataContext then
        self.dataContext = value
        self:OnDataContextChanged()
        self:RaiseDataContextChanged()
    end
end

function BindingContext.set:DataContextChanged(value: EventHandlerType)
    setcallback(self.dataContextChanged, value)
end

function BindingContext:ctor(owner: LuaObject, dataContext: LuaObject)
    self.owner = owner
    self.dataContext = dataContext

    --
    self.bindings = {}
    self.dataContextChanged = {}
    self.DEFAULT_KEY = "_KEY_"
end

function BindingContext:OnDataContextChanged()
    for _, binding in pairs(self.bindings) do
        for _, v in ipairs(binding) do
            v.DataContext = self.dataContext
        end
    end
end

function BindingContext:RaiseDataContextChanged()
    ListExtention.Foreach(self.dataContextChanged, function(_: number, v: EventHandlerType)
        v.callback(v.this)
    end)
end

function BindingContext:GetOrCreateList(key: string): {BindingType}
    if nil == key or "" == key then
        key = self.DEFAULT_KEY        
    end

    if nil == self.bindings[key] then
        self.bindings[key] = {}
    end
    
    return self.bindings[key]
end

function BindingContext:Add(binding: BindingType, key: string)
    if not binding then
        return        
    end

    local list = self:GetOrCreateList(key)
    table.insert(list, binding)
end

function BindingContext:AddWithSingleDesc(target: LuaObject, description: BindingDescriptionType, key: string)
    local binding = StandardBinder.Instance:Bind(self.dataContext, target, description)
    self:Add(binding, key)
end

function BindingContext:dtor()
end

return BindingContext