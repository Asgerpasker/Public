-- why are indents so fucking ass in github
if not hookmetamethod then
	return warn "shitsploit get money brokie";
end;
local INSERT, CLEAR, REMOVE, FIND, SUB = table.insert, table.clear, table.remove, table.find, string.sub;
local isreadonly, setreadonly, getrawmt = isreadonly, setreadonly, getrawmetatable;
local next, typeof = next, typeof;

local HookedMethods;
HookedMethods = {
    Hooks = {},

	Revert = function(info)
		local Info = typeof(info) == "table" and info or (function()
			for i,v in next, HookedMethods.Hooks do
				if v.OldMethod == info then
					return v;
				end;
            end;
        end)();
        local Index = FIND(HookedMethods.Hooks, Info);
        setreadonly(Info.RawMetatable, false);
		Info.RawMetatable[Info.Method] = Info.OldMethod;
        setreadonly(Info.RawMetatable, true);
		CLEAR(Info); REMOVE(HookedMethods.Hooks, Index);
	end,

	Unload = function()
		for i,v in next, HookedMethods.Hooks do
			HookedMethods.Revert(v);
		end;
	end,
};

getgenv().HookedMethods = HookedMethods;
getgenv().Ohookmetamethod = hookmetamethod;

getgenv().hookmetamethod = function(object, method, hook)
	if SUB(method, 1, 2) == "__" then
		warn("Using old hookmetamethod due to method containg __ in start, method: "..method..", inst / object: "..object);
		return Ohookmetamethod(object, method, hook);
	end;
	local RawMetatable, Method = getrawmt(object), "__"..method;
	local OldMethod = RawMetatable[Method];
	INSERT(HookedMethods.Hooks,  {
		RawMetatable = RawMetatable,
		OldMethod = OldMethod,
        Method = Method,
	});

	setreadonly(RawMetatable, false);
	RawMetatable[Method] = hook;
    setreadonly(RawMetatable, true);
	return OldMethod;
end;
