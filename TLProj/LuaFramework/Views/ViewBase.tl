local ViewGroup = require("LuaFramework.Views.ViewGroup")

local CoroutineExt = require("LuaFramework.Common.CoroutineExt")
local Miscellaneous = require("LuaFramework.Common.Miscellaneous")
local ListExtention = require("LuaFramework.Common.ListExtention")
local ExecutorsExt = require("LuaFramework.Execution.ExecutorsExt")
local DefaultUIViewLocator = require("LuaFramework.Views.Locators.DefaultUIViewLocator")

local WindowEnum = require("LuaFramework.Views.WindowEnum")
local Messenger = require("LuaFramework.Messaging.Messenger")
local AsyncResultExt = require("LuaFramework.Asynchronous.AsyncResultExt")
local WindowStateEventArgs = require("LuaFramework.Views.WindowStateEventArgs")

local CanvasExt = require("LuaFramework.Views.Components.CanvasExt")
local GameObjectExt = require("LuaFramework.Views.Components.GameObjectExt")
local CanvasGroupExt = require("LuaFramework.Views.Components.CanvasGroupExt")
local RectTransformExt = require("LuaFramework.Views.Components.RectTransformExt")
local GraphicRaycasterExt = require("LuaFramework.Views.Components.GraphicRaycasterExt")
local MonoVariableArrayExt = require("LuaFramework.Views.Components.MonoVariableArrayExt")

local ViewBase = class("ViewBase", ViewGroup) as ViewBaseType

function ViewBase.get:Messenger(): MessengerType
    return self.messenger
end

function ViewBase.set:ActivatedChanged(value: EventHandlerType)
    setcallback(self.activatedChanged, value)
end

function ViewBase.set:VisibilityChanged(value: EventHandlerType)
    setcallback(self.visibilityChanged, value)
end

function ViewBase.set:OnDismissed(value: EventHandlerType)
    setcallback(self.onDismissed, value)
end

function ViewBase.set:StateChanged(value: EventHandlerType)
    setcallback(self.stateChanged, value)
end

function ViewBase.get:Created(): boolean
    return self.created
end

function ViewBase.get:Dismissed(): boolean
    return self.dismissed
end

function ViewBase.get:Activated(): boolean
    return self.activated
end

function ViewBase.set:Activated(value: boolean)
    if value ~= self.activated then
        self.activated = value
        self:RaiseActivatedChanged()
    end
end

function ViewBase.get:State(): number
    return self.state
end

function ViewBase.set:State(value: number)
    if value ~= self.state then
        local old = self.state
        self.state = value
        self:RaiseStateChanged(old, self.state)
    end
end

function ViewBase.get:WindowType(): number
    return self.windowType
end

function ViewBase.get:EnterAnimation(): UIAnimationType
    return self.enterAnimation
end

function ViewBase.set:EnterAnimation(value: UIAnimationType)
    self.enterAnimation = value
end

function ViewBase.get:ExitAnimation(): UIAnimationType
    return self.exitAnimation
end

function ViewBase.set:ExitAnimation(value: UIAnimationType)
    self.exitAnimation = value
end

function ViewBase.get:Name(): string
    return self.gameObject.name
end

function ViewBase.get:Parent(): TransformExtType
    return self.parent
end

function ViewBase.get:Owner(): GameObjectExtType
    return self.gameObject
end

function ViewBase.get:Transform(): TransformExtType
    return self.transform
end

function ViewBase.get:Visibility(): boolean
    return self.viewModel.ActiveSelf
end

function ViewBase.set:Visibility(value: boolean)
    if not self.viewModel then
        return
    end

    if self.viewModel.ActiveSelf == value then
        return
    end

    self.viewModel.ActiveSelf = value
end

function ViewBase:ctor(window: WindowFactoryType, config: ViewConfigTable, parent: TransformExtType, ...: any)
    ViewGroup.ctor(self)

    assert(window, "window is nil")
    self.window = window

    self.name = config.Name
    self.state = config.State
    self.prefabPath = config.PrefabPath
    self.viewType = config.ViewType

    self.viewModel = window.viewModel
    self.windowType = window.windowType

    self.parent = parent
    -- self.viewModel.Parent = parent
    
    self.bundle = {...}
    
    self.messenger = Messenger.new()

    self.gameObject = nil
    self.transform = nil

    self.dismissTransition = nil
    self.enterAnimation = nil
    self.exitAnimation = nil

    self.mutex = true
    self.created = false
    self.dismissed = false
    self.activated = false
    self.stateBroadcast = true
    
    self.activatedChanged = {}
    self.visibilityChanged = {}
    self.onDismissed = {}
    self.stateChanged = {}

    self.bindingExt = nil
    self.bindingSet = nil

    self.variables = nil
    self.components = {}
    self.gameObjects = {}
end

function ViewBase:OnEnable()
    self:RaiseVisibilityChanged()
end

function ViewBase:OnDisable()
    self:RaiseVisibilityChanged()
end

function ViewBase:RaiseActivatedChanged()
    ListExtention.Foreach(self.activatedChanged, function (_: number, v: EventHandlerType)
        v.callback(v.this, self)
    end)
end

function ViewBase:RaiseVisibilityChanged()
    ListExtention.Foreach(self.visibilityChanged, function (_: number, v: EventHandlerType)
        v.callback(v.this, self)
    end)
end

function ViewBase:RaiseOnDismissed()
    ListExtention.Foreach(self.onDismissed, function (_: number, v: EventHandlerType)
        v.callback(v.this, self)
    end)
end

function ViewBase:RaiseStateChanged(oldState: number, newState: number)
    local eventArgs = WindowStateEventArgs.new(self, oldState, newState)
    ListExtention.Foreach(self.stateChanged, function (_: number, v: EventHandlerType)
        v.callback(v.this, self, eventArgs)
    end)
end

function ViewBase:Activate(ignoreAnimation: boolean): AsyncResultExtType
    local result = AsyncResultExt.new()

    if not self.Visibility then
        return result
    end

    if self.Activated then
        result:SetResult()
        return result
    end

    if not ignoreAnimation and self.ActivationAnimation then
        self.ActivationAnimation:OnStart(function ()
            self.State = WindowEnum.ViewState.ACTIVATION_ANIMATION_BEGIN
        end):OnEnd(function ()
            self.State = WindowEnum.ViewState.ACTIVATION_ANIMATION_END
            self.Activated = true
            self.State = WindowEnum.ViewState.ACTIVATED
            result:SetResult()
        end):Play()
    else
        self.Activated = true
        self.State = WindowEnum.ViewState.ACTIVATED
        result:SetResult()
    end

    return result
end

function ViewBase:Passivate(ignoreAnimation: boolean): AsyncResultExtType
    local result = AsyncResultExt.new()

    if not self.Visibility then
        return result
    end

    if not self.Activated then
        result:SetResult()
        return result
    end

    self.Activated = false
    self.State = WindowEnum.ViewState.PASSIVATED

    if not ignoreAnimation and self.ActivationAnimation then
        self.ActivationAnimation:OnStart(function ()
            self.State = WindowEnum.ViewState.PASSIVATION_ANIMATION_BEGIN
        end):OnEnd(function ()
            self.State = WindowEnum.ViewState.PASSIVATION_ANIMATION_END
            result:SetResult()
        end):Play()
    else
        result:SetResult()
    end

    return result
end

function ViewBase:Create()
    if self.dismissTransition or self.dismissed then
        return
    end

    if self.created then
        return
    end
    
    ExecutorsExt.Instance:RunOnCoroutineNoReturn(CoroutineExt.GetEnumerator(function ()

        self.State = WindowEnum.ViewState.CREATE_BEGIN
        self.Visibility = false

        local result = DefaultUIViewLocator.LoadAsync(self.prefabPath, Miscellaneous.CSType.GameObjectT)
        CoroutineExt.Yield(result:WaitForDone())
        print("加载完成。。。")

        self.gameObject = GameObjectExt.new(result.Result)

        self:OnCreate()
        self.created = true
        self.State = WindowEnum.ViewState.CREATE_END

        self:Show()
    end))
end

function ViewBase:OnCreate()
    print("parent OnCreate")
    
    -- self.viewModel.Parent = self.parent

    self.variables = self:GetComponent(MonoVariableArrayExt) as MonoVariableArrayExtType

    local bindingSet = self.bindingSet as BindingSetType

    -- GameObject
    local builder = bindingSet:BindByTarget(self.gameObject as LuaObject)
    builder:For(self.gameObject.ActiveSelf):To("ActiveSelf"):OneWay()

    -- RectTransform
    self.transform = self:GetComponent(RectTransformExt as ComponentExtType) as TransformExtType
    -- builder = bindingSet:BindByTarget(self.transform as LuaObject)
    -- builder:For(self.transform.Parent):To("Parent"):OneWay()
    self.transform:SetParent(self.parent)

    builder = bindingSet:BindByTarget(self.transform as LuaObject)
    builder:For(self.transform.LocalRotation):To("LocalRotation"):OneWay()
    
    builder = bindingSet:BindByTarget(self.transform as LuaObject)
    builder:For(self.transform.LocalPosition):To("LocalPosition"):OneWay()

    builder = bindingSet:BindByTarget(self.transform as LuaObject)
    builder:For(self.transform.LocalScale):To("LocalScale"):OneWay()

    builder = bindingSet:BindByTarget(self.transform as LuaObject)
    builder:For((self.transform as RectTransformExtType).OffsetMax):To("OffsetMax"):OneWay()

    builder = bindingSet:BindByTarget(self.transform as LuaObject)
    builder:For((self.transform as RectTransformExtType).OffsetMin):To("OffsetMin"):OneWay()

    -- Canvas
    local canvas = self:AddComponent(CanvasExt) as CanvasExtType
    builder = bindingSet:BindByTarget(canvas.handler as LuaObject)
    builder:For(canvas.OverrideSorting):To("OverrideSorting"):OneWay()
    
    builder = bindingSet:BindByTarget(canvas.handler as LuaObject)
    builder:For(canvas.SortingOrder):To("SortingOrder"):OneWay()

    -- CanvasGroup
    local canvasGroup = self:AddComponent(CanvasGroupExt) as CanvasGroupExtType
    builder = bindingSet:BindByTarget(canvasGroup.handler as LuaObject)
    builder:For(canvasGroup.Alpha):To("Alpha"):OneWay()

    -- GraphicRaycaster
    self:AddComponent(GraphicRaycasterExt)

    self.bindingSet:Build()

    --
    local layer = WindowManager.Instance:GetLayer(self.windowType)
    assert(layer, "")

    self.viewModel.SortingOrder = layer:PushWindowOrder()
end

function ViewBase:Show(ignoreAnimation: boolean): TransitionType
    if self.dismissTransition or self.dismissed then
        return
    end

    if self.Visibility then
        return
    end

    return WindowManager.Instance:Show(self.window):DisableAnimation(ignoreAnimation)
end

function ViewBase:DoShow(ignoreAnimation: boolean): AsyncResultExtType
    local result = AsyncResultExt.new()
    local action = function (promise: AsyncResultExtType)
        if not self.created then
            self:Create()
        end

        self:OnShow()
        self.Visibility = true
        self.State = WindowEnum.ViewState.VISIBLE
        if not ignoreAnimation and self.EnterAnimation then
            self.EnterAnimation:OnStart(function ()
                self.State = WindowEnum.ViewState.ENTER_ANIMATION_BEGIN
            end):OnEnd(function ()
                self.State = WindowEnum.ViewState.ENTER_ANIMATION_END
                promise:SetResult()
            end):Play()
        else
            promise:SetResult()
        end
    end
    action(result)
    return result
end

function ViewBase:OnShow()
    print("parent OnShow")
end

function ViewBase:Hide(ignoreAnimation: boolean): TransitionType
    if not self.created then
        return
    end

    if self.dismissed then
        return
    end

    if not self.Visibility then
        return
    end

    return WindowManager.Instance:Hide(self.window):DisableAnimation(ignoreAnimation)
end

function ViewBase:DoHide(ignoreAnimation: boolean): AsyncResultExtType
    local result = AsyncResultExt.new()
    local action = function (promise: AsyncResultExtType)
        if not ignoreAnimation and self.ExitAnimation then
            self.ExitAnimation:OnStart(function ()
                self.State = WindowEnum.ViewState.EXIT_ANIMATION_BEGIN
            end):OnEnd(function ()
                self.State = WindowEnum.ViewState.EXIT_ANIMATION_END
                self.Visibility = false
                self.State = WindowEnum.ViewState.INVISIBLE
                self:OnHide()
                promise:SetResult()
            end):Play()
        else
            self.Visibility = false
            self.State = WindowEnum.ViewState.INVISIBLE
            self:OnHide()
            promise:SetResult()
        end
    end
    action(result)
    return result
end

function ViewBase:OnHide()
    
end

function ViewBase:Dismiss(ignoreAnimation: boolean): TransitionType
    if self.dismissTransition then
        return self.dismissTransition
    end

    if self.dismissed then
        return
    end

    self.dismissTransition = WindowManager.Instance:Dismiss(self.window):DisableAnimation(ignoreAnimation)
    return self.dismissTransition
end

function ViewBase:DoDismiss()
    if not self.dismissed then
        assert(self.gameObject, "")
        self.State = WindowEnum.ViewState.DISMISS_BEGIN
        self.dismissed = true
        self:OnDismiss()
        self:RaiseOnDismissed()
        CS.UnityEngine.Object.Destroy(self.gameObject.handler as CS.UnityEngine.Object)
        self.State = WindowEnum.ViewState.DISMISS_END
        self.dismissTransition = nil
    end
end

function ViewBase:OnDismiss()
    
end

function ViewBase:GetComponentWithName(component: ComponentExtType, name: string): ComponentExtType
    assert(component and name, "")
    component = component.new(self.variables:Get(name))
    table.insert(self.components, component)
    return component
end

function ViewBase:GetGameObjectWithName(gameObject: GameObjectExtType, name: string): GameObjectExtType
    assert(gameObject and name, "")
    gameObject = gameObject.new(self.variables:Get(name))
    table.insert(self.gameObjects, gameObject)
    return gameObject
end

function ViewBase:GetComponent(component: ComponentExtType): ComponentExtType
    assert(self.gameObject, "")
    return component.new(self.gameObject:GetComponent(typeof(component.CSObject)))
end

function ViewBase:AddComponent(component: ComponentExtType): ComponentExtType
    assert(self.gameObject, "")
    return component.new(self.gameObject:AddComponent(typeof(component.CSObject)))
end

function ViewBase:dtor()
    if not self.dismissed and not self.dismissTransition then
        self:Dismiss(true)
    end
    
    ListExtention.Foreach(self.components, function (_: number, v: ComponentExtType)
        v:delete()
    end)
    self.components = nil

    local layer = WindowManager.Instance:GetLayer(self.windowType)
    layer:PopWindowOder()
end

return ViewBase