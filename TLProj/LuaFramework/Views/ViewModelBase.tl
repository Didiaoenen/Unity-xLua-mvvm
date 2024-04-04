local ObservableObject = require("LuaFramework.Observables.ObservableObject")

local ViewModelBase = class("ViewModelBase", ObservableObject) as ViewModelBaseType

function ViewModelBase.get:Parent(): TransformExtType
    return self.parent
end

function ViewModelBase.set:Parent(value: TransformExtType)
    self:Set({name = "parent"}, value, "Parent")
end

function ViewModelBase.get:LocalRotation(): CS.UnityEngine.Quaternion
    return self.localRotation
end

function ViewModelBase.set:LocalRotation(value: CS.UnityEngine.Quaternion)
    self:Set({name = "localRotation"}, value, "LocalRotation")
end

function ViewModelBase.get:LocalPosition(): CS.UnityEngine.Vector3
    return self.localPosition
end

function ViewModelBase.set:LocalPosition(value: CS.UnityEngine.Vector3)
    self:Set({name = "localPosition"}, value, "LocalPosition")
end

function ViewModelBase.get:LocalScale(): CS.UnityEngine.Vector3
    return self.localScale
end

function ViewModelBase.set:LocalScale(value: CS.UnityEngine.Vector3)
    self:Set({name = "localScale"}, value, "LocalScale")
end

function ViewModelBase.get:OffsetMax(): CS.UnityEngine.Vector2
    return self.offsetMax
end

function ViewModelBase.set:OffsetMax(value: CS.UnityEngine.Vector2)
    self:Set({name = "offsetMax"}, value, "OffsetMax")
end

function ViewModelBase.get:OffsetMin(): CS.UnityEngine.Vector2
    return self.offsetMin
end

function ViewModelBase.set:OffsetMin(value: CS.UnityEngine.Vector2)
    self:Set({name = "offsetMin"}, value, "OffsetMin")
end

function ViewModelBase.get:ActiveSelf(): boolean
    return self.activeSelf
end

function ViewModelBase.set:ActiveSelf(value: boolean)
    self:Set({name = "activeSelf"}, value, "ActiveSelf")
end

function ViewModelBase.get:OverrideSorting(): boolean
    return self.overrideSorting
end

function ViewModelBase.set:OverrideSorting(value: boolean)
    self:Set({name = "overrideSorting"}, value, "OverrideSorting")
end

function ViewModelBase.get:SortingOrder(): number
    return self.sortingOrder
end

function ViewModelBase.set:SortingOrder(value: number)
    self:Set({name = "sortingOrder"}, value, "SortingOrder")
end

function ViewModelBase.get:Alpha(): number 
    return self.alpha
end

function ViewModelBase.set:Alpha(value: number)
    self:Set({name = "alpha"}, value, "Alpha")
end

function ViewModelBase:ctor(window: WindowFactoryType)
    ObservableObject.ctor(self)
    -- self.messenger = messenger

    self.window = window

    self.localRotation = CS.UnityEngine.Quaternion.identity
    self.localPosition = CS.UnityEngine.Vector3.zero
    self.localScale = CS.UnityEngine.Vector3.one
    self.offsetMax = CS.UnityEngine.Vector2.zero
    self.offsetMin = CS.UnityEngine.Vector2.zero
    self.activeSelf = true
    self.overrideSorting = true
    self.sortingOrder = 0
    self.alpha = 1
end

function ViewModelBase:SetWithBroadCast(field: SetType, newValue: any, propertyName: string, broadcast: boolean)
    if field ~= newValue then
        ObservableObject.Set(self as ObservableObjectType, field, newValue, propertyName)

        if broadcast then
            local oldValue = classget(self as LuaObject, field.name)
            self:Broadcast(oldValue, newValue, propertyName)
        end
    end
end

function ViewModelBase:Broadcast(oldValue: any, newVlaue: any, propertyName: string)
    assert({oldValue, newVlaue, propertyName}, "")
end

function ViewModelBase:dtor()
end

return ViewModelBase