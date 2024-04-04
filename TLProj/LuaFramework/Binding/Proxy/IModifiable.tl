local IModifiable = class("IModifiable") as IModifiableType

function IModifiable:ctor()
end

function IModifiable:SetValue(value: any)
    assert({value}, "")
end

function IModifiable:dtor()
end

return IModifiable