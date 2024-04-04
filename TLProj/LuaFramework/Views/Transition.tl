local CoroutineExt = require("LuaFramework.Common.CoroutineExt")
local ExecutorsExt = require("LuaFramework.Execution.ExecutorsExt")
local TransitionAwaiter = require("LuaFramework.Views.TransitionAwaiter")
local TableOprationMode = require("LuaFramework.Binding.TableOprationMode")

local Transition = class("Transition") as TransitionType

function Transition.get:Window(): WindowFactoryType
    return self.window
end

function Transition.set:Window(value: WindowFactoryType)
    self.window = value
end

function Transition.get:IsDone(): boolean
    return self.done
end

function Transition.set:IsDone(value: boolean)
    self.done = value
end

function Transition.get:AnimationDisabled(): boolean
    return self.animationDisabled
end

function Transition.set:AnimationDisabled(value: boolean)
    self.animationDisabled = value
end

function Transition.get:OverlayPolicy(): function
    return self.overlayPolicy
end

function Transition.set:OverlayPolicy(value: function)
    self.overlayPolicy = value
end

function Transition:ctor(window: WindowFactoryType)
    self.window = window
    self.done = false
    self.animationDisabled = false
    self.overlayPolicy = nil
    self.running = false
    self.bound = false
    self.onStart = nil
    self.onStateChanged = nil
    self.onFinish = nil
end

function Transition:Bind()
    if self.bound then
        return
    end

    self.bound = true
    if self.window then
        local view = self.window.view
        view.StateChanged = {opt = TableOprationMode.Add, this = self, callback = self.StateChanged}
    end
end

function Transition:Unbind()
    if not self.bound then
        return
    end

    self.bound = false
    if self.window then
        local view = self.window.view
        view.StateChanged = {opt = TableOprationMode.Remove, this = self}
    end
end

function Transition:WaitForDone(): CS.System.Object
    return ExecutorsExt.Instance:WaitWhile(function (): boolean
        return not self.done
    end)
end

function Transition:StateChanged(sender: ViewBaseType, args: WindowStateEventArgsType)
    self:RaiseStateChanged(sender, args.State)
end

function Transition:RaiseStateChanged(window: ViewBaseType, state: number)
    if self.onStateChanged then
        self.onStateChanged(window, state)
    end
end

function Transition:RaiseStart()
    if self.onStart then
        self.onStart()
    end    
end

function Transition:RaiseFinished()
    if self.onFinish then
        self.onFinish()
    end    
end

function Transition:OnStart()
    self:Bind()
    self:RaiseStart()
end

function Transition:OnEnd()
    self.done = true
    self:RaiseFinished()
    self:Unbind()
end

function Transition:GetAwaiter(): TransitionAwaiterType
    return TransitionAwaiter(self)
end

function Transition:OnStartByCallBack(callback: function): TransitionType
    if self.running then
        return self    
    end

    self.onStart = callback
    return self
end

function Transition:OnStateChanged(callback: function): TransitionType
    if self.running then
        return self
    end

    self.onStateChanged = callback
    return self
end

function Transition:OnFinish(callback: function): TransitionType
    if self.done then
        callback()
        return self
    end

    self.onFinish = callback
    return self
end

function Transition:DisableAnimation(disabled: boolean): TransitionType
    if self.running then
        return self
    end

    self.animationDisabled = disabled
    return self
end

function Transition:TransitionTask()
    self.running = true
    self:OnStart()
    
    local result = ExecutorsExt.Instance:RunOnCoroutine(CoroutineExt.GetEnumerator(function ()
        self:DoTransition()
    end))
    CoroutineExt.Yield(result:WaitForDone())

    self:OnEnd()
end

function Transition:DoTransition()
    print("DoTransition")
end

function Transition:dtor()
end

return Transition