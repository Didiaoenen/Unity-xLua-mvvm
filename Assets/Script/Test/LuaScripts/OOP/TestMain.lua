-- local Class = require("OOP.Class")

-- local MyClass = Class("MyClass")

-- local MyClass2 = Class("MyClass2")

-- function MyClass2:ctor()
--     self.name = "MyClass2"
-- end

-- MyClass.test = "test"

-- MyClass.test2 = {"test2"}

-- function MyClass:ctor()

--     self.name = "MyClass"

--     print("MyClass:ctor")
-- end

-- function MyClass:Print()
--     print(self.name)
-- end

-- function MyClass.get:Name()
--     return self.name
-- end

-- function MyClass.set:Name(pName)
--     self.name = pName
-- end

-- local myClass = MyClass.new()

-- print(myClass.Name)
-- myClass.Name = "MyClassNew"
-- print(myClass.Name)

-- print(myClass.is(MyClass))
-- print(myClass.is(MyClass2))

-- myClass:Print()

-- local childClass = Class("ChildClass", MyClass)

-- function childClass:ctor()
--     self.name = "ChildClass"
-- end

-- childClass:Print()

-- print(childClass.test)
-- print(childClass.test2[1])

-- local myClass2 = MyClass2.new()

-- MyClass.test3 = MyClass2

local Class = require("OOP.Class")

local Class = class

local function run_test(name, func)
    local ok, err = pcall(func)
    if ok then
        print("[PASS] " .. name)
    else
        print("[FAIL] " .. name .. "\n      Error: " .. tostring(err))
    end
end

print("=== Enhanced OOP Unit Tests (Strict Mode) ===")

-- 1. 基础实例化与参数传递
run_test("Ctor Arguments & Field Access", function()
    local Soldier = Class("Soldier")
    function Soldier:ctor(id, level) 
        self.id = id
        self.level = level
    end
    
    local s = Soldier.new(1001, 5)
    assert(s.id == 1001, "Field 'id' mismatch")
    assert(s.level == 5, "Field 'level' mismatch")
    assert(s.is(Soldier), "is-A check failed")
end)

-- 2. 深度继承与方法覆盖
run_test("Deep Inheritance & Override", function()
    local Weapon = Class("Weapon")
    function Weapon:ctor() self.type = "Generic" end
    function Weapon:GetDamage() return 10 end

    local Sword = Class("Sword", Weapon)
    function Sword:ctor() Weapon.ctor(self); self.type = "Sword" end
    function Sword:GetDamage() return 50 end -- 覆盖父类

    local Excalibur = Class("Excalibur", Sword)
    function Excalibur:ctor() Sword.ctor(self) end
    -- 不覆盖 GetDamage，应继承 Sword 的

    local ex = Excalibur.new()
    assert(ex.type == "Sword", "Field inheritance failed")
    assert(ex:GetDamage() == 50, "Method override failed in deep chain")
    assert(ex.is(Weapon), "Grandparent check failed")
end)

-- 3. 静态与实例 Getter/Setter 分离
run_test("Advanced Property Routing", function()
    local Hero = Class("Hero")
    local _globalCount = 0
    function Hero:ctor(name) self._name = name; self._exp = 0 end

    -- 静态 Getter/Setter
    Hero.get.totalCount = function() return _globalCount end
    Hero.set.totalCount = function(cls, v) _globalCount = v end

    -- 实例 Getter/Setter
    Hero.get.level = function(self) return math.floor(self._exp / 100) end

    Hero.totalCount = 10
    local h = Hero.new("Arthur")
    h._exp = 250
    h.totalCount = 20

    assert(Hero.totalCount == 10, "Static property failed")
    assert(h.level == 2, "Instance getter failed")
end)

-- 4. 析构函数调用链
run_test("Destructor Cascade", function()
    local log = ""
    local Base = Class("Base")
    function Base:ctor() end
    function Base:dtor() log = log .. "Base" end

    local Sub = Class("Sub", Base)
    function Sub:ctor() Base.ctor(self) end
    function Sub:dtor() log = log .. "Sub" end

    local s = Sub.new()
    s:delete()
    -- CascadeDelete 是递归调用的
    assert(log == "SubBase", "Destructor chain order incorrect: " .. log)
end)

-- 5. 单例模式完整测试
run_test("Singleton Lifecycle", function()
    local DB = Class("DB")
    local initCount = 0
    function DB:ctor() initCount = initCount + 1 end
    
    function DB.__singleton() return DB.new() end
    
    local db1 = DB.Instance
    local db2 = DB.Instance
    assert(db1 == db2, "Singleton should return same instance")
    assert(initCount == 1, "Singleton ctor called multiple times")
    
    DB.Instance = nil -- 触发销毁逻辑
    local db3 = DB.Instance
    assert(db3 ~= db1, "Singleton was not recreated after destruction")
    assert(initCount == 2, "Ctor should be called again after reset")
end)