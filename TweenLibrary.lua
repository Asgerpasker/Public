local MaxCache = 50;

local TweenService = game:GetService("TweenService");
local TweenCreate, TWINFO, LINEAR = TweenService.Create, TweenInfo.new, Enum.EasingStyle.Linear;
local CLEAR, REMOVE, INSERT, INST = table.clear, table.remove, table.insert, Instance.new;
local PlaceHolder = function()end;
local wait, next = task.wait, next;

local FolderCache = INST("Folder", game:GetService("CoreGui"));
FolderCache.Name = "TweensCache";

-- Cache for speed
local Cache = {};
for i = 1, MaxCache do
    INSERT(Cache, INST("NumberValue", FolderCache));
end;

-- Clean up cache just cuz (add simple algo in future to adjust maxsize)
task.spawn(function()
    while wait(10) do
        for i,v in next, Cache do
            if i > MaxCache then
                REMOVE(Cache, i);
                v:Destroy();
            end;
        end;
    end;
end);
--

local function Tween(info)
    local End, OnChanged, OnFinished = info.End or PlaceHolder, info.OnChanged, info.OnFinished or PlaceHolder;
    if not Cache[1] then
        INSERT(Cache, INST("NumberValue"));
    end;

    local Number = Cache[1];
    Number.Value = info.From;
    REMOVE(Cache, 1);
    
    local Connection;
    Connection = Number:GetPropertyChangedSignal("Value"):Connect(function()
        if Number.Value == End then
            Connection:Disconnect();
            INSERT(Cache, Number); CLEAR(info);
            OnFinished(End);
        else
            OnChanged(Number.Value);
        end;
    end);

    TweenCreate(TweenService, Number, TWINFO(info.Duration, LINEAR), {Value = End}):Play();
end;

return Tween; -- why eevn add to global env if we dont call from there
