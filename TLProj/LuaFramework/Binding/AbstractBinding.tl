local AbstractBinding = class("AbstractBinding") as AbstractBindingType

function AbstractBinding.get:Target(): LuaObject
    local target = self.target as TargetProxyBaseType
    return target.Target
end

function AbstractBinding.get:DataContext(): LuaObject
    return self.dataContext
end

function AbstractBinding.set:DataContext(value: LuaObject)
    if value ~= self.dataContext then
        self.dataContext = value
        self:OnDataContextChanged()
    end
end

function AbstractBinding:ctor(dataContext: LuaObject, target: LuaObject)
    self.dataContext = dataContext
    self.target = target
end

function AbstractBinding:IsAlive(target: LuaObject): boolean
    assert({target}, "")
    return true
end

function AbstractBinding:OnDataContextChanged()
end

function AbstractBinding:dtor()
end

return AbstractBinding