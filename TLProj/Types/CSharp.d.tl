global record CS

    -- System
    record System
        record Type
            IsAssignableFrom: function(self: Type, Type): boolean
        end
        
        record Object
            GetType: function(self: Object): Type
        end
    end

    -- UnityEngine
    record UnityEngine

        -- Object
        record Object
            name: string
            GetType: function(self: UnityEngine.Object): System.Type
            Instantiate: function(self: UnityEngine.Object): UnityEngine.Object
            Destroy: function(self: UnityEngine.Object)
        end
    
        -- ResourceRequest
        record ResourceRequest
            isDone: boolean
            progress: number
            asset: UnityEngine.Object
        end

        -- Resources
        record Resources
            Load: function(string, any): UnityEngine.Object
            LoadAsync: function(string, any)
        end

        -- WaitForSeconds
        record WaitForSeconds
            metamethod __call: function(self: WaitForSeconds, ...: any): WaitForSeconds
        end
        
        -- Quaternion
        record Quaternion
            identity: Quaternion
        end

        -- Canvas
        record Canvas
        end

        -- Component
        record Component
            transform: UnityEngine.Transform
            gameObject: UnityEngine.GameObject

            GetComponent: function(self: Component, System.Type): Component
            AddComponent: function(self: Component, System.Type): Component
        end
    
        -- Transform
        record Transform
            localRotation: Quaternion
            localPosition: Vector3
            localScale: Vector3
            parent: Transform

            metamethod __call: function(self: Transform): Transform

            SetParent: function(self: Transform, Transform)
        end

        -- GameObject
        record GameObject
            name: string
            transform: Transform
            activeSelf: boolean
        
            metamethod __call: function(self: GameObject): GameObject

            Find: function(string): GameObject
            SetActive: function(self: GameObject, boolean)
            GetComponent: function(self: GameObject, System.Type): Component
            AddComponent: function(self: GameObject, System.Type): Component
        end

        -- CanvasGroup
        record CanvasGroup
        end

        -- RectTransform
        record RectTransform
            offsetMax: Vector2
            offsetMin: Vector2
        end

        -- Vector3
        record Vector3
            zero: Vector3
            one: Vector3
        
            metamethod __call: function(self: Vector3, number, number, number | nil): Vector3
        end
        
        -- Vector2
        record Vector2
            zero: Vector2
        end
        
        -- Color
        record Color
            red: Color
            green: Color
            blue: Color
            white: Color
            black: Color
        end

        -- Events
        record Events
            -- UnityEventBase
            record UnityEventBase

            end

            -- UnityEventBase
            record UnityEvent
                AddListener: function
                RemoveAllListeners: function
            end
        end

        -- Sprite
        record Sprite

        end

        -- UI
        record UI
            -- Text
            record Text
                text: string
                color: UnityEngine.Color
                gameObject: UnityEngine.GameObject
            end

            -- Button
            record Button
                onClick: function
            end

            -- InputField
            record InputField
                record SubmitEvent
                end
                record OnChangeEvent
                end
                text: string
                onEndEdit: SubmitEvent
                onValueChanged: OnChangeEvent
            end

            -- GraphicRaycaster
            record GraphicRaycaster

            end

            -- Toggle
            record Toggle
                record ToggleEvent
                end
                onValueChanged: ToggleEvent
            end

            -- Image
            record Image
                sprit: UnityEngine.Sprite
                fillAmount: number
            end
        end
    end

    -- 自定义类
    record Simple
        record MonoVariableArray
            record VariableArray
                Get: function(self: VariableArray, string): UnityEngine.Component
            end

            variableArray: VariableArray
        end
    end

    record Execution
        record Executors
            WaitWhile: function(function): System.Object
            RunOnMainThread: function(function)
            RunOnCoroutine: function(function): Asynchronous.AsyncResult
            RunOnCoroutineNoReturn: function(function)
        end
    end

    record Asynchronous
        record AsyncResult
            done: boolean
            result: System.Object
            cancellationRequested: boolean
            cancelled: boolean
            SetResult: function(self: AsyncResult, System.Object)
            SetCancelled: function(self: AsyncResult)
            Cancel: function(self: AsyncResult): boolean
            Callbackable: function(self: AsyncResult): System.Object
            Synchronized: function(self: AsyncResult): System.Object
            WaitForDone: function(self: AsyncResult): System.Object
        
            new: function(...: any): AsyncResult
        
            metamethod __call: function(self: AsyncResult, ...: any): AsyncResult
        end

        record ProgressResult_1_Single
            Result: System.Object
            Progress: number
        
            Callbackable: function(self: ProgressResult_1_Single): System.Object
            UpdateProgress: function(self: ProgressResult_1_Single, number)
            SetResult: function(self: ProgressResult_1_Single, System.Object)
            WaitForDone: function(self: ProgressResult_1_Single): System.Object
        
            metamethod __call: function(self: ProgressResult_1_Single, ...: any): ProgressResult_1_Single
        end

        ["ProgressResult`1[System.Single]"]: ProgressResult_1_Single
    end
end