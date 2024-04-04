local WindowEnum: WindowEnumType = {}

WindowEnum.WindowType = {
    NONE            = 1,
    BG              = 2,
    FULL            = 3,
    POPUP           = 4,
    DIALOG          = 5,
    PROGRESS        = 6,
    QUEUED_POPUP    = 7,
}

WindowEnum.ViewState = {
    NONE                        = 1,
    CREATE_BEGIN                = 2,
    CREATE_END                  = 3,
    ENTER_ANIMATION_BEGIN       = 4,
    VISIBLE                     = 5,
    ENTER_ANIMATION_END         = 6,
    ACTIVATION_ANIMATION_BEGIN  = 7,
    ACTIVATED                   = 8,
    ACTIVATION_ANIMATION_END    = 9,
    PASSIVATION_ANIMATION_BEGIN = 10,
    PASSIVATED                  = 11,
    PASSIVATION_ANIMATION_END   = 12,
    EXIT_ANIMATION_BEGIN        = 13,
    INVISIBLE                   = 14,
    EXIT_ANIMATION_END          = 15,
    DISMISS_BEGIN               = 16,
    DISMISS_END                 = 17,
}

WindowEnum.ViewType = {
    VIEW        = 1,
    SUB_AREA    = 2,
    SUB_PANEL   = 3,
}

WindowEnum.ActionType = {
    None        = 1,
    Hide        = 2,
    Dismiss     = 3,
}

return WindowEnum