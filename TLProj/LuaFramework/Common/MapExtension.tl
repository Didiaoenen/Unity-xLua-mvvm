local MapExtension = {}

function MapExtension.Find(t: {any: any}, callback: function): any
   for k, v in pairs(t) do
      if callback and callback(k, v) then
         return v
      end
   end
end

function MapExtension.Foreach(t: {any: any}, callback: function)
   for k, v in pairs(t) do
      if callback then
         callback(k, v)
      end
   end
end

function MapExtension.Exists(t: {any: any}, obj: function): boolean
   for _, v in pairs(t) do
      if obj == v then
         return true
      end
   end
end

function MapExtension.RemoveObj(t: {any: any}, obj: any): boolean
   for k, v in pairs(t) do
      if obj == v then
         t[k] = nil
         return true
      end
   end
end

function MapExtension.Remove(t: {any: any}, callback: function): boolean
   for k, v in pairs(t) do
      if callback and callback(k, v) then
         t[k] = nil
         return true
      end
   end
end

function MapExtension.ContainsKey(t: {any: any}, key: any): boolean
   for k, _ in pairs(t) do
      if k == key then
         return true
      end
   end
end

function MapExtension.ContainsValue(t: {any: any}, value: any): boolean
   for _, v in pairs(t) do
      if v == value then
         return true
      end
   end
end

function MapExtension.IsNilOrEmpty(t: {any: any}): boolean
   return not t or not next(t)
end

return MapExtension
