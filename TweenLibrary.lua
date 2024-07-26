-- Add tween methods later
-- OnEnd => OnFinished

-- Just in case white should stay white
local White = Color3.fromRGB(255, 255, 255);

local RunService = game:GetService("RunService");
local CLAMP, MIN = math.clamp, math.min;
local INSERT, REMOVE, CLEAR = table.insert, table.remove, table.clear;
local CurrentTweens, DummyFunc = {}, function() end;

function SPAWN(func, ...)
    if func ~= DummyFunc then -- anti gas leak
        task.spawn(func, ...);
    end;
end;

SPAWN(function()
    while RunService.RenderStepped:Wait() do -- fuck it as soon as it renders
        local CurrentTime = tick();

        for i,v in next, CurrentTweens do
            local Elapsed = CurrentTime - v.StartTime;
            v.CurrentValue = v.StartValue + (v.EndValue - v.StartValue) * MIN(Elapsed / v.Duration, 1); --CLAMP(Elapsed / v.Duration, 0, 1);
            SPAWN(v.OnChange, v.CurrentValue);

            if v.CurrentValue == v.EndValue then
                SPAWN(v.OnEnd);
                CLEAR(v); -- this might be retarded but i aint sure how good gc is for cleang up tableswe (i aint reading the manual)
                REMOVE(CurrentTweens, i);
            end;
        end;
    end;
end);

function Tween(info)
    INSERT(CurrentTweens, {
        StartTime = tick(),
        Duration = info.Duration or 1,

        OnChange = info.OnChange or DummyFunc,
        OnEnd = info.OnEnd or DummyFunc,

        StartValue = info.StartValue or 0,
        CurrentValue = info.StartValue or 0, -- maybe dont store in future
        EndValue = info.EndValue or 1,
    });
end;

if typeof(getgenv) == "function" and typeof(getgenv()) == "table" then
    getgenv().Tween = Tween;
end;

return Tween; -- Doesn't really matter, since it's getting added to the global env anyway (getgenv)

--[[
-- Example

local Tween = loadstring(game:HttpGet("https://raw.githubusercontent.com/Asgerpasker/Public/main/TweenLibrary.lua"))(); -- looks nicer
local Baseplate = game.Workspace.Baseplate;

Tween({
    Duration = 5,
    StartValue = 0,
    EndValue = 100,

    OnChange = function(value)
        Baseplate.Transparency = value / 100;
    end,

    OnEnd = function()
        wait(1);
        Baseplate.Transparency = 0;
    end,
});
--]]
