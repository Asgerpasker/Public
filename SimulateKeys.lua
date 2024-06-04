--[[
Simple library to simulate the pressing of keys in Roblox.
Specifically made for Solara, and other level 3 executors, due to their lack of UNC.
Only supports 1 mouse key (MouseButton1)
]]

local VirtualInputManager = game:GetService("VirtualInputManager");
local RenderStepped = game:GetService("RunService").RenderStepped;
local KeyLibrary = {};

function KeyLibrary:TapKey(key)
	key = key:upper();

	if key == "MOUSEBUTTON1" or key == "M1" then
		VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0);
		RenderStepped:Wait(); -- wait for 1 frame to render or soemthin so it actually registers the key tap
		VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0);
	else
		local Key = Enum.KeyCode[key];

		if Key then
			VirtualInputManager:SendKeyEvent(true, Key, false, game);
			RenderStepped:Wait();
			VirtualInputManager:SendKeyEvent(false, Key, false, game);
		else
			warn("Error with simulating key: "..key);
		end;
	end;
end;
  --[[
key = keycode[key]
  if not key then
  send(e)
else
  sendmouse()
  --]]

-- HoldKey, ReleaseKey

getgenv().KeyLibrary = KeyLibrary;
return KeyLibrary;
