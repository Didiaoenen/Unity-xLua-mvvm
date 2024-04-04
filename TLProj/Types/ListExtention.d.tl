local record ListExtention
    Foreach: function({any}, function)
    FindIndex: function({any}, any): number
    Exists: function({any}, any): boolean
    Find: function({any}, function): any
    RemoveObj: function({any}, any): any
    Remove: function({any}, function): any
    ContainsValue: function({any}, any): boolean
end

return ListExtention