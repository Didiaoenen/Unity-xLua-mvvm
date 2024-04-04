global record WindowTypeType
    NONE: number
    BG: number
    FULL: number
    POPUP: number
    DIALOG: number
    PROGRESS: number
    QUEUED_POPUP: number
end

global record ViewTypeType
    VIEW: number
    SUB_AREA: number
    SUB_PANEL: number
end

global record ViewStateType
    NONE: number
    CREATE_BEGIN: number
    CREATE_END: number
    ENTER_ANIMATION_BEGIN: number
    VISIBLE: number
    ENTER_ANIMATION_END: number
    ACTIVATION_ANIMATION_BEGIN: number
    ACTIVATED: number
    ACTIVATION_ANIMATION_END: number
    PASSIVATION_ANIMATION_BEGIN: number
    PASSIVATED: number
    PASSIVATION_ANIMATION_END: number
    EXIT_ANIMATION_BEGIN: number
    INVISIBLE: number
    EXIT_ANIMATION_END: number
    DISMISS_BEGIN: number
    DISMISS_END: number
end

global record ActionTypeType
    None: number
    Hide: number
    Dismiss: number
end

global record WindowEnumType
    WindowType: WindowTypeType
    ViewState: ViewStateType
    ViewType: ViewTypeType
    ActionType: ActionTypeType
end

global record BindingModeType
    Default: number         
    TwoWay: number          
    OneWay: number          
    OneTime: number         
    OneWayToSource: number  
end

global record TableOprationModelType
    Add: number         
    Remove: number          
end

global record LayerDataType
    WindowType: number
    OrderInLayer: number
    OrderStep: number
end

global record TryCatchType
    {function}
    catch: function
    finally: function
end

global record LuaObject
    is: function(any): boolean
end

global record SetType
    name: string
end

global record OutProxyType
    ref: LuaObject
end

global record PriorityFactoryPairType
    factory: LuaObject
    priority: number
end

global record OptHandlerType
    opt: number
    save: string
    this: LuaObject
    callback: function
    args: PropertyChangedEventArgsType
end

global record EventHandlerType
    this: LuaObject
    callback: function
    args: PropertyChangedEventArgsType
end

global record UIAnimationType
    OnStart: function(self: UIAnimationType, function): UIAnimationType
    OnEnd: function(self: UIAnimationType, function): UIAnimationType
    Play: function(self: UIAnimationType): UIAnimationType
end

global type PriorityFactoryPairList = {PriorityFactoryPairType}

global record StandardBinderType
    sourceProxyFactory: SourceProxyBaseType
    targetProxyFactory: TargetProxyBaseType

    Instance: StandardBinderType

    __singleton: function(self: StandardBinderType): StandardBinderType

    new: function(...: any): StandardBinderType
    ctor: function
    delete: function
    dtor: function

    Bind: function(self: StandardBinderType, LuaObject, LuaObject, BindingDescriptionType): BindingType
end

global record BindingBuilderType
    target: LuaObject
    description: BindingDescriptionType

    new: function(...: any): BindingBuilderType
    ctor: function
    dtor: function

    For: function(self: BindingBuilderType, string, string): BindingBuilderType
    To: function(self: BindingBuilderType, string): BindingBuilderType
    OneWay: function(self: BindingBuilderType): BindingBuilderType
    OneWayToSource: function(self: BindingBuilderType): BindingBuilderType
    TwoWay: function(self: BindingBuilderType): BindingBuilderType
    OneTime: function(self: BindingBuilderType): BindingBuilderType
    CommandParameter: function(self: BindingBuilderType, ...: any): BindingBuilderType
    SetMode: function(self: BindingBuilderType, number)
    SetMemberPath: function(self: BindingBuilderType, string)
    SetCommandParameter: function(self: BindingBuilderType, ...: any)
end

global record BindingBuilderBaseType
    context: BindingContextType
    target: LuaObject
    builded: boolean
    scopeKey: string
    description: BindingDescriptionType

    ctor: function
    dtor: function

    SetMode: function(self: BindingBuilderBaseType, number)
    SetScopeKey: function(self: BindingBuilderBaseType, string)
    SetMemberPath: function(self: BindingBuilderBaseType, string)
    SetMemberPathWithPath: function(self: BindingBuilderBaseType, {string})
    SetCommandParameter: function(self: BindingBuilderBaseType, ...: any)
    CheckBindingDescription: function(self: BindingBuilderBaseType)
    Build: function(self: BindingBuilderBaseType)
end

global record BindingSetType
    builders: {BindingBuilderBaseType}
    context: BindingContextType
    target: LuaObject

    new: function(...: any): BindingSetType
    ctor: function
    dtor: function

    Bind: function(self: BindingSetType): BindingBuilderType
    BindByTarget: function(self: BindingSetType, LuaObject): BindingBuilderType
end

global record BindingSetBaseType
    context: BindingContextType
    builders: {BindingBuilderBaseType}

    ctor: function
    dtor: function

    Build: function(self: BindingSetBaseType)
end

global record BindingContextType
    record get
        dataContext: LuaObject
        DataContext: function
    end
    
    record set
        dataContext: LuaObject
        DataContext: function
    
        dataContextChanged: {EventHandlerType}
        DataContextChanged: function
    
        OnDataContextChanged: function
        RaiseDataContextChanged: function
    end
    
    dataContext: LuaObject
    DataContext: LuaObject

    dataContextChanged: {EventHandlerType}
    DataContextChanged: EventHandlerType
    
    owner: LuaObject
    bindings: {string:{BindingType}}
    DEFAULT_KEY: string

    new: function(...: any): BindingContextType
    ctor: function
    dtor: function

    OnDataContextChanged: function(self: BindingContextType)
    RaiseDataContextChanged: function(self: BindingContextType)
    GetOrCreateList: function(self: BindingContextType, string): {BindingType}
    Add: function(self: BindingContextType, BindingType, string)
    AddWithSingleDesc: function(self: BindingContextType, LuaObject, BindingDescriptionType, string)
end

global record PathParseType

    ctor: function

    Parse: function(string): {string}
end

global record PathTokenType
    record get
        paths: {string}
        Paths: function

        index: integer
        Index: function

        Current: function
    end
    
    paths: {string}
    index: integer
    Index: integer

    nextToken: PathTokenType
    Current: string

    new: function(...: any): PathTokenType
    ctor: function
    dtor: function

    HasNext: function(self: PathTokenType): boolean
    NextToken: function(self: PathTokenType): PathTokenType
end

global record ChainedObjectSourceProxyType
    record ProxyEntryType
        record get
            proxy: BindingProxyBaseType
            Proxy: function

            handler: EventHandlerType 
            Handler: function
        
            token: PathTokenType
            Token: function
        end

        record set
            proxy: BindingProxyBaseType
            Proxy: function

            handler: EventHandlerType 
            Handler: function
        
            token: PathTokenType
            Token: function
        end

        proxy: BindingProxyBaseType
        Proxy: BindingProxyBaseType
        
        handler: EventHandlerType
        Handler: EventHandlerType

        token: PathTokenType
        Token: PathTokenType

        new: function(...: any): ProxyEntryType
        ctor: function
        dtor: function
    end

    factory: INodeProxyFactoryType
    proxies: {ProxyEntryType}

    new: function(...: any): ChainedObjectSourceProxyType
    ctor: function
    dtor: function

    Bind: function(self: ChainedObjectSourceProxyType, LuaObject, PathTokenType)
    Rebind: function(self: ChainedObjectSourceProxyType, number)
    Unbind: function(self: ChainedObjectSourceProxyType)
    GetObtainable: function(self: ChainedObjectSourceProxyType): IObtainableType
    GetModifiable: function(self: ChainedObjectSourceProxyType): IModifiableType
    GetValue: function(self: ChainedObjectSourceProxyType): any
    SetValue: function(self: ChainedObjectSourceProxyType, any)
    RaiseValueChanged: function(self: ChainedObjectSourceProxyType)
end

global record INodeProxyFactoryType

    ctor: function

    Create: function(self: INodeProxyFactoryType, LuaObject, PathTokenType): SourceProxyBaseType
end

global record INodeProxyFactoryRegisterType

    ctor: function

    Register: function(self: INodeProxyFactoryRegisterType, factory: INodeProxyFactoryType, priority: number)
    Unregister: function(self: INodeProxyFactoryRegisterType, factory: INodeProxyFactoryType)
end

global record InteractionNodeProxyType
    source: LuaObject
    request: string
    invoker: LuaObject

    new: function(...: any): InteractionNodeProxyType
    ctor: function
    dtor: function

    BindEvent: function(self: InteractionNodeProxyType)
    UnbindEvent: function(self: InteractionNodeProxyType)
    OnRaised: function(self: InteractionNodeProxyType, LuaObject, ...: any)
    SetValue: function(self: InteractionNodeProxyType, any)
end

global record MethodNodeProxyType
    source: LuaObject
    methodInfo: string
    invoker: IProxyInvokerType

    new: function(...: any): MethodNodeProxyType
    ctor: function
    dtor: function

    GetValue: function(self: MethodNodeProxyType): any
end

global record ObjectSourceDescriptionType
    record get
        paths: {string}
        Paths: function
    end
    
    record set
        paths: {string}
        Paths: function
    end

    paths: {string}
    Paths: {string}
    isStatic: boolean

    new: function(...: any): ObjectSourceDescriptionType
    ctor: function
    dtor: function
end

global record ObjectSourceProxyFactoryType
    factories: {PriorityFactoryPairType}

    new: function(...: any): ObjectSourceProxyFactoryType
    ctor: function
    dtor: function

    Create: function(self: ObjectSourceProxyFactoryType, LuaObject, PathTokenType): SourceProxyBaseType
    TryCreateProxy: function(self: ObjectSourceProxyFactoryType, LuaObject, SourceDescriptionType, OutProxyType): boolean
    Register: function(self: ObjectSourceProxyFactoryType, INodeProxyFactoryType, number)
    Unregister: function(self: ObjectSourceProxyFactoryType, INodeProxyFactoryType)
end

global record ObservableNodeProxyType
    source: LuaObject
    propertyInfo: string
    
    new: function(...: any): ObservableNodeProxyType
    ctor: function
    dtor: function

    OnPropertyChanged: function(self: ObservableNodeProxyType, LuaObject, PropertyChangedEventArgsType)
    RaiseValueChanged: function(self: ObservableNodeProxyType)
    GetValue: function(self: ObservableNodeProxyType): any
    SetValue: function(self: ObservableNodeProxyType, any)
end

global record PropertyNodeProxyType
    source: LuaObject
    propertyInfo: string
    
    new: function(...: any): PropertyNodeProxyType
    ctor: function
    dtor: function

    OnPropertyChanged: function(self: PropertyNodeProxyType, LuaObject, PropertyChangedEventArgsType)
    RaiseValueChanged: function(self: PropertyNodeProxyType)
    GetValue: function(self: PropertyNodeProxyType): any
    SetValue: function(self: PropertyNodeProxyType, any)
end

global record UniversalNodeProxyFactoryType
    new: function(...: any): UniversalNodeProxyFactoryType
    ctor: function
    dtor: function
    
    Create: function(self: UniversalNodeProxyFactoryType, LuaObject, PathTokenType): SourceProxyBaseType
    CreateProxy: function(self: UniversalNodeProxyFactoryType, LuaObject, string): SourceProxyBaseType
end

global record ISourceProxyType
    record get
        Source: function
    end

    ctor: function
end

global record ISourceProxyFactoryType

    ctor: function

    CreateProxy: function(self: ISourceProxyFactoryType, LuaObject, SourceDescriptionType): SourceProxyBaseType
end

global record ISourceProxyFactoryRegistryType

    ctor: function

    Register: function(self: ISourceProxyFactoryRegistryType, ISourceProxyFactoryType, number)
    Unregister: function(self: ISourceProxyFactoryRegistryType, ISourceProxyFactoryType)
end

global record NotifiableSourceProxyBaseType
    record set
        valueChanged: {EventHandlerType}
        ValueChanged: function
    end

    valueChanged: {EventHandlerType}
    ValueChanged: function

    ctor: function
    dtor: function

    RaiseValueChanged: function(self: NotifiableSourceProxyBaseType)
end

global record SourceDescriptionType
    record get
        isStatic: boolean
        IsStatic: function
    end
    
    record set
        isStatic: boolean
        IsStatic: function
    end
    

    isStatic: boolean
    IsStatic: function(self: SourceDescriptionType): boolean

    ctor: function
    dtor: function
end

global record SourceProxyBaseType
    record get
        source: LuaObject
        Source: function
    end
    
    record set
        source: LuaObject
        Source: function
    end

    source: LuaObject

    ctor: function
    dtor: function
    delete: function
end

global record SourceProxyFactoryType
    factories: PriorityFactoryPairList

    new: function(...: any): SourceProxyFactoryType
    ctor: function
    dtor: function

    CreateProxy: function(self: SourceProxyFactoryType, LuaObject, SourceDescriptionType): SourceProxyBaseType
    TryCreateProxy: function(self: SourceProxyFactoryType, LuaObject, SourceDescriptionType, OutProxyType): boolean
    Register: function(self: SourceProxyFactoryType, ISourceProxyFactoryType, number)
    Unregister: function(self: SourceProxyFactoryType, ISourceProxyFactoryType)
end

global record TypedSourceProxyFactoryType
    ctor: function
    dtor: function

    IsSupported: function(self: TypedSourceProxyFactoryType, SourceDescriptionType): boolean
    CreateProxy: function(self: TypedSourceProxyFactoryType, LuaObject, SourceDescriptionType): SourceProxyBaseType
    TryCreateProxy: function(self: TypedSourceProxyFactoryType, LuaObject, SourceDescriptionType, OutProxyType): boolean
end

global record UnityEventProxyType
    target: LuaObject
    unityEvent: string

    command: ICommandType
    invoker: IProxyInvokerType

    new: function(...: any): UnityEventProxyType
    ctor: function
    dtor: function

    BindEvent: function(self: UnityEventProxyType)
    UnbindEvent: function(self: UnityEventProxyType)
    IsValidInvoker: function(self: UnityEventProxyType, IProxyInvokerType)
    OnEvent: function(self: UnityEventProxyType, ...: any)
end

global record UnityEventProxyBaseType
    record get
        DefaultMode: function
    end

    DefaultMode: number

    target: LuaObject
    unityEvent: string
    interactable: string

    command: ICommandType
    invoker: IProxyInvokerType

    ctor: function
    dtor: function

    BindEvent: function(self: UnityEventProxyBaseType)
    UnbindEvent: function(self: UnityEventProxyBaseType)
    IsValidInvoker: function(self: UnityEventProxyBaseType, IProxyInvokerType)
    SetValue: function(self: UnityEventProxyBaseType, any)
    OnCanExecuteChanged: function(self: UnityEventProxyBaseType, LuaObject, ...: any)
    UpdateTargetInteractable: function(self: UnityEventProxyBaseType)
    BindCommand: function(self: UnityEventProxyBaseType, ICommandType)
    UnbindCommand: function(self: UnityEventProxyBaseType, ICommandType)
end

global record UnityPropertyProxyType
    record get
        DefaultMode: function
    end

    DefaultMode: number

    target: LuaObject
    unityEvent: string

    new: function(...: any): UnityPropertyProxyType
    ctor: function
    dtor: function

    DoSubscribeForValueChange: function(self: UnityPropertyProxyType, LuaObject)
    DoUnsubscribeForValueChange: function(self: UnityPropertyProxyType)
    OnValueChanged: function(self: UnityPropertyProxyType, ...: any)
    RaiseValueChanged: function(self: UnityPropertyProxyType, ...: any)
end

global record UnityTargetProxyFactoryType
    new: function(...: any): UnityTargetProxyFactoryType
    ctor: function
    dtor: function

    CreateProxy: function(self: UnityTargetProxyFactoryType, LuaObject, BindingDescriptionType): TargetProxyBaseType
end

global record EventTargetProxyBaseType
    ctor: function
    dtor: function

    SetValue: function(self: EventTargetProxyBaseType, any)
end

global record InteractionTargetProxyType
    
    record get
        DefaultMode: function
    end

    target: LuaObject

    handler: any
    interactionAction: string
    
    new: function(...: any): InteractionTargetProxyType
    ctor: function
    dtor: function

    GetValue: function(self: InteractionTargetProxyType): any
    OnRequest: function(self: InteractionTargetProxyType, sender: LuaObject, args: InteractionEventArgsType)
end

global record MethodTargetProxyType
    record get
        DefaultMode: function
    
        methodInfo: string
        ProxyMethodInfo: function
    end

    DefaultMode: number

    methodInfo: string
    ProxyMethodInfo: string

    target: LuaObject
    invoker: IProxyInvokerType
    
    new: function(...: any): MethodTargetProxyType
    ctor: function
    dtor: function
    GetValue: function(self: MethodTargetProxyType): any
    Invoke: function(self: MethodTargetProxyType, LuaObject, ...:any)
end

global record PropertyTargetProxyType
    record get
        DefaultMode: function
    end

    target: LuaObject
    propertyInfo: string
    
    new: function(...: any): PropertyTargetProxyType
    ctor: function
    dtor: function

    DoSubscribeForValueChange: function(self: PropertyTargetProxyType, LuaObject)
    DoUnsubscribeForValueChange: function(self: PropertyTargetProxyType, LuaObject)
    OnPropertyChanged: function(self: PropertyTargetProxyType, LuaObject, PropertyChangedEventArgsType)
    RaiseValueChanged: function(self: PropertyTargetProxyType)
    GetValue: function(self: PropertyTargetProxyType): any
    SetValue: function(self: PropertyTargetProxyType, any)
end

global record UniversalTargetProxyFactoryType
    new: function(...: any): UniversalTargetProxyFactoryType
    ctor: function
    dtor: function

    CreateProxy: function(self: UniversalTargetProxyFactoryType, LuaObject, BindingDescriptionType): TargetProxyBaseType
end

global record ITargetProxyType
    record get
        Target: function
        DefaultMode: function
    end

    ctor: function
end

global record ITargetProxyFactoryType

    ctor: function

    CreateProxy: function(self: ITargetProxyFactoryType, LuaObject, BindingDescriptionType): TargetProxyBaseType
end

global record ITargetProxyFactoryRegisterType

    ctor: function

    Register: function(self: ITargetProxyFactoryRegisterType, factory: ITargetProxyFactoryType, priority: number)
    Unregister: function(self: ITargetProxyFactoryRegisterType, factory: ITargetProxyFactoryType)
end

global record TargetProxyBaseType
    record get
        target: LuaObject
        Target: function
    
        DefaultMode: function
    end
    
    record set
        target: LuaObject
        Target: function
    end

    target: LuaObject
    Target: LuaObject

    DefaultMode: number

    targetName: string

    ctor: function
    delete: function
    dtor: function

    IsAlive: function(self: TargetProxyBaseType, LuaObject): boolean
end

global record TargetProxyFactoryType
    factories: PriorityFactoryPairList

    new: function(...: any): TargetProxyFactoryType
    ctor: function
    dtor: function

    CreateProxy: function(self: TargetProxyFactoryType, LuaObject, BindingDescriptionType): TargetProxyBaseType
    TryCreateProxy: function(self: TargetProxyFactoryType, LuaObject, BindingDescriptionType, OutProxyType): boolean
    Register: function(self: TargetProxyFactoryType, ITargetProxyFactoryType, number)
    Unregister: function(self: TargetProxyFactoryType, ITargetProxyFactoryType)
end

global record ValueTargetProxyBaseType

    record opt
        subScribed: boolean

        valueChanged: {string: OptHandlerType}
        ValueChanged: function

        Subscribe: function
        Unsubscribe: function
    end

    subScribed: boolean

    valueChanged: {string: OptHandlerType}
    ValueChanged: function

    target: LuaObject

    ctor: function
    dtor: function

    Subscribe: function(self: ValueTargetProxyBaseType)
    Unsubscribe: function(self: ValueTargetProxyBaseType)
    DoSubscribeForValueChange: function(self: ValueTargetProxyBaseType, LuaObject)
    DoUnsubscribeForValueChange: function(self: ValueTargetProxyBaseType, LuaObject)
    RaiseValueChanged: function(self: ValueTargetProxyBaseType)
    GetValue: function(self: ValueTargetProxyBaseType): any
    SetValue: function(self: ValueTargetProxyBaseType, any)
end

global record IBindingProxyType
    ctor: function
    dtor: function
end

global record BindingProxyBaseType
    ctor: function
    dtor: function
end

global record IModifiableType
    ctor: function
    dtor: function

    SetValue: function(self: IModifiableType, any)
end

global record INotifiableType
    record opt
        ValueChanged: function
    end

    ctor: function
    dtor: function

    ValueChanged: EventHandlerType
end

global record IObtainableType
    ctor: function
    dtor: function

    GetValue: function(self: IObtainableType): any
end

global record IProxyInvokerType
    record get
        proxyMethodInfo: string
        ProxyMethodInfo: function(self: get): string
    end

    ctor: function
    dtor: function

    Invoke: function(self: IProxyInvokerType, ...: any): any...
end

global record ProxyInvokerType
    record get
        proxyMethodInfo: string
        ProxyMethodInfo: function(self: get): string
    end

    target: LuaObject
    proxyMethodInfo: string

    new: function(...: any): ProxyInvokerType
    ctor: function
    dtor: function

    Invoke: function(self: ProxyInvokerType, ...: any): any...
    ProxyMethodInfo: function(self: ProxyInvokerType): string
end

global record AbstractBindingType
    record get
        dataContext: LuaObject
        DataContext: function
    
        target: LuaObject
        Target: function

        IsAlive: function(self: get, LuaObject): boolean
    end
    
    record set
        dataContext: LuaObject
        DataContext: function

        OnDataContextChanged: function(self: set)
    end

    dataContext: LuaObject
    DataContext: LuaObject
    target: LuaObject
    Target: LuaObject

    ctor: function
    dtor: function

    IsAlive: function(self: AbstractBindingType, LuaObject): boolean
    OnDataContextChanged: function(self: AbstractBindingType)
end

global record BindingType
    record get
        bindingMode: number
        BindingMode: function
    
        targetProxy: TargetProxyBaseType
        bindingDescription: BindingDescriptionType
    end
    
    bindingMode: number
    BindingMode: number

    dataContext: LuaObject
    DataContext: LuaObject

    target: LuaObject
    Target: LuaObject

    targetProxy: TargetProxyBaseType
    sourceProxy: SourceProxyBaseType
    bindingDescription: BindingDescriptionType
    sourceProxyFactory: ISourceProxyFactoryType
    targetProxyFactory: ITargetProxyFactoryType

    new: function(...: any): BindingType
    ctor: function
    dtor: function

    CreateTargetProxy: function(self: BindingType, LuaObject, BindingDescriptionType)
    IsSubscribeTargetValueChanged: function(self: BindingType, number): boolean
    DisposeTargetProxy: function(self: BindingType)
    CreateSourceProxy: function(self: BindingType, LuaObject, SourceDescriptionType)
    IsSubscribeSourceValueChanged: function(self: BindingType, number): boolean
    DisposeSourceProxy: function(self: BindingType)
    UpdateTargetFromSource: function(self: BindingType)
    SetTargetValue: function(self: BindingType, LuaObject, any)
    UpdateSourceFromTarget: function(self: BindingType)
    SetSourceValue: function(self: BindingType, LuaObject, any)
    UpdateDataOnBind: function(self: BindingType)
    UpdateTargetOnFirstBind: function(self: BindingType, number)
    UpdateSourceOnFirstBind: function(self: BindingType, number)
end

global record BindingDescriptionType
    record get
        targetName: string
        TargetName: function
    
        updateTrigger: string
        UpdateTrigger: function
    
        mode: number
        Mode: function
    
        source: SourceDescriptionType
        Source: function
    
        commandParameter: LuaObject
        CommandParameter: function
    end
    
    record set
        targetName: string
        TargetName: function
    
        updateTrigger: string
        UpdateTrigger: function
    
        mode: number
        Mode: function
    
        source: SourceDescriptionType
        Source: function
    
        commandParameter: LuaObject
        CommandParameter: function
    end

    targetName: string
    TargetName: string

    updateTrigger: string
    UpdateTrigger: string

    mode: number
    Mode: number

    source: SourceDescriptionType
    Source: SourceDescriptionType

    commandParameter: LuaObject
    CommandParameter: function

    new: function(...: any): BindingDescriptionType
    ctor: function
    dtor: function
end

global record BindingExtensionType
    record get
        bindingContext: BindingContextType
        BindingContext: function

        behaviour: LuaObject
    end

    bindingContext: BindingContextType
    BindingContext: BindingContextType

    behaviour: LuaObject

    new: function(...: any): BindingExtensionType
    ctor: function
    dtor: function

    CreateBindingSet: function(self: BindingExtensionType): BindingSetType
    CreateBindingSetWithContext: function(self: BindingExtensionType, LuaObject): BindingSetType
    SetDataContext: function(self: BindingExtensionType, LuaObject)
    GetDataContext: function(self: BindingExtensionType): LuaObject
end



global record INotifyPropertyChangedType
    record opt
        propertyChanged: {string: OptHandlerType}
        PropertyChanged: function
    end

    propertyChanged: {string: OptHandlerType}
    PropertyChanged: OptHandlerType

    ctor: function
end

global record PropertyChangedEventArgsType
    record get
        propertyName: string
        PropertyName: function
    end
    
    propertyName: string
    PropertyName: string

    new: function(...: any): PropertyChangedEventArgsType
    ctor: function
end

global record UnityProxyRegisterType
    record Convert
        getter: function
        setter: function
    end

    registerProxies: {string:Convert}

    Instance: UnityProxyRegisterType

    __singleton: function(self: UnityProxyRegisterType): UnityProxyRegisterType

    new: function(...: any): UnityProxyRegisterType
    ctor: function
    dtor: function

    Initialize: function(self: UnityProxyRegisterType)
    Get: function(self: UnityProxyRegisterType, string): Convert
end

global record ICommandType
    record opt
        CanExecuteChanged: function
    end

    ctor: function
    dtor: function

    canExecuteChanged: {string: OptHandlerType}
    CanExecuteChanged: OptHandlerType

    CanExecute: function(self: ICommandType, parameter: any)
    Execute: function(self: ICommandType, parameter: any)
end

global record CommandBaseType
    record opt
        canExecuteChanged: {string: OptHandlerType}
        CanExecuteChanged: function
    end

    canExecuteChanged: {string: OptHandlerType}
    CanExecuteChanged: OptHandlerType

    ctor: function
    dtor: function

    RaiseExecuteChanged: function(self: CommandBaseType)
    CanExecute: function(self: CommandBaseType, ...: any)
    Execute: function(self: CommandBaseType, ...: any)
end

global record SimpleCommandType
    record get
        enabled: boolean
        Enabled: function
    end
    
    record set
        enabled: boolean
        Enabled: function
    
        RaiseCanExecuteChanged: function(self: set)
    end

    record opt
        executeChanged: {string: OptHandlerType}
        ExecuteChanged: function
    end

    enabled: boolean
    Enabled: boolean

    canExecuteChanged: {string: OptHandlerType}
    CanExecuteChanged: OptHandlerType

    execute: function

    new: function(...: any): SimpleCommandType
    ctor: function
    dtor: function

    RaiseExecuteChanged: function(self: SimpleCommandType)
    CanExecute: function(self: SimpleCommandType, ...: any)
    Execute: function(self: SimpleCommandType, ...: any)
end

global record InteractionEventArgsType
    record get
        context: LuaObject
        Context: function
    
        callback: function
        Callback: function
    end

    context: LuaObject
    Context: function
    
    callback: function
    Callback: function

    new: function(...: any): InteractionEventArgsType
    ctor: function
    dtor: function
end

global record IInteractionActionType
    ctor: function
    dtor: function

    OnRequest: function(self:IInteractionActionType, sender: LuaObject, args: InteractionEventArgsType)
end

global record IInteractionRequestType
    record get
        Raised: function
    end

    record set
        Raised: function
    end

    ctor: function
    dtor: function
end

global record InteractionRequestType
    record get
        raised: {string: OptHandlerType}
        Raised: function
    end

    record opt
        raised: {string: OptHandlerType}
        Raised: function
    end
    
    raised: {string: OptHandlerType}
    Raised: OptHandlerType

    sender: LuaObject

    new: function(...: any): InteractionRequestType
    ctor: function
    dtor: function

    Raise: function(self: InteractionRequestType, LuaObject, function)
end

global record MessengerType
    new: function(...: any): MessengerType
    ctor: function
    dtor: function
end

global record IObservablePropertyType
    record get
        ValueChanged: function

        Value: any
    end

    record set
        ValueChanged: function

        Value: any
    end

    ctor: function
    dtor: function
end

global record ObservableObjectType
    record set
        propertyChanged: {string: OptHandlerType}
        PropertyChanged: function
    end

    propertyChanged: {string: OptHandlerType}
    PropertyChanged: OptHandlerType

    ctor: function
    dtor: function

    RaisePropertyChanged: function(self: ObservableObjectType, string)
    RaisePropertyChangedWithParam: function(self: ObservableObjectType, PropertyChangedEventArgsType)
    Set: function(self: ObservableObjectType, SetType, any, string, boolean)
end

global record DefaultUIViewLocatorType
    LoadAsync: function(string, CS.System.Type): CS.Asynchronous.ProgressResult_1_Single
    DoLoad: function(CS.Asynchronous.ProgressResult_1_Single, string, CS.System.Type)
end

global record ViewGroupType
    views: {ViewBaseType}
    window: WindowFactoryType

    ctor: function
    dtor: function

    OnEnable: function(self: ViewGroupType)
    OnDisable: function(self: ViewGroupType)
    OnShow: function(self: ViewGroupType)
    OnHide: function(self: ViewGroupType)

    GetView: function(self: ViewGroupType, name: string): ViewBaseType
    AddView: function(self: ViewGroupType, name: string, parent: TransformExtType, ...: any): ViewBaseType
    RemoveView: function(self: ViewGroupType, name: string): ViewBaseType
end

global record LayerConfigType
    WindowType: number
    OrderInLayer: number
    OrderStep: number
end

global record LayerType
    record get
        windowType: number
        WindowType: function
    end

    record set
        windowType: number
        WindowType: function
    end
    
    windowType: number
    WindowType: number

    orderInLayer: number
    orderStep: number
    maxOrder: number
    minOrder: number

    new: function(...: any): LayerType
    ctor: function
    dtor: function

    PushWindowOrder: function(self: LayerType): number
    PopWindowOder: function(self: LayerType)
end

global record ModelBaseType

end

global record TransitionType
    record get
        window: WindowFactoryType
        Window: function
    
        done: boolean
        IsDone: function
    
        animationDisabled: boolean
        AnimationDisabled: function
    
        overlayPolicy: function
        OverlayPolicy: function
    end
    
    record set
        window: WindowFactoryType
        Window: function

        done: boolean
        IsDone: function
    
        animationDisabled: boolean
        AnimationDisabled: function
    
        overlayPolicy: function
        OverlayPolicy: function
    end
    
    window: WindowFactoryType
    done: boolean
    animationDisabled: boolean
    overlayPolicy: function
    running: boolean
    bound: boolean
    onStart: function
    onStateChanged: function
    onFinish: function

    ctor: function
    dtor: function

    Bind: function(self: TransitionType)
    Unbind: function(self: TransitionType)
    WaitForDone: function(self: TransitionType): CS.System.Object
    StateChanged: function(self: TransitionType, ViewBaseType, any)
    RaiseStateChanged: function(self: TransitionType, ViewBaseType, number)
    RaiseStart: function(self: TransitionType)
    RaiseFinished: function(self: TransitionType)
    OnStart: function(self: TransitionType)
    OnEnd: function(self: TransitionType)
    GetAwaiter: function(self: TransitionType)
    OnStartByCallBack: function(self: TransitionType, function)
    OnStateChanged: function(self: TransitionType, function): TransitionType
    OnFinish: function(self: TransitionType, function)
    DisableAnimation: function(self: TransitionType, boolean): TransitionType
    TransitionTask: function(self: TransitionType, boolean)
    DoTransition: function(self: TransitionType)
end

global record TransitionAwaiterType

    ctor: function
    dtor: function

    metamethod __call: function(self: TransitionAwaiterType, ...: any): TransitionAwaiterType
end

global record TransitionExecutorType
    record get
        running: boolean
        IsRunning: function
        Count: function
        transitions: {TransitionType}
    end

    taskResult: CS.Asynchronous.AsyncResult
    running: boolean
    transitions: {TransitionType}

    new: function(...: any): TransitionExecutorType
    ctor: function
    dtor: function

    Execute: function(self: TransitionExecutorType, TransitionType)
    ShutDone: function(self: TransitionExecutorType)
    DoTask: function(self: TransitionExecutorType)
end

global record ViewModelBaseType
    record get
        parent: TransformExtType
        Parent: function
    
        localRotation: CS.UnityEngine.Quaternion
        LocalRotation: function
    
        localPosition: CS.UnityEngine.Vector3
        LocalPosition: function
    
        localScale: CS.UnityEngine.Vector3
        LocalScale: function
    
        offsetMax: CS.UnityEngine.Vector2
        OffsetMax: function
    
        offsetMin: CS.UnityEngine.Vector2
        OffsetMin: function
    
        activeSelf: boolean
        ActiveSelf: function
    
        overrideSorting: boolean
        OverrideSorting: function
    
        sortingOrder: number
        SortingOrder: function
    
        alpha: number
        Alpha: function

        Set: function
    end
    
    record set
        parent: TransformExtType
        Parent: function
    
        localRotation: CS.UnityEngine.Quaternion
        LocalRotation: function
    
        localPosition: CS.UnityEngine.Vector3
        LocalPosition: function
        
        localScale: CS.UnityEngine.Vector3
        LocalScale: function
    
        offsetMax: CS.UnityEngine.Vector2
        OffsetMax: function
    
        offsetMin: CS.UnityEngine.Vector2
        OffsetMin: function
    
        activeSelf: boolean
        ActiveSelf: function
    
        overrideSorting: boolean
        OverrideSorting: function
    
        sortingOrder: number
        SortingOrder: function
    
        alpha: number
        Alpha: function

        Set: function
    end

    parent: TransformExtType
    Parent: TransformExtType

    localRotation: CS.UnityEngine.Quaternion
    localPosition: CS.UnityEngine.Vector3
    localScale: CS.UnityEngine.Vector3
    offsetMax: CS.UnityEngine.Vector2
    offsetMin: CS.UnityEngine.Vector2

    activeSelf: boolean
    ActiveSelf: boolean

    overrideSorting: boolean
    sortingOrder: number
    SortingOrder: number
    alpha: number

    window: WindowFactoryType
    messenger: MessengerType

    bindCanvas: BindCanvasType
    bindGameObject: BindGameObjectType
    bindCanvasGroup: BindCanvasGroupType
    bindRectTransform: BindRectTransformType

    new: function(...: any): ViewModelBaseType
    ctor: function
    dtor: function

    SetWithBroadCast: function(self: ViewModelBaseType, SetType, any, string, boolean)
    Broadcast: function(self: ViewModelBaseType, any, any, string)
    Set: function(self: ViewModelBaseType, SetType, any, string, boolean)
end

global record WindowBaseType
    record get
        viewStack: {ViewBaseType}
        Current: function
    end

    Current: ViewBaseType

    subView: {ViewBaseType}
    viewStack: {ViewBaseType}
    windowType: number

    ctor: function
    dtor: function

    OnCreate: function(WindowBaseType)

    OnEnable: function(WindowBaseType)
    OnDisable: function(WindowBaseType)

    Show: function(WindowBaseType, boolean)
    OnShow: function(WindowBaseType)
    
    Hide: function(WindowBaseType, boolean)
    OnHide: function(WindowBaseType)

    Dismiss: function(WindowBaseType, boolean)
    OnDismiss: function(WindowBaseType)

    AddSubView: function(self: WindowBaseType, ViewBaseType)
    PushViewStack: function(self: WindowBaseType, ViewBaseType)
    PopViewStack: function(self: WindowBaseType): ViewBaseType
end

global record WindowFactoryType

    name: string
    windowType: number
    view: ViewBaseType
    viewModel: ViewModelBaseType

    new: function(...: any): WindowFactoryType
    ctor: function
    dtor: function
end

global record WindowManagerType
    record get
        windowStack: {WindowFactoryType}
        Current: function
    end

    record TransitionHideType
        animationDisabled: boolean
        AnimationDisabled: boolean
        
        window: WindowFactoryType
        dismiss: boolean
        manager: WindowManagerType
        
        new: function(...: any): TransitionHideType
        ctor: function
        dtor: function
    
        DoTransition: function(self: TransitionHideType)
    end

    record TransitionShowType
        animationDisabled: boolean
        AnimationDisabled: boolean
    
        overlayPolicy: function
        OverlayPolicy: function
    
        window: WindowFactoryType
        dismiss: boolean
        manager: WindowManagerType
        
        new: function(...: any): TransitionShowType
        ctor: function
        dtor: function
    
        Overlay: function(self: TransitionShowType, ViewBaseType): number
        DoTransition: function(self: TransitionShowType)
    end

    current: WindowFactoryType
    Current: WindowFactoryType

    layers: {LayerType}
    windows: {string: WindowFactoryType}
    windowStack: {WindowFactoryType}
    hideWindows: {WindowFactoryType}

    uiRoot: TransformExtType

    Instance: WindowManagerType

    __singleton: function(self: WindowManagerType): WindowManagerType

    new: function(...: any): WindowManagerType
    ctor: function
    dtor: function

    OnEnable: function(self: WindowManagerType)
    OnDisable: function(self: WindowManagerType)

    OpenWindow: function(self: WindowManagerType, name: string, parent: TransformExtType, ...: any): WindowFactoryType
    CloseWindow: function(self: WindowManagerType, name: string)

    Show: function(self: WindowManagerType, WindowFactoryType): TransitionType
    Hide: function(self: WindowManagerType, WindowFactoryType): TransitionType
    Dismiss: function(self: WindowManagerType, WindowFactoryType): TransitionType
    
    PushWindowStack: function(self: WindowManagerType, WindowFactoryType): WindowFactoryType
    PopWindowStack: function(self: WindowManagerType): WindowFactoryType
    ClearWindowStack: function(self: WindowManagerType, WindowFactoryType)
    GetWindow: function(self: WindowManagerType, string): WindowFactoryType
    
    InitLayers: function(self: WindowManagerType)
    GetLayer: function(self: WindowManagerType, number): LayerType
end

global record WindowStateEventArgsType
    record get
        window: ViewBaseType
        Window: function
    
        state: number
        State: function
    
        oldState: number
        OldState: function
    end

    window: ViewBaseType
    Window: ViewBaseType

    state: number
    State: number

    oldState: number
    OldState: number
    
    new: function(...: any): WindowStateEventArgsType
    ctor: function
    dtor: function
end

global record ViewBaseType
    record get
        messenger: MessengerType
        Messenger: function
        
        activatedChanged: {EventHandlerType}
        ActivatedChanged: function
    
        visibilityChanged: {EventHandlerType}
        VisibilityChanged: function
    
        onDismissed: {EventHandlerType}
        OnDismissed: function
    
        stateChanged: {EventHandlerType}
        StateChanged: function
    
        created: boolean
        Created: function
    
        dismissed: boolean
        Dismissed: function
    
        activated: boolean
        Activated: function
    
        state: number
        State: function
    
        windowType: number
        WindowType: function
    
        activationAnimation: UIAnimationType
        ActivationAnimation: function

        passivationAnimation: UIAnimationType
        PassivationAnimation: function

        enterAnimation: UIAnimationType
        EnterAnimation: function
    
        exitAnimation: UIAnimationType
        ExitAnimation: function
    
        Name: function
    
        parent: TransformExtType
        Parent: function
    
        gameObject: GameObjectExtType
        Owner: function
    
        transform: TransformExtType
        Transform: function
    
        Visibility: function

        Mutex: boolean

        viewModel: ViewModelBaseType
    end
    
    record set
        activatedChanged: {EventHandlerType}
        ActivatedChanged: function
    
        visibilityChanged: {EventHandlerType}
        VisibilityChanged: function
    
        onDismissed: {EventHandlerType}
        OnDismissed: function
    
        stateChanged: {EventHandlerType}
        StateChanged: function
    
        activated: boolean
        Activated: function
    
        state: number
        State: function
    
        activationAnimation: UIAnimationType
        ActivationAnimation: function

        passivationAnimation: UIAnimationType
        PassivationAnimation: function

        enterAnimation: UIAnimationType
        EnterAnimation: function
    
        exitAnimation: UIAnimationType
        ExitAnimation: function
    
        Visibility: function

        viewModel: ViewModelBaseType

        RaiseActivatedChanged: function(set)
        RaiseStateChanged: function(set, number, number)
    end

    Name: string
    Visibility: boolean

    activationAnimation: UIAnimationType
    ActivationAnimation: UIAnimationType

    passivationAnimation: UIAnimationType
    PassivationAnimation: UIAnimationType

    bundle: any

    window: WindowFactoryType

    messenger: MessengerType

    gameObject: GameObjectExtType
    transform: TransformExtType
    bindTransform: BindRectTransformType

    dismissTransition: TransitionType
    DismissTransition: TransitionType
    enterAnimation: UIAnimationType
    EnterAnimation: UIAnimationType
    exitAnimation: UIAnimationType
    ExitAnimation: UIAnimationType

    mutex: boolean
    Mutex: boolean

    created: boolean
    dismissed: boolean
    activated: boolean
    Activated: boolean
    
    stateBroadcast: boolean
    prefabPath: string
    windowType: number
    WindowType: number
    viewType: number
    ViewType: number
    state: number
    State: number
    
    activatedChanged: {EventHandlerType}
    ActivatedChanged: EventHandlerType
    visibilityChanged: {EventHandlerType}
    VisibilityChanged: EventHandlerType
    onDismissed: {EventHandlerType}
    OnDismissed: EventHandlerType
    stateChanged: {EventHandlerType}
    StateChanged: OptHandlerType

    views: {ViewBaseType}
    
    viewModel: ViewModelBaseType
    bindingExt: BindingExtensionType
    bindingSet: BindingSetBaseType

    name: string
    parent: TransformExtType
    variables: MonoVariableArrayExtType
    components: {ComponentExtType}
    gameObjects: {GameObjectExtType}

    new: function(...: any): ViewBaseType
    ctor: function
    delete: function
    dtor: function

    OnEnable: function(self: ViewBaseType)
    OnDisable: function(self: ViewBaseType)
    RaiseActivatedChanged: function(self: ViewBaseType)
    RaiseVisibilityChanged: function(self: ViewBaseType)
    RaiseOnDismissed: function(self: ViewBaseType)
    RaiseStateChanged: function(self: ViewBaseType, number, number)
    Activate: function(self: ViewBaseType, boolean): AsyncResultExtType
    Passivate: function(self: ViewBaseType, boolean): AsyncResultExtType
    Create: function(self: ViewBaseType)
    OnCreate: function(self: ViewBaseType)
    
    Show: function(self: ViewBaseType, boolean)
    DoShow: function(self: ViewBaseType, boolean): AsyncResultExtType
    OnShow: function(self: ViewBaseType)
    
    Hide: function(self: ViewBaseType, boolean)
    DoHide: function(self: ViewBaseType, boolean): AsyncResultExtType
    OnHide: function(self: ViewBaseType)
    
    Dismiss: function(self: ViewBaseType, boolean)
    DoDismiss: function(self: ViewBaseType)
    OnDismiss: function(self: ViewBaseType)

    GetComponentWithName: function(self: ViewBaseType, ComponentExtType, string): ComponentExtType
    GetGameObjectWithName: function(self: ViewBaseType, GameObjectExtType, string): GameObjectExtType
    GetComponent: function(self: ViewBaseType, ComponentExtType): ComponentExtType
    AddComponent: function(self: ViewBaseType, ComponentExtType): ComponentExtType
end

-- Bind UnityEngine Object
----------------------------------------------------------------------------------------------
global record BindGameObjectType
    record get
        activeSelf: boolean
        ActiveSelf: function    
    end 
    
    record set
        activeSelf: boolean
        ActiveSelf: function    

        Set: function(self: set, SetType, any, string, boolean)
    end 

    activeSelf: boolean
    ActiveSelf: boolean

    transform: BindTransformType
    Transform: BindTransformType

    gameObjectExt: GameObjectExtType

    name: string

    new: function(...: any): BindGameObjectType
    ctor: function
    dtor: function

    BindWithName: function(self: BindGameObjectType, ViewBaseType, {number})
end

global record BindTextType
    record get
        text: string    
        Text: function    

        color: CS.UnityEngine.Color    
        Color: function    
    
        gameObject: BindGameObjectType
        GameObject: function
    end 
    
    record set
        text: string    
        Text: function   
        
        color: CS.UnityEngine.Color    
        Color: function   
    
        Set: function(self: set, SetType, any, string, boolean)
    end 

    text: string
    Text: string

    color: CS.UnityEngine.Color 
    Color: CS.UnityEngine.Color 

    gameObject: BindGameObjectType
    GameObject: BindGameObjectType

    componentExt: TextExtType

    name: string

    new: function(...: any): BindTextType
    ctor: function
    dtor: function

    BindWithName: function(self: BindTextType, ViewBaseType, {number})
end

global record BindButtonType
    record get
        onClick: function    
        OnClick: function    

        simpleCommand: SimpleCommandType    
        SimpleCommand: function    
    
        gameObject: BindGameObjectType
        GameObject: function
    end 
    
    record set
        onClick: function    
        OnClick: function   

        simpleCommand: SimpleCommandType    
        SimpleCommand: function   
        
        Set: function(self: set, SetType, any, string, boolean)
    end 

    onClick: function
    OnClick: function

    transform: BindTransformType
    Transform: BindTransformType

    gameObject: BindGameObjectType
    GameObject: BindGameObjectType

    componentExt: ButtonExtType

    simpleCommand: SimpleCommandType    
    SimpleCommand: SimpleCommandType

    name: string

    new: function(...: any): BindButtonType
    ctor: function
    dtor: function

    BindWithName: function(self: BindButtonType, ViewBaseType, {number})
end

global record BindCanvasType
    record get
        overrideSorting: boolean
        OverrideSorting: function

        sortingOrder: number
        SortingOrder: function
    end 
    
    record set
        overrideSorting: boolean
        OverrideSorting: function

        sortingOrder: number
        SortingOrder: function

        Set: function(self: set, SetType, any, string, boolean)
    end 
    
    overrideSorting: boolean
    OverrideSorting: boolean

    sortingOrder: number
    SortingOrder: number

    gameObject: BindGameObjectType
    GameObject: BindGameObjectType

    componentExt: CanvasExtType

    name: string

    new: function(...: any): BindCanvasType
    ctor: function
    dtor: function
    
    BindWithName: function(self: BindCanvasType, ViewBaseType, {number})
end

global record BindCanvasGroupType
    record get
        alpha: number
        Alpha: function
    end 
    
    record set
        alpha: number
        Alpha: function

        Set: function(self: set, SetType, any, string, boolean)
    end 
    
    alpha: number
    Alpha: number

    gameObject: BindGameObjectType
    GameObject: BindGameObjectType

    componentExt: CanvasGroupExtType

    name: string

    new: function(...: any): BindCanvasGroupType
    ctor: function
    dtor: function
    
    BindWithName: function(self: BindCanvasGroupType, ViewBaseType, {number})
end

global record BindRectTransformType
    record get
        offsetMax: CS.UnityEngine.Vector2
        OffsetMax: function
    
        offsetMin: CS.UnityEngine.Vector2
        OffsetMin: function
    end

    record set
        offsetMax: CS.UnityEngine.Vector2
        OffsetMax: function
    
        offsetMin: CS.UnityEngine.Vector2
        OffsetMin: function

        Set: function(self: set, SetType, any, string, boolean)
    end

    offsetMax: CS.UnityEngine.Vector2
    OffsetMax: CS.UnityEngine.Vector2
    
    offsetMin: CS.UnityEngine.Vector2
    OffsetMin: CS.UnityEngine.Vector2

    componentExt: RectTransformExtType

    name: string

    new: function(...: any): BindRectTransformType
    ctor: function
    dtor: function
    
    BindWithName: function(self: BindRectTransformType, ViewBaseType, {number})
end

global record BindTransformType
    record get
        parent: TransformExtType
        Parent: function
    
        localRotation: CS.UnityEngine.Quaternion
        LocalRotation: function
    
        localPosition: CS.UnityEngine.Vector3
        LocalPosition: function
    
        localScale: CS.UnityEngine.Vector3
        LocalScale: function
    end 
    
    record set
        parent: TransformExtType
        Parent: function
    
        localRotation: CS.UnityEngine.Quaternion
        LocalRotation: function
    
        localPosition: CS.UnityEngine.Vector3
        LocalPosition: function
    
        localScale: CS.UnityEngine.Vector3
        LocalScale: function

        Set: function(self: set, SetType, any, string, boolean)
    end 
    
    parent: TransformExtType
    Parent: TransformExtType

    localRotation: CS.UnityEngine.Quaternion
    localPosition: CS.UnityEngine.Vector3
    localScale: CS.UnityEngine.Vector3

    componentExt: TransformExtType

    name: string

    new: function(...: any): BindTransformType
    ctor: function
    dtor: function

    BindWithName: function(self: BindTransformType, ViewBaseType, {number})
end

global record BindComponentType
    record get
        gameObject: BindGameObjectType
        GameObject: function
    end 

    transform: BindTransformType
    Transform: BindTransformType

    gameObject: BindGameObjectType
    GameObject: BindGameObjectType

    componentExt: ComponentExtType

    name: string

    ctor: function
    dtor: function

    BindWithName: function(self: BindComponentType, ViewBaseType, {number})
end

global record BindInputFieldType
    record get
        text: string
        Text: function

        onValueChanged: function
        OnValueChanged: function

        simpleCommand: SimpleCommandType
        SimpleCommand: function
    end

    record set
        text: string
        Text: function

        onValueChanged: function
        OnValueChanged: function

        simpleCommand: SimpleCommandType
        SimpleCommand: function

        Set: function(self: set, SetType, any, string, boolean)
    end

    onValueChanged: function
    OnValueChanged: function

    simpleCommand: SimpleCommandType    
    SimpleCommand: SimpleCommandType

    text: string
    Text: string

    gameObject: BindGameObjectType
    GameObject: BindGameObjectType

    componentExt: InputFieldExtType

    name: string

    new: function(...: any): BindInputFieldType
    ctor: function
    dtor: function

    BindWithName: function(self: BindInputFieldType, ViewBaseType, {number})
end

global record BindToggleType
    record get
        onValueChanged: function
        OnValueChanged: function

        simpleCommand: SimpleCommandType
        SimpleCommand: function
    end

    record set
        onValueChanged: function
        OnValueChanged: function

        simpleCommand: SimpleCommandType
        SimpleCommand: function

        Set: function(self: set, SetType, any, string, boolean)
    end

    onValueChanged: function
    OnValueChanged: function

    simpleCommand: SimpleCommandType    
    SimpleCommand: SimpleCommandType

    gameObject: BindGameObjectType
    GameObject: BindGameObjectType

    componentExt: ToggleExtType

    name: string

    new: function(...: any): BindToggleType
    ctor: function
    dtor: function

    BindWithName: function(self: BindToggleType, ViewBaseType, {number})
end

global record BindImageType
    record get
        sprite: CS.UnityEngine.Sprite
        Sprite: function

        fillAmount: number
        FillAmount: function
    end

    record set
        sprite: CS.UnityEngine.Sprite
        Sprite: function

        fillAmount: number
        FillAmount: function

        Set: function(self: set, SetType, any, string, boolean)
    end

    sprite: CS.UnityEngine.Sprite
    Sprite: CS.UnityEngine.Sprite

    fillAmount: number
    FillAmount: number

    gameObject: BindGameObjectType
    GameObject: BindGameObjectType

    componentExt: ImageExtType

    name: string

    new: function(...: any): BindImageType
    ctor: function
    dtor: function

    BindWithName: function(self: BindImageType, ViewBaseType, {number})
end

global record WindowConfigTable
    Name: string
    WindowType: number
    ViewConfig: ViewConfigTable
    ViewModel: ViewModelBaseType
end

global record WindowConfigType

    record get
        windowConfig: {string: WindowConfigTable}
        WindowConfig: function

        viewConfig: {string: ViewConfigTable}
        ViewConfig: function
    end

    windowConfig: {string: WindowConfigTable}
    WindowConfig: {string: WindowConfigTable}
    viewConfig: {string: ViewConfigTable}
    ViewConfig: {string: ViewConfigTable}
    
    Instance: WindowConfigType

    __singleton: function(self: WindowConfigType): WindowConfigType

    new: function(...: any): WindowConfigType
    ctor: function
    dtor: function

    InitWindowConfig: function(self: WindowConfigType)
    InitViewConfig: function(self: WindowConfigType)
end

global record ViewConfigTable
    Name: string
    PrefabPath :string
    ViewType: number
    State: number
    View: ViewBaseType
    SubView: {ViewConfigTable}
    SubPanel: {ViewConfigTable}
end
------------------------------------------------------------------------------

-- UnityObject Extent
------------------------------------------------------------------------------
global record TransformExtType
    record get
        localRotation: function
        localPosition: function
        localScale: function
        parent: function

        handler: CS.UnityEngine.Component
    end

    record set
        localRotation: function
        localPosition: function
        localScale: function
        parent: function

        handler: CS.UnityEngine.Component
    end


    handler: CS.UnityEngine.Component

    CSObject: CS.UnityEngine.Component
    LocalRotation: string
    LocalPosition: string
    LocalScale: string
    Parent: string

    parent: TransformExtType

    new: function(...: any): TransformExtType
    ctor: function
    dtor: function

    SetParent: function(self: TransformExtType, TransformExtType)
end

global record GameObjectExtType
    record get
        activeSelf: function

        name: function

        handler: CS.UnityEngine.GameObject
    end

    handler: CS.UnityEngine.GameObject

    CSObject: CS.UnityEngine.GameObject
    
    ActiveSelf: string
    
    transform: TransformExtType
    Transform: TransformExtType

    activeSelf: boolean
    name: string

    new: function(...: any): GameObjectExtType
    ctor: function
    dtor: function

    SetActive: function(self: GameObjectExtType, boolean)
    GetComponent: function(self: GameObjectExtType, any): CS.UnityEngine.Component
    AddComponent: function(self: GameObjectExtType, any): CS.UnityEngine.Component
end

global record ComponentExtType
    handler: CS.UnityEngine.Component

    CSObject: CS.UnityEngine.Component

    transform: TransformExtType
    gameObject: GameObjectExtType

    new: function(...: any): ComponentExtType
    ctor: function
    dtor: function
    delete: function
end

global record GraphicRaycasterExtType
    handler: CS.UnityEngine.Component

    CSObject: CS.UnityEngine.Component

    gameObject: GameObjectExtType
    GameObject: GameObjectExtType

    ctor: function
    dtor: function
end

global record RectTransformExtType
    record get
        offsetMax: function
        offsetMin: function

        handler: CS.UnityEngine.Component
    end

    record set
        offsetMax: function
        offsetMin: function

        handler: CS.UnityEngine.Component
    end

    handler: CS.UnityEngine.Component

    CSObject: CS.UnityEngine.Component
    OffsetMax: string
    OffsetMin: string

    offsetMax: CS.UnityEngine.Vector2
    offsetMin: CS.UnityEngine.Vector2

    new: function(...: any): RectTransformExtType
    ctor: function
    dtor: function
end

global record CanvasGroupExtType
    handler: CS.UnityEngine.Component

    CSObject: CS.UnityEngine.Component
    Alpha: string

    gameObject: GameObjectExtType
    GameObject: GameObjectExtType

    ctor: function
    dtor: function
end

global record CanvasExtType
    handler: CS.UnityEngine.Component

    CSObject: CS.UnityEngine.Component
    OverrideSorting: string
    SortingOrder: string

    gameObject: GameObjectExtType
    GameObject: GameObjectExtType

    ctor: function
    dtor: function
end

global record InputFieldExtType
    record get
        text: function
        onEndEdit: function
        onValueChanged: function

        gameObject: GameObjectExtType
        GameObject: function

        handler: CS.UnityEngine.Component
    end

    record set
        text: function
        onEndEdit: function
        onValueChanged: function

        handler: CS.UnityEngine.Component
    end
    
    gameObject: GameObjectExtType
    GameObject: GameObjectExtType

    Text: string
    OnEndEdit: string
    OnValueChanged: string

    handler: CS.UnityEngine.Component

    CSObject: CS.UnityEngine.Component

    ctor: function
    dtor: function
end

global record TextExtType
    record get
        text: function
        color: function

        gameObject: GameObjectExtType
        GameObject: function

        handler: CS.UnityEngine.Component
    end

    record set
        text: function
        color: function

        handler: CS.UnityEngine.Component
    end
    
    Text: string
    Color: string

    gameObject: GameObjectExtType
    GameObject: GameObjectExtType

    handler: CS.UnityEngine.Component

    CSObject: CS.UnityEngine.Component

    ctor: function
    dtor: function
end

global record ButtonExtType
    record get
        onClick: function

        gameObject: GameObjectExtType
        GameObject: function

        handler: CS.UnityEngine.Component
    end

    record set
        onClick: function

        handler: CS.UnityEngine.Component
    end

    handler: CS.UnityEngine.Component

    gameObject: GameObjectExtType
    GameObject: GameObjectExtType

    CSObject: CS.UnityEngine.Component
    OnClick: string

    ctor: function
    dtor: function
end

global record ToggleExtType
    record get
        onValueChanged: function

        gameObject: GameObjectExtType
        GameObject: function

        handler: CS.UnityEngine.Component
    end

    record set
        onValueChanged: function

        handler: CS.UnityEngine.Component
    end

    handler: CS.UnityEngine.Component

    gameObject: GameObjectExtType
    GameObject: GameObjectExtType

    CSObject: CS.UnityEngine.Component
    OnValueChanged: string

    ctor: function
    dtor: function
end

global record ImageExtType
    record get
        sprite: function
        fillAmount: function

        gameObject: GameObjectExtType
        GameObject: function

        handler: CS.UnityEngine.Component
    end

    record set
        sprite: function
        fillAmount: function

        handler: CS.UnityEngine.Component
    end

    handler: CS.UnityEngine.Component

    gameObject: GameObjectExtType
    GameObject: GameObjectExtType

    CSObject: CS.UnityEngine.Component
    Sprite: string
    FillAmount: string

    ctor: function
    dtor: function
end

global record ExecutorsExtType
    csharp: CS.Execution.Executors

    Instance: ExecutorsExtType

    __singleton: function(self: ExecutorsExtType): ExecutorsExtType
    
    new: function(...: any): ExecutorsExtType
    ctor: function
    dtor: function

    WaitWhile: function(self: ExecutorsExtType, function): CS.System.Object
    RunOnMainThread: function(self: ExecutorsExtType, function)
    RunOnCoroutine: function(self: ExecutorsExtType, function): CS.Asynchronous.AsyncResult
    RunOnCoroutineNoReturn: function(self: ExecutorsExtType, function)
end

global record CoroutineExtType
    GetEnumerator: function(function): function
    Yield: function(CS.System.Object)
    Wait: function(number)
end

global record AsyncResultExtType
    record get
        csharp: CS.Asynchronous.AsyncResult
    
        IsDone: function
        Result: function
        IsCancellationRequested: function
        IsCancelled: function
    end

    csharp: CS.Asynchronous.AsyncResult

    new: function(...: any): AsyncResultExtType
    ctor: function
    dtor: function

    SetException: function(self: AsyncResultExtType, string)
    SetResult: function(self: AsyncResultExtType, CS.System.Object)
    SetCancelled: function(self: AsyncResultExtType)
    Cancel: function(self: AsyncResultExtType): boolean
    Callbackable: function(self: AsyncResultExtType): CS.System.Object
    Synchronized: function(self: AsyncResultExtType): CS.System.Object
    WaitForDone: function(self: AsyncResultExtType): CS.System.Object
end

global record MonoVariableArrayExtType
    handler: CS.UnityEngine.Component

    CSObject: CS.UnityEngine.Component

    gameObject: GameObjectExtType
    GameObject: GameObjectExtType

    ctor: function
    dtor: function

    Get: function(self: MonoVariableArrayExtType, string): CS.UnityEngine.Component
end
------------------------------------------------------------------------------