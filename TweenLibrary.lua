-- Roblox (Krampus)
-- Fully written from scratch by Asgerpasker, literally anyone could make this anyway
-- Could be made better, just wanted it to look a little bit more readable
-- Unsafe code (no checks and error debug), meant to be used on developer side not user side blah blah blah I am just saying stuff

-- Add tween methods (Quad, Linear)

local RunService = game:GetService("RunService");
local CLAMP, INSERT, REMOVE = math.clamp, table.insert, table.remove;
local CurrentTweens = {}; -- table.create(10)

RunService:BindToRenderStep("TweenLoop", 200, function() -- Give least priority since it's just valuez
    if #CurrentTweens > 0 then
        local CurrentTime = tick(); -- best like thuis

        for i,v in pairs(CurrentTweens) do
            -- Cancer math
            local Elapsed = CurrentTime - v.StartTime;
            v.CurrentValue = v.StartValue + (v.EndValue - v.StartValue) * CLAMP(Elapsed / v.Duration, 0, 1); -- Redo maths to be faster and more performance friendly if possible

            task.spawn(function() -- eh
                v.OnChange(v.CurrentValue);
            end);

            if v.CurrentValue == v.EndValue then
                if v.OnEnd then
                    task.spawn(v.OnEnd); -- Don't wanna fire with current value since onchanged fires on last value anyway so people can just use that
                end;

                REMOVE(CurrentTweens, i); -- Remove tween stuff from table since it's done anyway
            end;

            -- TableLength, TableLoop, TweenLoop
        end;
    end;
end);
-- End (YIKES)

function Tween(info)
    local TweenInfo = {
        StartTime = tick(),
        Duration = info.Duration or 1,

        OnChange = info.OnChange, -- func
        OnEnd = info.OnEnd, -- func

        StartValue = info.StartValue or 0,
        CurrentValue = info.StartValue or 0, -- Maybe dont set manually like this and in the loop? prob don't matter
        EndValue = info.EndValue or 1,
    }; INSERT(CurrentTweens, TweenInfo);
end; getgenv().Tween = Tween;

return Tween;

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
