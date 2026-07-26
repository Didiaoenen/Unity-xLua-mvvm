local ViewBase = require("LuaFramework.Views.ViewBase")

local WindowEnum = require("LuaFramework.Views.WindowEnum")
local TableOperationMode = require("LuaFramework.Binding.TableOperationMode")

local MapExtension = require("LuaFramework.Common.MapExtension")
local AsyncResultExt = require("LuaFramework.Asynchronous.AsyncResultExt")

local WindowBase = class("WindowBase", ViewBase) as WindowBaseType

WindowBase.windowType = WindowEnum.WindowType.NONE

function WindowBase.opt:ActivatedChanged(value: OptHandlerType)
    if value.opt == TableOperationMode.Add then
        self.activatedChanged[value.save] = value
    end
    
    if value.opt == TableOperationMode.Remove then
        self.activatedChanged[value.save] = nil
    end
end

function WindowBase.opt:StateChanged(value: OptHandlerType)
    if value.opt == TableOperationMode.Add then
        self.stateChanged[value.save] = value
    end
    
    if value.opt == TableOperationMode.Remove then
        self.stateChanged[value.save] = nil
    end
end

function WindowBase.get:Activated(): boolean
    return self.activated
end

function WindowBase.set:Activated(value: boolean)
    if value ~= self.activated then
        self.activated = value
        self:OnActivatedChanged()
        self:RaiseActivatedChanged()
    end
end

function WindowBase.get:State(): number
    return self.state
end

function WindowBase.set:State(value: number)
    if value ~= self.state then
        self.state = value
        self:RaiseStateChanged()
    end
end

function WindowBase.get:WindowType(): number
    return self.windowType
end

function WindowBase.get:ActivationAnimation(): UIAnimationType
    return self.activationAnimation
end

function WindowBase.set:ActivationAnimation(activationAnimation: UIAnimationType)
    self.activationAnimation = activationAnimation
end

function WindowBase.get:PassivationAnimation(): UIAnimationType
    return self.passivationAnimation
end

function WindowBase.set:PassivationAnimation(passivationAnimation: UIAnimationType)
    self.passivationAnimation = passivationAnimation
end

function WindowBase:ctor(name: string, parent: TransformExtType)
    ViewBase.ctor(self, name, self, parent)
    self.activatedChanged = {}
    self.stateChanged = {}
end

function WindowBase:RaiseActivatedChanged()
    MapExtension.Foreach(self.activatedChanged, function (_: number, v: EventHandlerType)
        v.callback(v.this, self)
    end)
end

function WindowBase:RaiseStateChanged()
    MapExtension.Foreach(self.stateChanged, function (_: number, v: EventHandlerType)
        v.callback(v.this, self, self.state)
    end)
end

function WindowBase:OnActivatedChanged()

end

function WindowBase:Activate(ignoreAnimation: boolean): AsyncResultExtType
    local result = AsyncResultExt.new()

    if not self.visibility then
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

function WindowBase:Passivate(ignoreAnimation: boolean): AsyncResultExtType
    local result = AsyncResultExt.new()

    if not self.visibility then
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

function WindowBase:Create()
    ViewBase.Create(self as ViewBaseType)
    print("WindowBase Create")
end

function WindowBase:OnCreate()
    ViewBase.OnCreate(self as ViewBaseType)
    print("WindowBase OnCreate")
    
    local layer = WindowManager.Instance:GetLayer(self.windowType)
    self.canvas.SortingOrder = layer:PushWindowOrder()

    -- self.viewModel.Parent = self.parent

    -- local bindingSet = self.bindingSet as BindingSetType

    -- RectTransform
    -- self.transform = self:GetComponent(RectTransformExt as ComponentExtType) as TransformExtType
    -- local builder = bindingSet:BindByTarget(self.transform as LuaObject)
    -- builder:For(self.transform.Parent):To("Parent"):OneWay()
    -- self.transform:SetParent(self.parent)

    -- local builder = bindingSet:BindByTarget(self.transform as LuaObject)
    -- builder:For(self.transform.LocalRotation):To("LocalRotation"):OneWay()
    
    -- builder = bindingSet:BindByTarget(self.transform as LuaObject)
    -- builder:For(self.transform.LocalPosition):To("LocalPosition"):OneWay()

    -- builder = bindingSet:BindByTarget(self.transform as LuaObject)
    -- builder:For(self.transform.LocalScale):To("LocalScale"):OneWay()

    -- builder = bindingSet:BindByTarget(self.transform as LuaObject)
    -- builder:For((self.transform as RectTransformExtType).OffsetMax):To("OffsetMax"):OneWay()

    -- builder = bindingSet:BindByTarget(self.transform as LuaObject)
    -- builder:For((self.transform as RectTransformExtType).OffsetMin):To("OffsetMin"):OneWay()

    -- Canvas
    -- local canvas = self:AddComponent(CanvasExt) as CanvasExtType
    -- builder = bindingSet:BindByTarget(canvas.handler as LuaObject)
    -- builder:For(canvas.OverrideSorting):To("OverrideSorting"):OneWay()
    
    -- builder = bindingSet:BindByTarget(canvas.handler as LuaObject)
    -- builder:For(canvas.SortingOrder):To("SortingOrder"):OneWay()

    -- CanvasGroup
    -- local canvasGroup = self:AddComponent(CanvasGroupExt) as CanvasGroupExtType
    -- builder = bindingSet:BindByTarget(canvasGroup.handler as LuaObject)
    -- builder:For(canvasGroup.Alpha):To("Alpha"):OneWay()

    -- GraphicRaycaster
    -- local graphicRaycaster = self:AddComponent(GraphicRaycasterExt) as GraphicRaycasterExtType
    -- assert({graphicRaycaster}, "");

    -- GameObject
    -- builder = bindingSet:BindByTarget(self.gameObject as LuaObject)
    -- builder:For(self.gameObject.ActiveSelf):To("ActiveSelf"):OneWay()
end

function WindowBase:Show(args: any, ignoreAnimation: boolean): TransitionType
    print("WindowBase Show")

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

    return WindowManager.Instance:Show(self):DisableAnimation(ignoreAnimation)
end

function WindowBase:DoShow(ignoreAnimation: boolean): AsyncResultExtType
    local result = AsyncResultExt.new()
    local action = function (promise: AsyncResultExtType)

        self:OnShow()
        self.visibility = true
        self.rectTransform.Parent = WindowManager.Instance.uiRoot;
        (self.rectTransform as TransformBindType).LocalPosition = CS.UnityEngine.Vector3.zero

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

function WindowBase:OnShow()
    ViewBase.OnShow(self as ViewBaseType)
    print("WindowBase OnShow")
end

function WindowBase:Hide(ignoreAnimation: boolean): TransitionType
    print("WindowBase Hide")

    if not self.created then
        return
    end

    if self.dismissTransition or self.dismissed then
        return
    end

    if not self.visibility then
        return
    end
    
    return WindowManager.Instance:Hide(self):DisableAnimation(ignoreAnimation)
end

function WindowBase:DoHide(ignoreAnimation: boolean): AsyncResultExtType
    print("WindowBase DoHide")

    local result = AsyncResultExt.new()
    local action = function (promise: AsyncResultExtType)
        if not ignoreAnimation and self.ExitAnimation then
            self.ExitAnimation:OnStart(function ()
                self.State = WindowEnum.ViewState.EXIT_ANIMATION_BEGIN
            end):OnEnd(function ()
                self.State = WindowEnum.ViewState.EXIT_ANIMATION_END

                self.visibility = false
                self.rectTransform.Parent = WindowManager.Instance.uiRemote;
                (self.rectTransform as TransformBindType).LocalPosition = CS.UnityEngine.Vector3.zero
                self.State = WindowEnum.ViewState.INVISIBLE
                self:OnHide()
                promise:SetResult()
            end):Play()
        else
            self.visibility = false
            self.rectTransform.Parent = WindowManager.Instance.uiRemote;
            (self.rectTransform as TransformBindType).LocalPosition = CS.UnityEngine.Vector3.zero
            self.State = WindowEnum.ViewState.INVISIBLE
            self:OnHide()
            promise:SetResult()
        end
    end
    action(result)
    return result
end

function WindowBase:OnHide()
    ViewBase.OnHide(self as ViewBaseType)
    print("WindowBase OnHide")
end

function WindowBase:Dismiss(ignoreAnimation: boolean): TransitionType
    print("WindowBase Dismiss")
    
    if self.dismissTransition then
        return self.dismissTransition
    end

    if self.dismissed then
        return
    end

    self.dismissTransition = WindowManager.Instance:Dismiss(self):DisableAnimation(ignoreAnimation)
    return self.dismissTransition
end

function WindowBase:DoDismiss()
    ViewBase.DoDismiss(self as ViewBaseType)
    print("WindowBase DoDismiss")

    -- if not self.dismissed then
    --     assert(self.gameObject, "")
    --     self.State = WindowEnum.ViewState.DISMISS_BEGIN
    --     self.dismissed = true
    --     self:OnDismiss()
    --     self:RaiseOnDismissed()
    --     CS.UnityEngine.Object.Destroy(self.gameObject.handler as CS.UnityEngine.Object)
    --     self.State = WindowEnum.ViewState.DISMISS_END
    --     self.dismissTransition = nil
    -- end
end

function WindowBase:OnDismiss()
    ViewBase.OnDismiss(self as ViewBaseType)
    print("WindowBase OnDismiss")
end

function WindowBase:dtor()
    ViewBase.dtor(self as ViewBaseType)
    print("WindowBase dtor")

    -- local layer = WindowManager.Instance:GetLayer(self.windowType)
    -- layer:PopWindowOder()
end

return WindowBase