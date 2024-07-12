--[[
	Simple library to simulate the pressing of keys in Roblox
	Only supports left mouse button
]]

local VirtualInputManager = game:GetService("VirtualInputManager");
local RenderStepped, KeyCode = game:GetService("RunService").RenderStepped, Enum.KeyCode;
local HasKeyFunctions = typeof(keypress) == "function" and typeof(keyrelease) == "function";
local KeyLibrary = {
	_AUTHOR = "Asgerpasker",
};

function SimulateKey(key, down) -- no add to keylibrary table since this function wasn't made for mongos to use
	--key = KeyCode[key:upper()] or KeyCode[key] or key; why doesnt this just fucking work

	if key == "M1" then
		VirtualInputManager:SendMouseButtonEvent(0, 0, 0, down, game, 0);
		print "m1";
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

function KeyLibrary:TapKey(key, delay)
	SimulateKey(key, true);
	task.wait(delay);
	RenderStepped:Wait(); -- wait for 1 frame to render or soemthin so it actually registers the key tap
	SimulateKey(key, false);
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
