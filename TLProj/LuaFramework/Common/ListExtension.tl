local ListExtension = {}

function ListExtension.Foreach(t: {any}, callback: function)
   for i, v in ipairs(t) do
      if callback then
         callback(i, v)
      end
   end
end

function ListExtension.FindIndex(t: {any}, obj: any): number
   for i, v in ipairs(t) do
      if obj == v then
         return i
      end
   end
end

function ListExtension.Exists(t: {any}, obj: any): boolean
   for _, v in ipairs(t) do
      if obj == v then
         return true
      end
   end
end

function ListExtension.Find(t: {any}, callback: function): any
   for i, v in ipairs(t) do
      if callback and callback(i, v) then
         return v
      end
   end
end

function ListExtension.RemoveObj(t: {any}, obj: any): any
   for i, v in ipairs(t) do
      if v == obj then
         return table.remove(t, i)
      end
   end
end

function ListExtension.Remove(t: {any}, callback: function): any
   for i, v in ipairs(t) do
      if callback and callback(i, v) then
         return table.remove(t, i)
      end
   end
end

function ListExtension.ContainsValue(t: {any}, obj: any): boolean
   for _, v in ipairs(t) do
      if v == obj then
         return true
      end
   end
end

return ListExtension
