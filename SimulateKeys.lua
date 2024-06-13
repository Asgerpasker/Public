--[[
	Simple library to simulate the pressing of keys in Roblox
	Specifically made for Solara, and other level 3 executors, due to their lack of proper UNC
	Only supports left mouse button

	---------> ethereon.xyz <---------
]]

local VirtualInputManager = game:GetService("VirtualInputManager");
local RenderStepped, KeyCode = game:GetService("RunService").RenderStepped, Enum.KeyCode;
local HasKeyFunctions = typeof(keypress) == "function" and typeof(keyrelease) == "function";
local KeyLibrary = {
	_AUTHOR = "Asgerpasker",
	_BESTTC2HACK = "ethereon.xyz",
	_LASTUPDATED = "6/7/2024", -- MM/DD/YYYY
};

function SimulateKey(key, down) -- no add to keylibrary table since this function wasn't made for mongos to use
	--key = KeyCode[key:upper()] or KeyCode[key] or key; why doesnt this just fucking work

	if key == "M1" then
		VirtualInputManager:SendMouseButtonEvent(0, 0, 0, down, game, 0);

	elseif HasKeyFunctions then
		if down then
			keypress(key);
		else
			keyrelease(key);
		end;
	else
		VirtualInputManager:SendKeyEvent(down, key, false, game);
	end;
end;

function KeyLibrary:TapKey(key)
	if key == "M1" then
		SimulateKey("M1", true);
		RenderStepped:Wait(); -- wait for 1 frame to render or soemthin so it actually registers the key tap
		SimulateKey("M1", false);
	else
		SimulateKey(key, true);
		SimulateKey(key, false);
	end;
end;

function KeyLibrary:HoldKey(key)
	if key == "M1" then
		SimulateKey("M1", true);
	else
		SimulateKey(key, true);
	end;
end;

function KeyLibrary:ReleaseKey(key)
	if key == "MOUSEBUTTON1" or key == "M1" then
		SimulateKey("M1", false);
	else
		SimulateKey(key, false);
	end;
end;

--[[
local key = keycode(key)
key = key or "m1"

simulatekey(key, down)
--]]

  --[[
loadstring(game:HttpGet("https://raw.githubusercontent.com/Asgerpasker/Public/main/SimulateKeys.lua"))();
  --]]

-- HoldKey, ReleaseKey

getgenv().KeyLibrary = KeyLibrary;
return KeyLibrary;
