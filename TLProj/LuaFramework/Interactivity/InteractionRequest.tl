local IInteractionRequest = require("LuaFramework.Interactivity.IInteractionRequest")
local InteractionEventArgs = require("LuaFramework.Interactivity.InteractionEventArgs")
local TableOperationMode = require("LuaFramework.Binding.TableOperationMode")
local MapExtension = require("LuaFramework.Common.MapExtension")

local InteractionRequest = class("InteractionRequest", IInteractionRequest) as InteractionRequestType

function InteractionRequest.opt:Raised(value: OptHandlerType)
    if value.opt == TableOperationMode.Add then
        self.raised[value.save] = value
    end
    
    if value.opt == TableOperationMode.Remove then
        self.raised[value.save] = nil
    end
end

function InteractionRequest.get:Raised(): {string: OptHandlerType}
    return self.raised
end

function InteractionRequest:ctor(sender: LuaObject)
    IInteractionRequest.ctor(self)
    self.sender = sender or (self as LuaObject)
    self.raised = {}
end

function InteractionRequest:Raise(context: LuaObject, callback: function)
    MapExtension.Foreach(self.raised, function(_: number, v: OptHandlerType)
        v.callback(v.this, self.sender, InteractionEventArgs.new(context, function()
            if callback then
                callback(context)
            end
        end))
    end)
end

function InteractionRequest:dtor()
end

return InteractionRequest