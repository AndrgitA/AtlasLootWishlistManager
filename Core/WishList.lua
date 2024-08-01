---Max count loot items in addon AtlasLoot
local MAX_WISHLIST_ITEMS = 30;

for i = 1, MAX_WISHLIST_ITEMS do
	local frame = getglobal("AtlasLootItem_"..i);
	if (frame) then
		local original_scipt = frame:GetScript("OnClick");
		if original_scipt then
			frame:SetScript("OnClick", function()
        original_scipt(this);
				ALWM_OnClickAtlasLootItem(this);
			end)
		else
			frame:SetScript("OnClick", ALWM_OnClickAtlasLootItem);
		end
	end
end

---Force change title for Frame WishList
---@return void
function ALWM_OnClickAtlasLootItem()
	if AtlasLootItemsFrame.refresh[1] == "WishList" then
		AtlasLoot_BossName:SetText(AtlasLootCharDB.AtlasLootWishlistManagerDB.currentWishlistName);
  end
end