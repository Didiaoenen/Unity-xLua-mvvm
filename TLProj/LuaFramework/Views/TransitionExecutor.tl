local CoroutineExt = require("LuaFramework.Common.CoroutineExt")
local ExecutorsExt = require("LuaFramework.Execution.ExecutorsExt")

local TransitionExecutor = class("TransitionExecutor") as TransitionExecutorType

function TransitionExecutor.get:IsRunning(): boolean
    return self.running
end

function TransitionExecutor.get:Count(): number
    return #(self.transitions)
end

function TransitionExecutor:ctor()
    self.taskResult = nil
    self.running = false
    self.transitions = {}
end

function TransitionExecutor:Execute(transition: TransitionType)
    table.insert(self.transitions, transition)
    if not self.running then
        self.taskResult = ExecutorsExt.Instance:RunOnCoroutine(CoroutineExt.Instance:GetEnumerator(function ()
            self:DoTask()
        end))
    end
end

function TransitionExecutor:ShutDown()
    if self.taskResult then
        self.taskResult:Cancel()
        self.taskResult = nil
        self.running = false
    end
    self.transitions = {}
end

function TransitionExecutor:DoTask()
    try
    {
        function ()
            self.running = true
            CoroutineExt.Instance:Wait(0)
            while #(self.transitions) > 0 do
                local transition = table.remove(self.transitions, 1)
                local result = ExecutorsExt.Instance:RunOnCoroutine(CoroutineExt.Instance:GetEnumerator(function ()
                    transition:TransitionTask()
                end))
                CoroutineExt.Instance:Yield(result:WaitForDone())
            end
        end,
        finally = function ()
            self.running = false
            self.taskResult = nil
        end
    }
end

function TransitionExecutor:dtor()
    
end

return TransitionExecutor