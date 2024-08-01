---Colors from Addon AtlasLoot for message chat
local GREY = "|cff559999";
local RED = "|cffff0000";
local WHITE = "|cffFFFFFF";
local GREEN = "|cff1eff00";
local PURPLE = "|cff9F3FFF";
local BLUE = "|cff0070dd";
local ORANGE = "|cffFF8400";
local DEFAULT = "|cffFFd200";

--Data Locale for ALWM
local L = AceLibrary("AceLocale-2.2"):new("AtlasLootWishlistManager");
AtlasLootWishlistManager_WishlistsMenu = AceLibrary("Hewdrop-2.0");

---Create custom button with dropdown
---@param parent Frame
---@return void
function AtlasLootWishlistManager_createWishlistDropdown(parent)
  local f = CreateFrame("Button", "AtlasLootWishlistManagerWishlistDropdown", parent, "UIPanelButtonTemplate2");
  f:SetWidth(100);
  f:SetHeight(32);
  f:SetPoint("RIGHT", AtlasLootDefaultFrameSearchBox, "LEFT", -7, 0);
  
  f:SetScript("OnClick", function ()
    if AtlasLootWishlistManager_WishlistsMenu:IsOpen() then
      AtlasLootWishlistManager_WishlistsMenu:Close();
    else
      AtlasLootWishlistManager_WishlistsMenu:Open(this);
    end
  end);
  
  f:SetScript("OnShow", function()
    this:SetText(AtlasLootCharDB.AtlasLootWishlistManagerDB.currentWishlistName);
    this:SetFrameLevel((this:GetParent()):GetFrameLevel() + 1);
  end);

  AtlasLootWishlistManager_WishlistsMenuUpdate();
end


---Replace default button WishList with custom button and hide default
---@return boolean
function AtlasLootWishlistManager_replaceWishlistButton()
  local WishListButton = AtlasLootDefaultFrameWishListButton;
  if not WishListButton then 
    return false;
  end

  WishListButton:Hide()
  
  AtlasLootWishlistManager_createWishlistDropdown(WishListButton:GetParent());
  AtlasLootWishlistManager_SetWishlist(AtlasLootCharDB.AtlasLootWishlistManagerDB.currentWishlistName or "default", true);
  return true;
end

---Update dropdown menu data
function AtlasLootWishlistManager_WishlistsMenuUpdate()
  AtlasLootWishlistManager_WishlistsMenu:Close();
  AtlasLootWishlistManager_WishlistsMenu:Unregister(AtlasLootWishlistManagerWishlistDropdown);

  AtlasLootWishlistManager_WishlistsMenu:Register(
    AtlasLootWishlistManagerWishlistDropdown,
    'point', function(parent)
      return "BOTTOM", "TOP"
    end,
    'children', function(level, value)
      if (level == 1) then
        AtlasLootWishlistManager_WishlistsMenu:AddLine(
          'text', L["Add New"],
          'textR', 0.05,
          'textG', 0.9,
          'textB', 0.5,
          'func', function() StaticPopup_Show("ALWM_NewWishlist") end,
          'notCheckable', true
        );
        if (AtlasLootCharDB.AtlasLootWishlistManagerDB.Wishlists) then
          for k, v in pairs(AtlasLootCharDB.AtlasLootWishlistManagerDB.Wishlists) do
            local values = {
              [1] = {
                L["Show Wishlist"],
                "ShowWishlist",
                v.name,
                AtlasLootWishlistManager_ShowWishlist,
              },
              [2] = {
                L["Set Wishlist"],
                "SetWishlist",
                v.name,
                AtlasLootWishlistManager_SetWishlist,
              },
            };

            if (v.name ~= "default") then
              table.insert(values, {
                L["Delete Wishlist"],
                "DeleteWishlist",
                v.name,
                AtlasLootWishlistManager_RemoveWishlist,
              });
            end

            table.insert(values, {
              L["Clean Wishlist"],
              "CleanWishlist",
              v.name,
              AtlasLootWishlistManager_CleanWishlist
            });

            AtlasLootWishlistManager_WishlistsMenu:AddLine(
              'text', v.name,
              'hasArrow', true,
              'value', values,
              'arg1', v.name,
              'notCheckable', true
            );
          end
        end
      elseif (level == 2) then
        if (value) then
          for _, v in pairs(value) do
            AtlasLoot_Hewdrop:AddLine(
              'text', v[1],
              'func', v[4],
              'arg1', v[3],
              'notCheckable', true
            )
          end
        end
      end

      AtlasLootWishlistManager_WishlistsMenu:AddLine(
        'text', L["Close Menu"],
        'textR', 0,
        'textG', 1,
        'textB', 1,
        'func', function() AtlasLootWishlistManager_WishlistsMenu:Close() end,
        'notCheckable', true
      );
    end,
		'dontHook', true
  )
end

---Get empty value for new Wishlist
---@param name string
---@return table
function AtlasLootWishlistManager_GetEmptyWishlist(name)
  return {
    ["name"] = name,
    ["key"] = name,
    ["data"] = {},
  };
end

---Update values for addon AtlasLoot for change data on default WishList values
---@return void
function AtlasLootWishlistManager_UpdateAtlasLootWishlist()
  AtlasLootCharDB.WishList = AtlasLootCharDB.AtlasLootWishlistManagerDB.Wishlists[AtlasLootCharDB.AtlasLootWishlistManagerDB.currentWishlistName].data;
	AtlasLoot_WishList = AtlasLoot_CategorizeWishList(AtlasLootCharDB.WishList);
  AtlasLoot_GetWishListPage(1);
end

---Add new Wishlist
---@param name string name of the wishlist to be added
---@return void
function AtlasLootWishlistManager_AddNewWishlist(name, unnoticed)
  if (not unnoticed) then
    DEFAULT_CHAT_FRAME:AddMessage(BLUE..L["AtlasLootWishlistManager"]..": "..GREY..L["Added new Wishlist"]..ORANGE.." ["..name.."]");
  end

  AtlasLootCharDB.AtlasLootWishlistManagerDB.Wishlists[name] = AtlasLootWishlistManager_GetEmptyWishlist(name);
  AtlasLootWishlistManager_WishlistsMenuUpdate();
end

---Remove Wishlist from all wishlists
---@param name string name of the wishlist to be removed
---@return void
function AtlasLootWishlistManager_RemoveWishlist(name, unnoticed)
  if (not unnoticed) then
    DEFAULT_CHAT_FRAME:AddMessage(BLUE..L["AtlasLootWishlistManager"]..": "..GREY..L["Removed Wishlist"]..ORANGE.." ["..name.."]");
  end

  local dialog = StaticPopupDialogs["ALWM_AcceptRemoveWishlist"];
  dialog.text = L["Are you sure you want to delete"].." \'"..name.."\' ?";
  dialog.OnAccept = function()
    AtlasLootCharDB.AtlasLootWishlistManagerDB.Wishlists[name] = nil;
    if (AtlasLootCharDB.AtlasLootWishlistManagerDB.currentWishlistName == name) then
      if (AtlasLootItemsFrame.refresh[1] == "WishList") then
        AtlasLootWishlistManager_ShowWishlist("default");
      else
        AtlasLootWishlistManager_SetWishlist("default");
      end
    end

    AtlasLootWishlistManager_WishlistsMenuUpdate();
    dialog.text = nil;
    dialog.OnAccept = nil;
	end;
  
  StaticPopup_Show("ALWM_AcceptRemoveWishlist");
end

---Show Wishlist by name
---@param name string name of the wishlist to be showed
---@return void
function AtlasLootWishlistManager_ShowWishlist(name)
  if (not unnoticed) then
    DEFAULT_CHAT_FRAME:AddMessage(BLUE..L["AtlasLootWishlistManager"]..": "..GREY..L["Showed Wishlist"]..ORANGE.." ["..name.."]");
  end

  if (AtlasLootCharDB.AtlasLootWishlistManagerDB.currentWishlistName ~= name) then
    AtlasLootWishlistManager_SetWishlist(name)
  end

  AtlasLootWishlistManager_WishlistsMenuUpdate();
  AtlasLoot_ShowItemsFrame("WishList", "WishListPage"..0, L["Wishlist"].." "..name, pFrame);
end

---Set new active Wishlist to addon AtlasLoot
---@param name string name of the wishlist to be set
---@return void
function AtlasLootWishlistManager_SetWishlist(name, unnoticed)
  if (not unnoticed) then
    DEFAULT_CHAT_FRAME:AddMessage(BLUE..L["AtlasLootWishlistManager"]..": "..GREY..L["Set Wishlist chat"]..ORANGE.." ["..name.."]");
  end
  
  if (AtlasLootCharDB.AtlasLootWishlistManagerDB.currentWishlistName ~= name) then
    local oldWishlistName = AtlasLootCharDB.AtlasLootWishlistManagerDB.currentWishlistName;
    
    if (oldWishlistName and AtlasLootCharDB.AtlasLootWishlistManagerDB.Wishlists[oldWishlistName]) then
      AtlasLootCharDB.AtlasLootWishlistManagerDB.Wishlists[oldWishlistName].data = AtlasLootCharDB.WishList;
    end
    local newWishlistName = AtlasLootCharDB.AtlasLootWishlistManagerDB.Wishlists[name] and name or "default";
    AtlasLootCharDB.AtlasLootWishlistManagerDB.currentWishlistName = newWishlistName;
    AtlasLootWishlistManager_UpdateAtlasLootWishlist();
    
    if (oldWishlistName ~= newWishlistName) then
      if (AtlasLootItemsFrame.refresh[1] == "WishList") then
        AtlasLootWishlistManager_ShowWishlist(newWishlistName, unnoticed);
      end
    end
  
    AtlasLootWishlistManagerWishlistDropdown:SetText(AtlasLootCharDB.AtlasLootWishlistManagerDB.currentWishlistName);
    AtlasLootWishlistManager_WishlistsMenuUpdate();
  end
end

---Clean Wishlist by name
---@param name string name of the Wishlist to be cleaned
---@return void
function AtlasLootWishlistManager_CleanWishlist(name, unnoticed)
  if (not unnoticed) then
    DEFAULT_CHAT_FRAME:AddMessage(BLUE..L["AtlasLootWishlistManager"]..": "..GREY..L["Cleaned Wishlist"]..ORANGE.." ["..name.."]");
  end

  local dialog = StaticPopupDialogs["ALWM_AcceptRemoveWishlist"];
  dialog.text = L["Are you sure you want to clean"].." \'"..name.."\' ?";
  dialog.OnAccept = function()
    AtlasLootCharDB.AtlasLootWishlistManagerDB.Wishlists[name].data = {};
    if (AtlasLootCharDB.AtlasLootWishlistManagerDB.currentWishlistName == name) then
      AtlasLootWishlistManager_UpdateAtlasLootWishlist()
      if (AtlasLootItemsFrame.refresh[1] == "WishList") then
        AtlasLootWishlistManager_ShowWishlist(name);
      else
        AtlasLootWishlistManager_SetWishlist(name);
      end
    end
    
    AtlasLootWishlistManager_WishlistsMenuUpdate();
    dialog.text = nil;
    dialog.OnAccept = nil;
	end;
  
  StaticPopup_Show("ALWM_AcceptRemoveWishlist");
end

---Dialog for create new WishList
StaticPopupDialogs["ALWM_NewWishlist"] = {
	text = L["Enter a name for new wishlist"],
	button1 = SAVE,
	button2 = CANCEL,
	OnAccept = function()
		local name = getglobal(this:GetParent():GetName().."EditBox"):GetText();
    AtlasLootWishlistManager_AddNewWishlist(name)
		getglobal(this:GetParent():GetName().."EditBox"):SetText("");
	end,
	EditBoxOnEnterPressed = function()
		local name = this:GetText();
		AtlasLootWishlistManager_AddNewWishlist(name);
		this:SetText("");
		this:GetParent():Hide();
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	hasEditBox  = true,
	preferredIndex = 3
};

---Dynamic dialog for another operations with sishlists
StaticPopupDialogs["ALWM_AcceptRemoveWishlist"] = {
	text = nil,
	button1 = SAVE,
	button2 = CANCEL,
	OnAccept = nil,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3
};