local IInteractionRequest = class("IInteractionRequest") as IInteractionRequestType

function IInteractionRequest.get:Raised(): function
    return nil
end

function IInteractionRequest.set:Raised(value: function)
    assert({value}, "")
end

function IInteractionRequest:ctor()
end

return IInteractionRequest