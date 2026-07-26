local record TestWin

    prefabPath: string
    windowType: number

    root: GameObjectBindType
    
    Text: TextBindType

    new: function
    ctor: function
    dtor: function

    OnInit: function
    OnBind: function

    OnStart: function
    OnShow: function
    OnHide: function
end

return TestWin
