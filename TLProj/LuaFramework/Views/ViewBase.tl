local CoroutineExt = require("LuaFramework.Common.CoroutineExt")
local ExecutorsExt = require("LuaFramework.Execution.ExecutorsExt")
local VariableArrayMonoExt = require("LuaFramework.Views.ComponentExts.VariableArrayMonoExt")
local BindingExtension = require("LuaFramework.Binding.BindingExtension")

local MapExtension = require("LuaFramework.Common.MapExtension")
local ListExtension = require("LuaFramework.Common.ListExtension")
local Miscellaneous = require("LuaFramework.Common.Miscellaneous")
local DefaultUIViewLocator = require("LuaFramework.Views.Locators.DefaultUIViewLocator")

local WindowEnum = require("LuaFramework.Views.WindowEnum")
local BindingMode = require("LuaFramework.Binding.BindingMode")
local TableOperationMode = require("LuaFramework.Binding.TableOperationMode")

local CanvasBind = require("LuaFramework.Views.ComponentBinds.CanvasBind")
local GameObjectBind = require("LuaFramework.Views.ComponentBinds.GameObjectBind")
local CanvasGroupBind = require("LuaFramework.Views.ComponentBinds.CanvasGroupBind")
local RectTransformBind = require("LuaFramework.Views.ComponentBinds.RectTransformBind")
local GameObjectExt = require("LuaFramework.Views.ComponentExts.GameObjectExt")

local Messenger = require("LuaFramework.Messaging.Messenger")

local ViewBase = class("ViewBase") as ViewBaseType

ViewBase.actionType = WindowEnum.ActionType.NONE
ViewBase.prefabPath = ""

function ViewBase.get:Messenger(): MessengerType
    return self.messenger
end

function ViewBase.opt:VisibilityChanged(value: OptHandlerType)
    if value.opt == TableOperationMode.Add then
        self.visibilityChanged[value.save] = value
    end
    
    if value.opt == TableOperationMode.Remove then
        self.visibilityChanged[value.save] = nil
    end
end

function ViewBase.opt:OnDismissed(value: OptHandlerType)
    if value.opt == TableOperationMode.Add then
        self.onDismissed[value.save] = value
    end
    
    if value.opt == TableOperationMode.Remove then
        self.onDismissed[value.save] = nil
    end
end

function ViewBase.get:Created(): boolean
    return self.created
end

function ViewBase.get:Visibility(): boolean
    return self.root.activeSelf
end

function ViewBase.set:Visibility(value: boolean)
    self.root.activeSelf = value
end

function ViewBase.get:Dismissed(): boolean
    return self.dismissed
end

function ViewBase.get:Name(): string
    return self.name
end

function ViewBase.get:Parent(): TransformExtType
    return self.parent
end

function ViewBase.get:GameObject(): GameObjectExtType
    return self.gameObject
end

function ViewBase.get:Transform(): TransformExtType
    return self.rectTransform as TransformExtType
end

function ViewBase.get:RectTransform(): RectTransformExtType
    return self.rectTransform
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

function ViewBase:ctor(name: string, window: WindowBaseType, parent: RectTransformExtType)

    self.name = name
    self.window = window
    self.parent = parent
    
    self.variables = nil
    self.gameObject = nil

    self.transform = nil
    self.rectTransform = nil

    self.enterAnimation = nil
    self.exitAnimation = nil

    self.created = false
    self.visibility = false
    self.dismissed = false
    self.dismissTransition = nil
    
    self.visibilityChanged = {}
    self.onDismissed = {}

    self.components = {}
    self.gameObjects = {}

    self.views = {}

    self.messenger = Messenger.new()

    self.bindingExt = BindingExtension.new(self)

    self.root = GameObjectBind.new("root")
    
    self.rectTransform = RectTransformBind.new("transform", WindowManager.Instance.uiRemote)

    self.canvas = CanvasBind.new("canvas")
    self.canvasGroup = CanvasGroupBind.new("canvasGroup")
end

function ViewBase:RaiseVisibilityChanged()
    MapExtension.Foreach(self.visibilityChanged, function (_: number, v: EventHandlerType)
        v.callback(v.this, self)
    end)
end

function ViewBase:RaiseOnDismissed()
    MapExtension.Foreach(self.onDismissed, function (_: number, v: EventHandlerType)
        v.callback(v.this, self)
    end)
end

function ViewBase:Create()
    print("ViewBase Create")

    if self.created then
        return
    end

    if self.dismissTransition or self.dismissed then
        return
    end
    
    self.visibility = false

    self.result = ExecutorsExt.Instance:RunOnCoroutine(CoroutineExt.Instance:GetEnumerator(function ()

        local result = DefaultUIViewLocator.Instance:LoadAsync(self.prefabPath, Miscellaneous.CSType.GameObjectT)
        CoroutineExt.Instance:Yield(result:WaitForDone())

        local prefab = result.Result as CS.UnityEngine.Object
        local parent = self.parent.handler as CS.UnityEngine.Transform
        self.gameObject = GameObjectExt.new(CS.UnityEngine.Object.Instantiate(prefab, parent, false))

        self.variables = self:GetComponent(VariableArrayMonoExt) as VariableArrayMonoExtType

        self.root:BindWithObject(self as ViewBaseType, self.gameObject as LuaObject, {BindingMode.OneWay})
        
        self.rectTransform:BindWithComponent(self as ViewBaseType, {BindingMode.OneWay})

        self.canvas:BindWithComponent(self as ViewBaseType, {BindingMode.OneWay})
        self.canvasGroup:BindWithComponent(self as ViewBaseType, {BindingMode.OneWay})

        self.created = true

        self:OnCreate()
        self:Init()
        self:Bind()

        self:Start()
        self:Show()

        print("加载完成。。。")

    end))
end

function ViewBase:OnCreate()
    print("ViewBase OnCreate")
    self.canvas.SortingOrder = self.window.canvas.SortingOrder + 10
end

function ViewBase:Init()
    print("ViewBase Init")
    self:OnInit()
end

function ViewBase:OnInit()
    print("ViewBase OnInit")
end

function ViewBase:Bind()
    print("ViewBase Bind")
    self:OnBind()
end

function ViewBase:OnBind()
    print("ViewBase OnBind")
end

function ViewBase:Start()
    print("ViewBase Start")
    self:OnStart()
end

function ViewBase:OnStart()
    print("ViewBase OnStart")
end

function ViewBase:Show(args: any, _: boolean)
    print("ViewBase Show")

    if not self.created then
        self:Create()
        return
    end

    if self.dismissTransition or self.dismissed then
        return
    end

    if self.visibility then
        return
    end
    
    self.args = args
    self.visibility = true
    self.rectTransform.Parent = self.parent;
    (self.rectTransform as TransformBindType).LocalPosition = CS.UnityEngine.Vector3.zero

    self:OnShow()

    -- return WindowManager.Instance:Show(self.window):DisableAnimation(ignoreAnimation)
end

-- function ViewBase:DoShow(ignoreAnimation: boolean): AsyncResultExtType
--     local result = AsyncResultExt.new()
--     local action = function (promise: AsyncResultExtType)
--         if not self.created then
--             self:Create()
--         end

--         self.root.ActiveSelf = true
--         self.State = WindowEnum.ViewState.VISIBLE
--         self:OnShow()

--         if not ignoreAnimation and self.EnterAnimation then
--             self.EnterAnimation:OnStart(function ()
--                 self.State = WindowEnum.ViewState.ENTER_ANIMATION_BEGIN
--             end):OnEnd(function ()
--                 self.State = WindowEnum.ViewState.ENTER_ANIMATION_END
--                 promise:SetResult()
--             end):Play()
--         else
--             promise:SetResult()
--         end
--     end
--     action(result)
--     return result
-- end

function ViewBase:OnShow()
    print("ViewBase OnShow")
end

function ViewBase:Hide(_: boolean): TransitionType
    print("ViewBase Hide")

    if not self.created then
        return
    end

    if self.dismissTransition or self.dismissed then
        return
    end

    if not self.visibility then
        return
    end

    self.visibility = false
    self.rectTransform.Parent = WindowManager.Instance.uiRemote;
    (self.rectTransform as TransformBindType).LocalPosition = CS.UnityEngine.Vector3.zero

    self:OnHide()

    -- return WindowManager.Instance:Hide(self.window):DisableAnimation(ignoreAnimation)
end

-- function ViewBase:DoHide(ignoreAnimation: boolean): AsyncResultExtType
--     local result = AsyncResultExt.new()
--     local action = function (promise: AsyncResultExtType)
--         if not ignoreAnimation and self.ExitAnimation then
--             self.ExitAnimation:OnStart(function ()
--                 self.State = WindowEnum.ViewState.EXIT_ANIMATION_BEGIN
--             end):OnEnd(function ()
--                 self.State = WindowEnum.ViewState.EXIT_ANIMATION_END
--                 self.root.ActiveSelf = false
--                 self.State = WindowEnum.ViewState.INVISIBLE
--                 self:OnHide()
--                 promise:SetResult()
--             end):Play()
--         else
--             self.root.ActiveSelf = false
--             self.State = WindowEnum.ViewState.INVISIBLE
--             self:OnHide()
--             promise:SetResult()
--         end
--     end
--     action(result)
--     return result
-- end

function ViewBase:OnHide()
    print("ViewBase OnHide")
end

function ViewBase:Dismiss(_: boolean): TransitionType
    print("ViewBase Dismiss")
    
    if self.dismissTransition then
        return self.dismissTransition
    end

    if self.dismissed then
        return
    end

    -- self.dismissTransition = WindowManager.Instance:Dismiss(self.window):DisableAnimation(ignoreAnimation)
    -- return self.dismissTransition

    self:OnDismiss()
end

-- function ViewBase:DoDismiss()
--     if not self.dismissed then
--         assert(self.gameObject, "")
--         self.State = WindowEnum.ViewState.DISMISS_BEGIN
--         self.dismissed = true
--         self:OnDismiss()
--         self:RaiseOnDismissed()
--         CS.UnityEngine.Object.Destroy(self.gameObject.handler as CS.UnityEngine.Object)
--         self.State = WindowEnum.ViewState.DISMISS_END
--         self.dismissTransition = nil
--     end
-- end

function ViewBase:OnDismiss()
    print("ViewBase OnDismiss")
end

function ViewBase:GetComponentWithName(component: ComponentExtType, name: string): ComponentExtType
    component = component.new(self.variables:Get(name))
    table.insert(self.components, component)
    return component
end

function ViewBase:GetGameObjectWithName(gameObject: GameObjectExtType, name: string): GameObjectExtType
    gameObject = gameObject.new(self.variables:Get(name))
    table.insert(self.gameObjects, gameObject)
    return gameObject
end

function ViewBase:GetComponent(component: ComponentExtType): ComponentExtType
    component = component.new(self.gameObject:GetComponent(typeof(component.CSObject)))
    table.insert(self.components, component)
    return component
end

function ViewBase:AddComponent(component: ComponentExtType): ComponentExtType
    component = component.new(self.gameObject:AddComponent(typeof(component.CSObject)))
    table.insert(self.components, component)
    return component
end

function ViewBase:ShowView(name: string, window: WindowBaseType, parent: RectTransformExtType, args: any, ignoreAnimation: boolean): ViewBaseType

    local requiredView = WindowConfig.Instance.viewConfig[name]

    if nil == requiredView then
        return
    end

    local view = self.views[name]
    if nil == view then
        view = (requiredView as ViewBaseType).new(name, window, parent)
        self.views[name] = view
    end

    view:Show(args, ignoreAnimation)

    return view
end

function ViewBase:HideView(name: string, ignoreAnimation: boolean)
    local view = self.views[name]
    if nil == view then
        return
    end

    view:Hide(ignoreAnimation)
end

function ViewBase:GetView(name: string): ViewBaseType
    return self.views[name]
end

function ViewBase:Cancel()
    if self.result then
        self.result:Cancel()
        self.result = nil
    end
end

function ViewBase:dtor()
    print("ViewBase dtor")
    
    ListExtension.Foreach(self.gameObjects, function (_: number, v: ComponentExtType)
        v:delete()
    end)
    self.gameObjects = nil

    ListExtension.Foreach(self.components, function (_: number, v: ComponentExtType)
        v:delete()
    end)
    self.components = nil

    if not self.dismissed and not self.dismissTransition then
        self:Dismiss(true)
    end
end

return ViewBase