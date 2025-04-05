local Interval = 1 / 60; -- .016

local Tweens = {};
local INSERT, REMOVE = table.insert, table.remove;
local spawn, wait, tick = task.spawn, task.wait, tick;
local MIN = math.min;

local function Tween(info)
	INSERT(Tweens, {
		Start = tick(), Duration = info.Duration,
		From = info.From, Delta = info.To - info.From,
		OnChanged = info.OnChanged, OnFinished = info.OnFinished,
	});
end;

spawn(function()
    while true do
        local CurrentTick = tick();

        for i,v in Tweens do
            local Multiplier = MIN((CurrentTick - v.Start) / v.Duration, 1);
            spawn(v.OnChanged, v.From + v.Delta * Multiplier); -- lerp formula

            if Multiplier == 1 then
                if v.OnFinished then
                    spawn(v.OnFinished);
                end;

		Tweens[i] = nil; -- REMOVE(Tweens, i);
            end;
        end;

	wait(Interval);
    end;
end);
--[[
Tween({
	From = 0,
	To = 5,
	Time = 2,

	OnChanged = function(val)
		print(val);
	end,
});
]]

return Tween;
