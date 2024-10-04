-- Add tween methods later (no?)
-- micro optimz

-- Just in case white should stay white
local White = Color3.new(1, 1, 1);

local RunService = game:GetService("RunService");
local CLAMP, MIN = math.clamp, math.min;
local INSERT, REMOVE, CLEAR = table.insert, table.remove, table.clear;
local CurrentTweens, DummyFunc = {}, function() end;
local SPWN = task.spawn; -- cache it cuz

function SPAWN(func, ...)
	if func ~= DummyFunc then -- No need to create another thread if its notingz
		SPWN(func, ...);
	end;
end;

function Tween(info)
    INSERT(CurrentTweens, {
        StartTime = tick(),
        Duration = info.Duration,
        BaseValue = info.StartValue, 
        Delta = info.EndValue - info.StartValue,  

        OnChanged = info.OnChanged or DummyFunc,
        OnFinished = info.OnFinished or DummyFunc,
    });
end;

SPAWN(function()
    while RunService.RenderStepped:Wait() do
        local CurrentTime = tick();

        for i, v in next, CurrentTweens do
            local Multiplier = CLAMP((CurrentTime - v.StartTime) / v.Duration, 0, 1);
            local CurrentValue = v.BaseValue + v.Delta * Multiplier;  

            SPAWN(v.OnChanged, CurrentValue); 

            if Multiplier == 1 then
                SPAWN(v.OnFinished);
                REMOVE(CurrentTweens, i); 
            end;
        end;
    end;
end);


(getgenv and getgenv() or _G).Tween = Tween;
return Tween; -- Doesn't really matter, since it should be added to the global env anyway

--[[
-- Example

local Tween = loadstring(game:HttpGet("https://raw.githubusercontent.com/Asgerpasker/Public/main/TweenLibrary.lua"))(); -- looks nicer
Tween({
	Duration = 1,
	StartValue = 0,
	EndValue = 1,
	
	OnChanged = function(value)
		game.Players.LocalPlayer.Character.UpperTorso.Transparency = value;
	end,
});
--]]
