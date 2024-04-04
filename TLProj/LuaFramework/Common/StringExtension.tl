local StringExtension: StringExtensionType = {}

function StringExtension.Split(s: string, sep: string): {string}
	sep = sep or ""
	local items: {string} = {}
    local pattern = string.format("([^%s]+)", sep)
    string.gsub(s, pattern, function (c: string)
        table.insert(items, c)
    end)  
    return items
end

function StringExtension.IsNilOrEmpty(s: string): boolean
    if nil == s or s == "" then
        return true
    end
    return false
end

return StringExtension