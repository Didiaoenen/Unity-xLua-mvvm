local ListExtention = require("LuaFramework.Common.ListExtention")

local ViewGroup = class("ViewGroup") as ViewGroupType

function ViewGroup:ctor(window: WindowFactoryType)
    self.views = {}
    self.window = window
end

function ViewGroup:OnEnable()
end

function ViewGroup:OnDisable()
end

function ViewGroup:OnShow()
    ListExtention.Foreach(self.views, function (_: number, v: ViewBaseType)
        v:DoShow()
    end)
end

function ViewGroup:OnHide()
    ListExtention.Foreach(self.views, function (_: number, v: ViewBaseType)
        v:DoHide()
    end)
    ListExtention.Foreach(self.views, function (_: number, v: ViewBaseType)
        v:DoDismiss()
    end)
end

function ViewGroup:GetView(name: string): ViewBaseType
    return ListExtention.Find(self.views, function(_: number, view: ViewBaseType): boolean
        if view.Name == name then
            return true
        end
    end) as ViewBaseType
end

function ViewGroup:AddView(name: string, parent: TransformExtType, ...: any): ViewBaseType
    local config = WindowConfig.Instance.ViewConfig[name]
    if nil == config then
        return
    end
    
    local view = config.View.new(self.window, config, parent, ...)

    table.insert(self.views, view)
    
    view:Create()

    return view
end

function ViewGroup:RemoveView(name: string): ViewBaseType
    return ListExtention.Remove(self.views, function(_: number, view: ViewBaseType): boolean
        if view.Name == name then
            return true
        end
    end) as ViewBaseType
end

function ViewGroup:dtor()
end

return ViewGroup