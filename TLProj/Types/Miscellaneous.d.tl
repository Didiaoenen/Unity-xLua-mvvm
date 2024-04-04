local record CSNameType
    TestTemp_1_Single: string
    ProgressResult_1_Single: string
end

local record CSTypeType
    ObjectT: CS.System.Type
    CanvasT: CS.System.Type
    TransformT: CS.System.Type
    GameObjectT: CS.System.Type
    CanvasGroupT: CS.System.Type
    RectTransformT: CS.System.Type

    TextT: CS.System.Type
    ButtonT: CS.System.Type
    InputFieldT: CS.System.Type
    GraphicRaycasterT: CS.System.Type

    UnityEventBaseT: CS.System.Type
end

global record MiscellaneousType
    CSName: CSNameType
    CSType: CSTypeType
end