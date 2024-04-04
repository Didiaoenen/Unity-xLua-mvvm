local InteractionEventArgs = class("InteractionEventArgs") as InteractionEventArgsType

function InteractionEventArgs.get:Context(): LuaObject
    return self.context
end

function InteractionEventArgs.get:Callback(): function
    return self.callback
end

function InteractionEventArgs:ctor(context: LuaObject, callback: function)
    self.context = context
    self.callback = callback
end

function InteractionEventArgs:dtor()
end

return InteractionEventArgs