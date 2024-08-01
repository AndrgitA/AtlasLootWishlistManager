---Custom Method printing to console some data
---@param ... any
---@return void
function AtlasLootWiwhlistManager_Print(...)
  if arg.n == 0 then
    return;
  end

  local result = tostring(arg[1]);
  for i = 2, arg.n do
    result = result.." "..tostring(arg[i]);
  end

  DEFAULT_CHAT_FRAME:AddMessage(result, .5, 1, .3);
end

SLASH_ALWM1 = "/rl";
SlashCmdList["ALWM"] = ReloadUI;

---Hook Method for some Script
---@param frame Frame
---@param scriptName string
---@param handler function
---@return void
function ALWM_HookScript(frame, scriptName, handler)
	if not (type(frame) == "table" and frame.GetScript and type(scriptName) == "string" and type(handler) == "function") then
		error("Usage: HookScript(frame, \"type\", function)", 2);
	end

	local original_scipt = frame:GetScript(scriptName);
	if original_scipt then
		frame:SetScript(scriptName, function()
			original_scipt(this);
			handler(this);
		end);
	else
		frame:SetScript(scriptName, handler);
	end
end

---Hook Secure Function
---@param a1 table
---@param a2 string
---@param a3 function
---@return void
function ALWM_hooksecurefunc(a1, a2, a3)
	local isMethod = type(a1) == "table" and type(a2) == "string" and type(a1[a2]) == "function" and type(a3) == "function";
	if not (isMethod or (type(a1) == "string" and type(_G[a1]) == "function" and type(a2) == "function")) then
		error("Usage: hooksecurefunc([table,] \"functionName\", hookfunc)", 2);
	end

	if not isMethod then
		a1, a2, a3 = _G, a1, a2;
	end

	local original_func = a1[a2];

	a1[a2] = function(...)
		local original_return = {original_func(unpack(arg))};
		a3(unpack(arg));

		return unpack(original_return);
	end;
end