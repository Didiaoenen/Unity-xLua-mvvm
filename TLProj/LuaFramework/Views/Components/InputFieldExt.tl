local ComponentExt = require("LuaFramework.Views.Components.ComponentExt")
local GameObjectExt = require("LuaFramework.Views.Components.GameObjectExt")

local InputFieldExt = class("InputFieldExt", ComponentExt) as InputFieldExtType

InputFieldExt.CSObject = CS.UnityEngine.UI.InputField as CS.UnityEngine.Component

InputFieldExt.Text = "text"

InputFieldExt.OnEndEdit = "onEndEdit"

InputFieldExt.OnValueChanged = "onValueChanged"

function InputFieldExt.get:text(): string
    local handler = self.handler as CS.UnityEngine.UI.InputField
    return handler.text
end

function InputFieldExt.set:text(value: string)
    local handler = self.handler as CS.UnityEngine.UI.InputField
    handler.text = value
end

function InputFieldExt.get:onEndEdit(): CS.UnityEngine.UI.InputField.SubmitEvent
    local handler = self.handler as CS.UnityEngine.UI.InputField
    return handler.onEndEdit
end

function InputFieldExt.set:onEndEdit(value: CS.UnityEngine.UI.InputField.SubmitEvent)
    local handler = self.handler as CS.UnityEngine.UI.InputField
    handler.onEndEdit = value
end

function InputFieldExt.get:onValueChanged(): CS.UnityEngine.UI.InputField.OnChangeEvent
    local handler = self.handler as CS.UnityEngine.UI.InputField
    return handler.onValueChanged
end

function InputFieldExt.set:onValueChanged(value: CS.UnityEngine.UI.InputField.OnChangeEvent)
    local handler = self.handler as CS.UnityEngine.UI.InputField
    handler.onValueChanged = value
end

function InputFieldExt.get:GameObject(): GameObjectExtType
    return self.gameObject
end

function InputFieldExt:ctor(handler: CS.UnityEngine.Component)
    ComponentExt.ctor(self, handler)
    self.gameObject = GameObjectExt.new(handler.gameObject)
end

function InputFieldExt:dtor()
end

return InputFieldExt