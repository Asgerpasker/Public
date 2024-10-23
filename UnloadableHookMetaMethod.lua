if not hookmetamethod then
	return warn "shitsploit get money brokie";
elseif HookedMetaMethods then
	return;
end;
local isreadonly, setreadonly, getrawmt, OldHookmetamethod = isreadonly, setreadonly, getrawmetatable, hookmetamethod;
local INSERT, CLEAR, REMOVE, SUB = table.insert, table.clear, table.remove, string.sub;

local HookedMetaMethods;
HookedMetaMethods = {
	Revert = function(tbl)
		for i,v in next, tbl do
		end;
		tbl.RawMetatable[tbl.Method] = tbl.OldMethod;
		setreadonly(tbl.RawMetatable, tbl.ReadOnly);
		CLEAR(tbl);
	end,

	Unload = function(oldmethod)
		if oldmethod then
			for i,v in next, HookedMetaMethods do
				if v.OldMethod == oldmethod then
					HookedMetaMethods.Revert(v);
					return; -- exit loop and func
				end;
			end;
		end;

		for i,v in next, HookedMetaMethods do
			if typeof(v) == "table" then
				HookedMetaMethods.Revert(v);
				REMOVE(HookedMetaMethods, i);
			end;
		end;
	end,
};

getgenv().HookedMetaMethods = HookedMetaMethods;

getgenv().hookmetamethod = function(inst, method, hook)
	if SUB(method, 1, 2) == "__" then
		warn("Using old hookmetamethod due to method containg __ in start, method: "..method..", inst / object: "..inst);
		return OldHookmetamethod(inst, method, hook);
	end;

	local RawMetatable, Method = getrawmt(inst), "__"..method;
	local OldMethod, ReadOnly = RawMetatable[Method], isreadonly(RawMetatable);
	setreadonly(RawMetatable, false);

	INSERT(HookedMetaMethods,  {
		RawMetatable = RawMetatable,
		Method = Method,
		OldMethod = OldMethod,
		ReadOnly = ReadOnly,
	});

	RawMetatable[Method] = hook;
	return OldMethod;
end;
