local SourceDescription = class("SourceDescription") as SourceDescriptionType

function SourceDescription.get:IsStatic(): boolean
    return self.isStatic
end

function SourceDescription.set:IsStatic(value: boolean)
    self.isStatic = value
end

function SourceDescription:ctor()
    self.isStatic = false
end

function SourceDescription:dtor()
end

return SourceDescription