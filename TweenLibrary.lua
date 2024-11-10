local Tweens = table.create(50); -- prob doesn't do shit
local INSERT, CLEAR, REMOVE = table.insert, table.clear, table.remove;
local spawn, tick = task.spawn, tick;
local MIN = math.min;

function Tween(info)
	INSERT(Tweens, {
		Start = tick(), Duration = info.Duration,
		From = info.From, To = info.To,
		Delta = info.To - info.From,
		OnChanged = info.OnChanged, OnFinished = info.OnFinished,
	});
end;

game:GetService("RunService").RenderStepped:Connect(function()
	local CurrentTick = tick();

	for i,v in Tweens do
		local Multiplier = MIN((CurrentTick - v.Start) / v.Duration, 1);
		spawn(v.OnChanged, v.From + v.Delta * Multiplier); -- Storing delta prob doesnt do shit? i lied it does

		if Multiplier == 1 then
			if v.OnFinished then
				spawn(v.OnFinished);
			end;

			REMOVE(Tweens, i);
			CLEAR(v);
		end;
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
