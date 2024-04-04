local Layer = require("Luaframework.Views.Layer")
local WindowEnum = require("LuaFramework.Views.WindowEnum")
local MapExtention = require("LuaFramework.Common.MapExtention")
local ListExtention = require("LuaFramework.Common.ListExtention")
local TransitionExecutor = require("Luaframework.Views.TransitionExecutor")

local Transition = require("LuaFramework.Views.Transition")
local CoroutineExt = require("LuaFramework.Common.CoroutineExt")

local LayerConfig = require("Game.UI.Config.LayerConfig")
local WindowFactory = require("LuaFramework.Views.WindowFactory")

local RectTransformExt = require("LuaFramework.Views.Components.RectTransformExt")

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

function WindowManager.get:Current(): WindowFactoryType
    return self.windowStack[#(self.windowStack)]
end

function WindowManager:ctor()
    self.current = nil

    self.layers = {}
    self.windows = {}
    self.windowStack = {}
    self.hideWindows = {}

    self.uiRoot = RectTransformExt.new(CS.UnityEngine.GameObject.Find("UIRoot").transform) as TransformExtType

    self:InitLayers()
end

function WindowManager:__singleton(): WindowManager
    return WindowManager.new()
end

function WindowManager:OnEnable()

end

function WindowManager:OnDisable()

end

function WindowManager:Show(window: WindowFactoryType): TransitionType
    local transition = TransitionShow.new(self, window)
    GetTransitionExecutor():Execute(transition as TransitionType)
    return (transition as TransitionType):OnStateChanged(function (_: ViewBaseType, state: number)
        if state == WindowEnum.ViewState.VISIBLE then
        end
    end)
end

function WindowManager:Hide(window: WindowFactoryType): TransitionType
    local transition = TransitionHide.new(self, window, false)
    GetTransitionExecutor():Execute(transition as TransitionType)
    return (transition as TransitionType):OnStateChanged(function (_: ViewBaseType, state: number)
        if state == WindowEnum.ViewState.INVISIBLE then
        end
    end)
end

function WindowManager:Dismiss(window: WindowFactoryType): TransitionType
    local transition = TransitionHide.new(self, window, true)
    GetTransitionExecutor():Execute(transition as TransitionType)
    return (transition as TransitionType):OnStateChanged(function (_: ViewBaseType, state: number)
        if state == WindowEnum.ViewState.INVISIBLE then
        end
    end)
end

function WindowManager:PushWindowStack(window: WindowFactoryType): WindowFactoryType
    local preCurrent = self.Current
    table.insert(self.windowStack, window)
    return preCurrent
end

function WindowManager:PopWindowStack(): WindowFactoryType
    table.remove(self.windowStack, #(self.windowStack))
    return self.Current
end

function WindowManager:ClearWindowStack()
    -- for i = #(self.windowStack), 1, -1 do
    --     self.windowStack[i]:OnDismiss()
    -- end
    -- self.windowStack = {}
end

function WindowManager:InitLayers()
    ListExtention.Foreach(LayerConfig, function (_: number, v: LayerType)
        local layer = Layer.new(v)
        table.insert(self.layers, layer)
    end)
end

function WindowManager:GetLayer(windowType: number): LayerType
    return ListExtention.Find(self.layers, function (_: number, v: LayerType): boolean
        return v.WindowType == windowType
    end) as LayerType
end

function WindowManager:OpenWindow(name: string, parent: TransformExtType, ...: any): WindowFactoryType
    local window = self:GetWindow(name)
    if nil == window then
        window = WindowFactory.new()
        self.windows[name] = window
    end

    local config = WindowConfig.Instance.WindowConfig[name]
    if nil == config then
        return
    end

    window.name = name
    window.windowType = config.WindowType

    local viewConfig = config.ViewConfig

    window.viewModel = config.ViewModel.new(window)
    window.view = viewConfig.View.new(window, viewConfig, parent or self.uiRoot, ...)
    window.view:Create()

    return window
end

function WindowManager:CloseWindow(name: string)
    assert({name}, "")
end

function WindowManager:GetWindow(name: string): WindowFactoryType
    return MapExtention.Find(self.windows, function (_: number, v: ViewBaseType): boolean
        return v.Name == name
    end) as WindowFactoryType
end

function WindowManager:dtor()
end

----------------------------------------------
function TransitionShow:ctor(manager: WindowManager, window: WindowFactoryType)
    Transition.ctor(self, window)
    self.manager = manager
end

function TransitionShow:Overlay(previous: ViewBaseType): number
    if previous.WindowType == WindowEnum.WindowType.FULL then
        return WindowEnum.ActionType.Hide
    end

    if previous.WindowType == WindowEnum.WindowType.POPUP then
        return WindowEnum.ActionType.Dismiss
    end

    return WindowEnum.ActionType.None
end

function TransitionShow:DoTransition()
    Transition.DoTransition(self as TransitionType)
    local current = self.window

    local previous: WindowFactoryType = nil
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
        local policy = self.OverlayPolicy
        if nil == policy then
            policy = self.Overlay
        end

        local view = previous.view
        local actionType = policy(self, view, current)
        if actionType == WindowEnum.ActionType.Hide then
            local hide = view:DoHide(self.AnimationDisabled)
            CoroutineExt.Yield(hide:WaitForDone())
        elseif actionType == WindowEnum.ActionType.Dismiss then
            local hide = view:DoHide(self.AnimationDisabled)
            CoroutineExt.Yield(hide:WaitForDone())
            view:DoDismiss()
        end
    end

    if false == current.view.Visibility then
        local show = current.view:DoShow(self.AnimationDisabled)
        CoroutineExt.Yield(show:WaitForDone())
    end
end

function TransitionShow:dtor()
end
----------------------------------------------

----------------------------------------------
function TransitionHide:ctor(manager: WindowManager, window: WindowFactoryType, dismiss: boolean)
    Transition.ctor(self, window)
    self.dismiss = dismiss
    self.manager = manager
end

function TransitionHide:DoTransition()
    Transition.DoTransition(self as TransitionType)
    local current = self.window
    
    local view = current.view
    if view.Visibility then
        local hide = view:DoHide(self.AnimationDisabled)
        CoroutineExt.Yield(hide:WaitForDone())
    end

    if self.dismiss then
        view:DoDismiss()
    end

    local previous: WindowFactoryType = nil
    if current.windowType == WindowEnum.WindowType.NONE then
    elseif current.windowType == WindowEnum.WindowType.BG then
    elseif current.windowType == WindowEnum.WindowType.FULL then
        previous = WindowManager.Instance:PopWindowStack()
    elseif current.windowType == WindowEnum.WindowType.POPUP or current.windowType == WindowEnum.WindowType.DIALOG then
    end

    if previous then
        local show = previous.view:DoShow(self.AnimationDisabled)
        CoroutineExt.Yield(show:WaitForDone())
    end
end

function TransitionHide:dtor()
end
----------------------------------------------