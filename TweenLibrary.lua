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

SPWN(function()
	while RunService.RenderStepped:Wait() do
		local CurrentTime = tick();

		for i,v in next, CurrentTweens do
			local Multiplier = MIN((CurrentTime - v.StartTime) / v.Duration, 1);
			SPAWN(v.OnChanged, v.StartValue + v.Delta * Multiplier);

			if Multiplier == 1 then	
				SPAWN(v.OnFinished);
				CLEAR(v); -- This might be retarded but i aint sure how good the gc is for cleang up unused tables (i aint reading the manual)
				REMOVE(CurrentTweens, i);
			end;
		end;
	end;
end);

function Tween(info)
	INSERT(CurrentTweens, {
		StartTime = tick(),
		Duration = info.Duration,
		StartValue = info.StartValue,
		Delta = info.EndValue - info.StartValue,

		OnChanged = info.OnChanged or DummyFunc,
		OnFinished = info.OnFinished or DummyFunc,
	});
end;


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
