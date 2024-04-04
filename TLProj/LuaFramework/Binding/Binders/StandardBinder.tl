local SourceProxyFactory = require("LuaFramework.Binding.Proxy.Sources.SourceProxyFactory")
local TargetProxyFactory = require("LuaFramework.Binding.Proxy.Targets.TargetProxyFactory")

local ObjectSourceProxyFactory = require("LuaFramework.Binding.Proxy.Sources.Object.ObjectSourceProxyFactory")
local UniversalNodeProxyFactory = require("LuaFramework.Binding.Proxy.Sources.Object.UniversalNodeProxyFactory")
local UniversalTargetProxyFactory = require("LuaFramework.Binding.Proxy.Targets.Universal.UniversalTargetProxyFactory")
local UnityTargetProxyFactory = require("LuaFramework.Binding.Proxy.Targets.UGUI.UnityTargetProxyFactory")

local Binding = require("LuaFramework.Binding.Binding")

local StandardBinder = class("StandardBinder") as StandardBinderType

function StandardBinder:ctor()
    local objectSourceProxyFactory = ObjectSourceProxyFactory.new()
    objectSourceProxyFactory:Register(UniversalNodeProxyFactory.new() as INodeProxyFactoryType, 0)

    local sourceProxyFactory = SourceProxyFactory.new()
    sourceProxyFactory:Register(objectSourceProxyFactory as ISourceProxyFactoryType, 0)

    local targetProxyFactory = TargetProxyFactory.new()
    targetProxyFactory:Register(UniversalTargetProxyFactory.new() as ITargetProxyFactoryType, 0)
    targetProxyFactory:Register(UnityTargetProxyFactory.new() as ITargetProxyFactoryType, 10)

    self.sourceProxyFactory = sourceProxyFactory as SourceProxyBaseType
    self.targetProxyFactory = targetProxyFactory as TargetProxyBaseType
end

function StandardBinder:Bind(source: LuaObject, target: LuaObject, bindingDecription: BindingDescriptionType): BindingType
    return Binding.new(source, target, bindingDecription, self.sourceProxyFactory, self.targetProxyFactory)
end

function StandardBinder:__singleton(): StandardBinder
    return StandardBinder.new()
end

function StandardBinder:dtor()
end

return StandardBinder