local PathToken = class("PathToken") as PathTokenType

function PathToken:ctor(paths: {string}, index: integer)
    self.paths = paths
    self.index = index
end

function PathToken.get:Paths(): {string}
    return self.paths
end

function PathToken.get:Index(): integer
    return self.index
end

function PathToken.get:Current(): string
    return self.paths[self.index]
end

function PathToken:HasNext(): boolean
    if #(self.paths) == 0 or self.index >= #(self.paths) then
        return false
    end
    return true
end

function PathToken:NextToken(): PathTokenType
    if not self:HasNext() then
        return
    end

    if nil == self.nextToken then
        self.nextToken = PathToken.new(self.paths, self.index + 1)
    end
    return self.nextToken
end

function PathToken:dtor()
end

return PathToken