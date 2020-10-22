
--[[	
	Kevin's Product Whitelist System
	
	Developed by Kevin82951817 on 10/22/2020
	Developed for public use under MIT License
	
	This is a Roblox Lua open-source module that can be used for whitelisting a product by ownership 
	of assets using HTTPServices. All Roblox assets work with this except gamepasses and developer products.
	
	You can implement this into any script! HTTPServices must be enabled for it to work.
	
	whitelistService
		Functions:
			void whitelistService.Init(table whitelistInfo)
			
			whitelistInfo = {
				["Settings"] = {
					["ProductCompany"] = string 
					["ProductName"] = string 
					["AssetId"] = int 
					["ManualWhitelist"] = table 
				};
				["WhitelistSetting"] = {
					["AllowUsageInStudios"] = boolean 
					["PrintStatusInfoSettings"] = {		


						["WhitelistStartingMessage"] = variant
						["UsageInStudioMessage"] = variant
						["WhitelistSucessfulMessage"] = variant
						["WhitelistUnsucessfulMessage"] = variant

						["WhitelistErrorMessage"] = boolean, 
					}
				},
				
				["IfPlaceIsNotWhitelistedOrErrorOccured"] = function
				
				["IfPlaceIsWhitelisted"] = function
			}
			
			
			
			void whitelistService.doesPlayerOwnAsset(int assetId)
			returns variant
			
			void whitelistService.isHTTPEnabled()
			returns variant
			
			void whitelistService.isInStudios()
			returns boolean
		
		
	This product is made for public open-source use
	If there are any errors, be sure to contact me at Kevinxgaming#9543
	
	You are free to edit the source at https://roblox.com/library/5860255435/Kevins-Product-Whitelist-System
	
	Enjoy,
	Kevin82951817
	
]]--

-- Example Script

local whitelistService = require(5860255435)

whitelistService.doesPlayerOwnAsset(1)
whitelistService.isHTTPEnabled()
whitelistService.isInStudios()

whitelistService.Init({
	["Settings"] = {
		["ProductCompany"] = "Lorem Ipsum", -- string value, company name?
		["ProductName"] = "Dolor Sit", -- string value, product name?
		["AssetId"] = 0, -- number value, product id?
		["ManualWhitelist"] = {0} -- number value, player ids you want to manually whitelist?
	};
	["WhitelistSetting"] = {
		["AllowUsageInStudios"] = false, -- boolean value, allow testing in studios?
		["PrintStatusInfoSettings"] = {		
			
			["WhitelistStartingMessage"] = true, -- Example: "[Lorem Ipsum] Whitelist started"
			["UsageInStudioMessage"] = true, -- Example: "[Lorem Ipsum] You must use this in game"
			["WhitelistSucessfulMessage"] = true, -- Example: "[Lorem Ipsum] Whitelist sucessful"
			["WhitelistUnsucessfulMessage"] = true, -- Example: "[Lorem Ipsum] Whitelist unsucessful"
			
			["WhitelistErrorMessage"] = true, 
			
		},
		["IfPlaceIsNotWhitelistedOrErrorOccured"] = function(err)
			print("You are not whitelisted.")
		end,
		["IfPlaceIsWhitelisted"] = function()
			print("You are whitelisted.")
		end
	}
})

