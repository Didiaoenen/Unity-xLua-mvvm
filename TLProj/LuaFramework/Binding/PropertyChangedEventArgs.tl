local PropertyChangedEventArgs = class("PropertyChangedEventArgs") as PropertyChangedEventArgsType

function PropertyChangedEventArgs.get:PropertyName(): string
    return self.propertyName
end

function PropertyChangedEventArgs:ctor(propertyName: string)
    self.propertyName = propertyName
end

return PropertyChangedEventArgs