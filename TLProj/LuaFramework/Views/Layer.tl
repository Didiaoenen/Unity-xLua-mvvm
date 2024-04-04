local Layer = class("Layer") as LayerType

function Layer.get:WindowType(): number
    return self.windowType
end

function Layer.set:WindowType(value: number)
    self.windowType = value
end

function Layer:ctor(data: LayerDataType)
    self.windowType = data.WindowType
    self.orderInLayer = data.OrderInLayer
    self.orderStep = data.OrderStep

    self.maxOrder = self.orderInLayer
    self.minOrder = self.orderInLayer
end

function Layer:PushWindowOrder(): number
    local oldOrder = self.maxOrder
	self.maxOrder = self.maxOrder + self.orderStep
	return oldOrder
end

function Layer:PopWindowOder()
    assert(self.maxOrder > self.minOrder, "")
	self.maxOrder = self.maxOrder - self.orderStep
end

function Layer:dtor()
end

return Layer