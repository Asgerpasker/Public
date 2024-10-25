if not hookmetamethod then
	return warn "shitsploit get money brokie";
end;
local INSERT, CLEAR, REMOVE, SUB = table.insert, table.clear, table.remove, string.sub;
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
		Info.RawMetatable[Info.Method] = Info.OldMethod;
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

getgenv().hookmetamethod = function(inst, method, hook)
	if SUB(method, 1, 2) == "__" then
		warn("Using old hookmetamethod due to method containg __ in start, method: "..method..", inst / object: "..inst);
		return Ohookmetamethod(inst, method, hook);
	end;
	local RawMetatable, Method = getrawmt(inst), "__"..method;
	local OldMethod = RawMetatable[Method];
	setreadonly(RawMetatable, false);

	INSERT(HookedMethods.Hooks,  {
		RawMetatable = RawMetatable,
		OldMethod = OldMethod,
        Method = Method,
	});

	RawMetatable[Method] = hook;
	return OldMethod;
end;
