-- Add tween methods later

local White = Color3.fromRGB(255, 255, 255); -- just so white stays white

local RunService = game:GetService("RunService");
local CLAMP, INSERT, REMOVE = math.clamp, table.insert, table.remove;
local SPAWN, DummyFunc = task.spawn, function() end;
local CurrentTweens = {}; -- table.create(10)

SPAWN(function()
    while RunService.Heartbeat:Wait() do -- inf loop
        if #CurrentTweens == 0 then
            continue;
        end;
        local CurrentTime = tick();

        for i,v in pairs(CurrentTweens) do
            local Elapsed = CurrentTime - v.StartTime;
            v.CurrentValue = v.StartValue + (v.EndValue - v.StartValue) * CLAMP(Elapsed / v.Duration, 0, 1);

            SPAWN(function() -- eh
                v.OnChange(v.CurrentValue);
            end);
        
            if v.CurrentValue == v.EndValue then
                REMOVE(CurrentTweens, i);
                v.OnEnd();
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
        CurrentValue = info.StartValue or 0,
        EndValue = info.EndValue or 1,
    });
end;

if getgenv and typeof(getgenv()) == "table" then
    getgenv().Tween = Tween;
end;

return Tween; -- Doesn't matter, since I am adding it to the global env (getgenv) anyway

-- Example
--[[
local Tween = loadstring(game:HttpGet("https://raw.githubusercontent.com/Asgerpasker/Public/main/TweenLibrary.lua"))(); -- Gets added to global exploit env anyway, probably doesn't matter much
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
