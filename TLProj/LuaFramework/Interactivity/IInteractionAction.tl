local IInteractionAction = class("IInteractionAction") as IInteractionActionType

function IInteractionAction:ctor()
end

function IInteractionAction:OnRequest(sender: LuaObject, args: InteractionEventArgsType)
    assert({sender, args})
end

return IInteractionAction