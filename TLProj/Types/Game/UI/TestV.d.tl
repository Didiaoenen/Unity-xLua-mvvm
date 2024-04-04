local record TestV
    PrefabPath: string

    windowType: number 

    viewModel: TestVMType
    bindingExt: BindingExtensionType
    bindingSet: BindingSetBaseType

    new: function(...: any): TestV
    ctor: function
    dtor: function

    Create: function(self: TestV)
    OnCreate: function(self: TestV)
    OnShow: function(self: TestV)
    GetComponentWithName: function(self: TestV, ComponentExtType, string): ComponentExtType
    TestFunc: function(self: TestV, any, any)
    TestButtonSimpleCommand: function(self: TestV, ...: any)
    TestToggleSimpleCommand: function(self: TestV, ...: any)
    TestInputFieldSimpleCommand: function(self: TestV, ...: any)

    GetView: function(self: TestV, name: string): ViewBaseType
    AddView: function(self: TestV, name: string, parent: TransformExtType, ...: any): ViewBaseType
    RemoveView: function(self: TestV, name: string): ViewBaseType
end

return TestV