-- Instance Addon Data
ALWM = {};

---Init Addon Variables
---@return void
local function ALWM_initVariables()	
	--- Add "AtlasLootWishlistManagerDB" to data addon AtlasLootCharDB
	if (not AtlasLootCharDB) then
		AtlasLootCharDB = {};
	end

	-- AtlasLootCharDB.AtlasLootWishlistManagerDB = nil
	if (not AtlasLootCharDB.AtlasLootWishlistManagerDB) then
		AtlasLootCharDB.AtlasLootWishlistManagerDB = {};
	end

	if (not AtlasLootCharDB.AtlasLootWishlistManagerDB.Wishlists or not AtlasLootCharDB.AtlasLootWishlistManagerDB.Wishlists["default"]) then
		AtlasLootCharDB.AtlasLootWishlistManagerDB.Wishlists = {
			["default"] = {
				name = "default",
				key = "default",
				data = AtlasLootCharDB.WishList or {},
			},
		};
	end

	if (not AtlasLootCharDB.AtlasLootWishlistManagerDB.currentWishlistName) then
		AtlasLootCharDB.AtlasLootWishlistManagerDB.currentWishlistName = "default";
	end
end

---Init Work Addon
---@return void
local function ALWM_init()
	ALWM.enabled = false
	if (AtlasLootWishlistManager_replaceWishlistButton()) then 
		ALWM.enabled = true;
	end;
end

ALWM.frame = CreateFrame("Frame");
ALWM.frame:RegisterEvent("VARIABLES_LOADED");
ALWM.frame:RegisterEvent("PLAYER_ENTERING_WORLD");
ALWM.frame:SetScript("OnEvent", function()
	if event == "VARIABLES_LOADED" then
		ALWM_initVariables();
	elseif event == "PLAYER_ENTERING_WORLD" then
		ALWM_init();
		this:UnregisterAllEvents();
		this:SetScript("OnEvent", nil);
	end
end)



