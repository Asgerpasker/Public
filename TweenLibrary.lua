local wait, spawn = task.wait, task.spawn;
local GetTime = time;

local InitTween = function(tween)
    local From = tween.From;
    local Duration = tween.Duration;
    local OnChanged = tween.OnChanged;

    local Start = GetTime();
    local Delta = tween.To - From;
    while true do
        local Multiplier = (GetTime() - Start) / Duration;

        if Multiplier >= 1 then
            tween.OnFinished();
            break;
        else
            OnChanged(From + Delta * Multiplier);
        end;

        wait(1/60);
    end;
end;

return function(tween)
    -- basically just a wrapper but it looks nicer
    spawn(InitTween, tween);
end;

--[[
Tween({
    From = 0,
    To = -5,
    Duration = 5,

    OnChanged = function(val)
        print("value", val);
    end,

    OnFinished = function()
        print "done";
    end;
});
]]
