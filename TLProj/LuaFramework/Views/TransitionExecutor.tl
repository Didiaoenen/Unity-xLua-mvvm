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
        self.taskResult = ExecutorsExt.Instance:RunOnCoroutine(CoroutineExt.GetEnumerator(function ()
            self:DoTask()
        end))
    end
end

function TransitionExecutor:ShutDone()
    if self.taskResult then
        self.taskResult:Cancel()
        self.running = false
        self.taskResult = nil
    end
    self.transitions = nil
end

function TransitionExecutor:DoTask()
    try
    {
        function ()
            self.running = true
            CoroutineExt.Wait(0)
            while #(self.transitions) > 0 do
                local transition = table.remove(self.transitions, 1)
                local result = ExecutorsExt.Instance:RunOnCoroutine(CoroutineExt.GetEnumerator(function ()
                    transition:TransitionTask()
                end))
                CoroutineExt.Yield(result:WaitForDone())
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