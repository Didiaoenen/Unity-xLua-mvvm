local SourceDescription = require("LuaFramework.Binding.Proxy.Sources.SourceDescription")

local ObjectSourceDescription = class("ObjectSourceDescription", SourceDescription) as ObjectSourceDescriptionType

function ObjectSourceDescription.get:Paths(): {string}
    return self.paths
end

function ObjectSourceDescription.set:Paths(value: {string})
    self.paths = value
end

function ObjectSourceDescription:ctor(paths: {string})
    SourceDescription.ctor(self)
    self.paths = paths
    self.isStatic = false
end

function ObjectSourceDescription:dtor()
end

return ObjectSourceDescription