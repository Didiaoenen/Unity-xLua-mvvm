local WindowStateEventArgs = class("WindowStateEventArgs") as WindowStateEventArgsType

function WindowStateEventArgs.get:Window(): ViewBaseType
    return self.window
end

function WindowStateEventArgs.get:State(): number
    return self.state
end

function WindowStateEventArgs.get:OldState(): number
    return self.oldState
end

function WindowStateEventArgs:ctor(window: ViewBaseType, oldState: number, newState: number)
    self.window = window
    self.oldState = oldState
    self.state = newState
end

return WindowStateEventArgs