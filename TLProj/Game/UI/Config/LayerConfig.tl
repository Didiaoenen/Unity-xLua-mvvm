local WindowEnum = require("LuaFramework.Views.WindowEnum")

local LayerConfig: {LayerConfigType} = {
	{WindowType = WindowEnum.WindowType.NONE, OrderInLayer = 0, OrderStep = 10},
	{WindowType = WindowEnum.WindowType.FULL, OrderInLayer = 1000, OrderStep = 10},
	{WindowType = WindowEnum.WindowType.POPUP, OrderInLayer = 2000, OrderStep = 10},
	{WindowType = WindowEnum.WindowType.DIALOG, OrderInLayer = 3000, OrderStep = 10},
	{WindowType = WindowEnum.WindowType.PROGRESS, OrderInLayer = 4000, OrderStep = 10},
	{WindowType = WindowEnum.WindowType.QUEUED_POPUP, OrderInLayer = 5000, OrderStep = 10},
}

return LayerConfig