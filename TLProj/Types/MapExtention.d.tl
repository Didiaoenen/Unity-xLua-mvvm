local record MapExtention
    Foreach: function({any: any}, function)
    Exists: function({any: any}, function): boolean
    RemoveObj: function({any: any}, any): boolean
    Remove: function({any: any}, function): boolean
    ContainsKey: function({any: any}, any): boolean
    ContainsValue: function({any: any}, any): boolean
    IsNilOrEmpty: function({any: any}): boolean
end

return MapExtention