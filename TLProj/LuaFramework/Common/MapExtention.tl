local MapExtention = {}

function MapExtention.Find(t: {any: any}, callback: function): any
   for k, v in pairs(t) do
      if callback and callback(k, v) then
         return v
      end
   end
end

function MapExtention.Foreach(t: {any: any}, callback: function)
   for k, v in pairs(t) do
      if callback then
         callback(k, v)
      end
   end
end

function MapExtention.Exists(t: {any: any}, obj: function): boolean
   for _, v in pairs(t) do
      if obj == v then
         return true
      end
   end
end

function MapExtention.RemoveObj(t: {any: any}, obj: any): boolean
   for k, v in pairs(t) do
      if obj == v then
         t[k] = nil
         return true
      end
   end
end

function MapExtention.Remove(t: {any: any}, callback: function): boolean
   for k, v in pairs(t) do
      if callback and callback(k, v) then
         t[k] = nil
         return true
      end
   end
end

function MapExtention.ContainsKey(t: {any: any}, key: any): boolean
   for k, _ in pairs(t) do
      if k == key then
         return true
      end
   end
end

function MapExtention.ContainsValue(t: {any: any}, value: any): boolean
   for _, v in pairs(t) do
      if v == value then
         return true
      end
   end
end

function MapExtention.IsNilOrEmpty(t: {any: any}): boolean
   return not t or not next(t)
end

return MapExtention
