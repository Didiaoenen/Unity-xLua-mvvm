local record TableExtention
    Foreach: function({any}, function)
    FindLastIndex: function({any}, function): number
    FindIndex: function({any}, function): number
    Find: function({any}, function): any
    RemoveObj: function({any}, any): any
    Exists: function({any}, function): boolean
    ContainsKey: function({any:any}, any): boolean
    ContainsValue: function({any:any}, any): boolean
    IsNilOrEmpty: function({any:any}): boolean
end

return TableExtention