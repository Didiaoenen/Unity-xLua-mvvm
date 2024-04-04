local ObjectSourceDescription = require("LuaFramework.Binding.Proxy.Sources.Object.ObjectSourceDescription")

local BindingDescription = class("BindingDescription") as BindingDescriptionType

function BindingDescription.get:TargetName(): string
    return self.targetName
end

function BindingDescription.set:TargetName(value: string)
    self.targetName = value
end

function BindingDescription.get:UpdateTrigger(): string
    return self.updateTrigger
end

function BindingDescription.set:UpdateTrigger(value: string)
    self.updateTrigger = value
end

function BindingDescription.get:Mode(): number
    return self.mode
end

function BindingDescription.set:Mode(value: number)
    self.mode = value
end

function BindingDescription.get:Source(): SourceDescriptionType
    return self.source
end

function BindingDescription.set:Source(value: SourceDescriptionType)
    self.source = value
end

function BindingDescription.get:CommandParameter(): LuaObject
    return self.commandParameter
end

function BindingDescription.set:CommandParameter(value: LuaObject)
    self.commandParameter = value
end

function BindingDescription:ctor(targetName: string, path: string, mode: number)
    self.targetName = targetName
    self.mode = mode
    self.source = ObjectSourceDescription.new(path) as SourceDescriptionType
    self.updateTrigger = nil
    self.commandParameter = nil
end

function BindingDescription:dtor()
    
end

return BindingDescription