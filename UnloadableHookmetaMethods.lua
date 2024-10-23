if not hookmetamethod then
  return print "shitsploit get money brokie";
end;
local isreadonly, setreadonly, getrawmt = isreadonly, setreadonly, getrawmetatable;
local INSERT, CLEAR = table.insert, table.clear;

local HookedMetaMethods;
HookedMetaMethods = {
    Revert = function(tbl)
        tbl.RawMetatable[tbl.Method] = tbl.OldMethod
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
            HookedMetaMethods.Revert(v);
        end;
        CLEAR(HookedMetaMethods);
    end,
};

getgenv().HookedMetaMethods = HookedMetaMethods;

getgenv().hookmetamethod = function(inst, method, hook)
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