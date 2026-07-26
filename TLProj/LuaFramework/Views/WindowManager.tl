local Layer = require("LuaFramework.Views.Layer")
local ListExtension = require("LuaFramework.Common.ListExtension")
local TransitionExecutor = require("LuaFramework.Views.TransitionExecutor")

local LayerConfig = require("Game.UI.Config.LayerConfig")
local WindowEnum = require("LuaFramework.Views.WindowEnum")

local Transition = require("LuaFramework.Views.Transition")
local CoroutineExt = require("LuaFramework.Common.CoroutineExt")
local RectTransformExt = require("LuaFramework.Views.ComponentExts.RectTransformExt")

WindowManager = class("WindowManager") as WindowManagerType

local TransitionShow = class("TransitionShow", Transition) as WindowManager.TransitionShowType

local TransitionHide = class("TransitionHide", Transition) as WindowManagerType.TransitionHideType

local blockingExecutor: TransitionExecutorType = nil

local GetTransitionExecutor = function (): TransitionExecutorType
    if not blockingExecutor then
        blockingExecutor = TransitionExecutor.new()
    end
    return blockingExecutor
end

function WindowManager.get:Current(): WindowBaseType
    return self.windowStack[#(self.windowStack)]
end

function WindowManager.get:PreCurrent(): WindowBaseType
    return self.windowStack[#(self.windowStack) - 1]
end

function WindowManager:ctor()
    self.layers = {}
    self.windows = {}
    self.windowStack = {}
    self.hideWindows = {}

    self.uiRoot = RectTransformExt.new(CS.UnityEngine.GameObject.Find("UIRoot").transform)
    self.uiRemote = RectTransformExt.new(CS.UnityEngine.GameObject.Find("UIRemote").transform)

    self:InitLayers()
end

function WindowManager:__singleton(): WindowManager
    return WindowManager.new()
end

function WindowManager:Show(window: WindowBaseType): TransitionType
    local transition = TransitionShow.new(self, window)
    GetTransitionExecutor():Execute(transition as TransitionType)
    return (transition as TransitionType):OnStateChanged(function (_: ViewBaseType, state: number)
        if state == WindowEnum.ViewState.VISIBLE then
        end
    end)
end

function WindowManager:Hide(window: WindowBaseType): TransitionType
    local transition = TransitionHide.new(self, window, false)
    GetTransitionExecutor():Execute(transition as TransitionType)
    return (transition as TransitionType):OnStateChanged(function (_: ViewBaseType, state: number)
        if state == WindowEnum.ViewState.INVISIBLE then
        end
    end)
end

function WindowManager:Dismiss(window: WindowBaseType): TransitionType
    local transition = TransitionHide.new(self, window, true)
    GetTransitionExecutor():Execute(transition as TransitionType)
    return (transition as TransitionType):OnStateChanged(function (_: ViewBaseType, state: number)
        if state == WindowEnum.ViewState.INVISIBLE then
        end
    end)
end

function WindowManager:PushWindowStack(window: WindowBaseType): WindowBaseType
    local preCurrent = self.Current
    table.insert(self.windowStack, window)
    return preCurrent
end

function WindowManager:PopWindowStack(): WindowBaseType
    table.remove(self.windowStack, #(self.windowStack))
    return self.Current
end

function WindowManager:ClearWindowStack()
    for i = #(self.windowStack), 1, -1 do
        self.windowStack[i]:DoDismiss()
    end
    self.windowStack = {}
end

function WindowManager:InitLayers()
    ListExtension.Foreach(LayerConfig, function (_: number, v: LayerType)
        local layer = Layer.new(v)
        table.insert(self.layers, layer)
    end)
end

function WindowManager:GetLayer(windowType: number): LayerType
    return ListExtension.Find(self.layers, function (_: number, v: LayerType): boolean
        return v.WindowType == windowType
    end) as LayerType
end

function WindowManager:ShowWindow(name: string, args: any, ignoreAnimation: boolean): WindowBaseType
    
    local requiredWindow = WindowConfig.Instance.windowConfig[name]

    if nil == requiredWindow then
        return
    end

    local window = self.windows[name]

    if nil == window then
        window = (requiredWindow as WindowBaseType).new(name, self.uiRemote)
        self.windows[name] = window
    end

    window:Show(args, ignoreAnimation)
    
    return window
end

function WindowManager:HideWindow(name: string, ignoreAnimation: boolean)
    local window = self.windows[name]
    if nil == window then
        return
    end

    window:Hide(ignoreAnimation)
end

function WindowManager:GetWindow(name: string): WindowBaseType
    return self.windows[name]
end

function WindowManager:dtor()
    self:ClearWindowStack()
end

----------------------------------------------
function TransitionShow:ctor(manager: WindowManager, window: WindowBaseType)
    Transition.ctor(self, window)
    self.manager = manager
end

function TransitionShow:DoTransition()
    Transition.DoTransition(self as TransitionType)
    local current = self.window

    local previous: WindowBaseType = nil
    if current.windowType == WindowEnum.WindowType.NONE then
    elseif current.windowType == WindowEnum.WindowType.BG then
    elseif current.windowType == WindowEnum.WindowType.FULL then
        previous = WindowManager.Instance:PushWindowStack(current)
    elseif current.windowType == WindowEnum.WindowType.POPUP or current.windowType == WindowEnum.WindowType.DIALOG then
        if current.windowType == WindowManager.Instance.Current.windowType then
            previous = WindowManager.Instance:PushWindowStack(current)
        end
    end

    if previous then

        if previous.Activated then
            local activate = current:Activate(self.AnimationDisabled)
            CoroutineExt.Instance:Yield(activate:WaitForDone())
        end

        if current.actionType == WindowEnum.ActionType.HIDE then
            local hide = previous:DoHide(self.AnimationDisabled)
            CoroutineExt.Instance:Yield(hide:WaitForDone())
        elseif current.actionType == WindowEnum.ActionType.DISMISS then
            local hide = previous:DoHide(self.AnimationDisabled)
            CoroutineExt.Instance:Yield(hide:WaitForDone())
            previous:DoDismiss()
        end
    end

    if not current.visibility then
        local show = current:DoShow(self.AnimationDisabled)
        CoroutineExt.Instance:Yield(show:WaitForDone())
    end

    if current == WindowManager.Instance.Current then
        local activate = current:Activate(self.AnimationDisabled)
        CoroutineExt.Instance:Yield(activate:WaitForDone())
    end
end

function TransitionShow:dtor()
end
----------------------------------------------

----------------------------------------------
function TransitionHide:ctor(manager: WindowManager, window: WindowBaseType, dismiss: boolean)
    Transition.ctor(self, window)
    self.dismiss = dismiss
    self.manager = manager
end

function TransitionHide:DoTransition()
    Transition.DoTransition(self as TransitionType)
    local current = self.window
    
    if current.visibility then
        if current.actionType == WindowEnum.ActionType.HIDE then
            local hide = current:DoHide(self.AnimationDisabled)
            CoroutineExt.Instance:Yield(hide:WaitForDone())
        elseif current.actionType == WindowEnum.ActionType.DISMISS then
            local hide = current:DoHide(self.AnimationDisabled)
            CoroutineExt.Instance:Yield(hide:WaitForDone())
            current:DoDismiss()
        end
    end

    local previous: WindowBaseType = nil
    if current.windowType == WindowEnum.WindowType.NONE then
    elseif current.windowType == WindowEnum.WindowType.BG then
    elseif current.windowType == WindowEnum.WindowType.FULL then
        previous = WindowManager.Instance:PopWindowStack()
    elseif current.windowType == WindowEnum.WindowType.POPUP or current.windowType == WindowEnum.WindowType.DIALOG then
        if current.windowType == WindowManager.Instance.PreCurrent.windowType then
            previous = WindowManager.Instance:PopWindowStack()
        end
    end

    if previous then
        local show = previous:DoShow(self.AnimationDisabled)
        CoroutineExt.Instance:Yield(show:WaitForDone())
    end
end

function TransitionHide:dtor()
end
----------------------------------------------