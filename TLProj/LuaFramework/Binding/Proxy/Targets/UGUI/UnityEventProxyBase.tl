local EventTargetProxyBase = require("LuaFramework.Binding.Proxy.Targets.Universal.EventTargetProxyBase")
local IProxyInvoker = require("LuaFramework.Binding.Reflection.IProxyInvoker")
local TableOprationMode = require("LuaFramework.Binding.TableOprationMode")
local BindingMode = require("LuaFramework.Binding.BindingMode")
local ICommand = require("LuaFramework.Commands.ICommand")

local UnityEventProxyBase = class("UnityEventProxyBase", EventTargetProxyBase) as UnityEventProxyBaseType

function UnityEventProxyBase.get:DefaultMode(): number
    return BindingMode.OneWay
end

function UnityEventProxyBase:ctor(target: LuaObject, unityEvent: string)
    EventTargetProxyBase.ctor(self, target)

    self.command = nil
    self.invoker = nil
    self.interactable = nil
    self.unityEvent = unityEvent
end

function UnityEventProxyBase:BindEvent()
end

function UnityEventProxyBase:UnbindEvent()
end

function UnityEventProxyBase:IsValidInvoker(invoker: IProxyInvokerType)
    assert({invoker}, "")
end

function UnityEventProxyBase:SetValue(value: any)
    local target = self.target
    if nil == target then
        return
    end

    if self.invoker then
        self.invoker = nil
    end

    if self.command then
        self:UnbindCommand(self.command)
        self.command = nil
    end

    if nil == value then
        return
    end

    if "userdata" == type(value) then
        return
    end

    if type(value) == "table" then
        if (value as LuaObject).is(IProxyInvoker) then
            self.invoker = value as IProxyInvokerType
            return
        end

        if (value as LuaObject).is(ICommand) then
            if nil == self.interactable or "" == self.interactable then
                self.interactable = "interactable"
            end
    
            self.command = value as ICommandType
            self:BindCommand(self.command)
            self:UpdateTargetInteractable()
            return
        end
    end
end

function UnityEventProxyBase:OnCanExecuteChanged(sender: LuaObject, ...: any)
    assert({sender, ...}, "")
    self:UpdateTargetInteractable()
end

function UnityEventProxyBase:UpdateTargetInteractable()
    local target = self.target
    if nil == self.interactable or "" == self.interactable or nil == target then
        return
    end

    local value = nil == self.command and false or self.command:CanExecute()
    classset(target, self.interactable, value)
end

function UnityEventProxyBase:BindCommand(command: ICommandType)
    if nil == command then
        return
    end

    command.CanExecuteChanged = {opt = TableOprationMode.Add, save = "", this = self, callback = self.OnCanExecuteChanged}
end

function UnityEventProxyBase:UnbindCommand(command: ICommandType)
    if nil == command then
        return
    end

    command.CanExecuteChanged = {opt = TableOprationMode.Remove, save = ""}
end

function UnityEventProxyBase:dtor()
end

return UnityEventProxyBase