--Table for all data to be inserted into.  Included here as it is the first file loaded
AtlasLootWishlistManager_Data = {};

--Create the library instance
local L = AceLibrary("AceLocale-2.2"):new("AtlasLootWishlistManager");

--Allow reporting of what translations are missing
L:EnableDebugging();

--Allow the language to be changed dynamically for debugging purposes
L:EnableDynamicLocales();

--Register translations
L:RegisterTranslations("enUS", function()
	return {
		["AtlasLootWishlistManager"] = true,
		["WishLists"] = true,
		["Close Menu"] = true,
		["Add New"] = true,
		["Enter a name for new wishlist"] = true,
		["Are you sure you want to delete"] = true,
		["Are you sure you want to clean"] = true,
		["Show Wishlist"] = true,
		["Showed Wishlist"] = true,
		["Delete Wishlist"] = true,
		["Removed Wishlist"] = true,
		["Set Wishlist"] = true,
		["Set Wishlist chat"] = "Set Wishlist",
		["Clean Wishlist"] = true,
		["Cleaned Wishlist"] = true,
		["Added new Wishlist"] = true,
		["Wishlist"] = true,
	};
end)
