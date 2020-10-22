
--[[
	Kevin's Product Whitelist System
	
	Developed by Kevin82951817 on 10/22/2020
	Developed for public use under MIT License
	
	This is a Roblox Lua open-source module that can be used for whitelisting a product by ownership 
	of assets using HTTPServices. All Roblox assets work with this except gamepasses and developer products.
--]]


local groupService = game:GetService("GroupService")
local players = game:GetService("Players")
local marketplaceService = game:GetService("MarketplaceService")
local httpServices = game:GetService("HttpService")
local runService = game:GetService("RunService")

local placeID = game.PlaceId
local placeInfo = marketplaceService:GetProductInfo(placeID)

local gameOwner = 0
if placeInfo.Creator.CreatorType == "Group" then 
	gameOwner = groupService:GetGroupInfoAsync(placeInfo.Creator.CreatorTargetId).Owner.Id 
else 
	gameOwner = game.CreatorId 
end

local function isInStudios()
	if runService:IsStudio() then
		return true
	else
		return false
	end
end

local function isHttpServicesOn()
	local httpSucess, response = pcall(function()
		httpServices:GetAsync("https://google.com/")
	end)
	return httpSucess, response
end

local function doesOwnerOwnAsset(assetId)
	local query = "userId=".. tostring(gameOwner) .. "&assetId=".. tostring(assetId)
	local requestSucess, response = pcall(function()
		return httpServices:GetAsync("https://api.rprxy.xyz/ownership/hasasset?"..query, true)
	end)

	if tostring(response) == "true" then
		return true,nil
	elseif tostring(response) == "false" then
		return false,nil
	else
		return nil,true
	end
end

local function isUserManuallyWhitelisted(ids)
	for i, id in pairs(ids) do
		if id == gameOwner then
			return true
		end
	end
	return false
end

return {
	["Init"] = function(whitelistInfo)
		local companyName = whitelistInfo.Settings.ProductCompany
		local productName = whitelistInfo.Settings.ProductName

		if whitelistInfo then
			if whitelistInfo.WhitelistSetting.PrintStatusInfoSettings.WhitelistStartingMessage == true then
				print(companyName.." | Whitelist Starting")
			elseif tostring(whitelistInfo.WhitelistSetting.PrintStatusInfoSettings.WhitelistStartingMessage) then
				print(whitelistInfo.WhitelistSetting.PrintStatusInfoSettings.WhitelistStartingMessage)
			end

			local httpSuccess, httpRes = isHttpServicesOn()
			if httpSuccess == true then
				if whitelistInfo.WhitelistSetting.AllowUsageInStudios == false then
					local isStudios = isInStudios()
					if isStudios == true then
						if whitelistInfo.WhitelistSetting.PrintStatusInfoSettings.UsageInStudioMessage == true then
							print(companyName.." | Whitelist Error: You cannot use "..productName.. " in Roblox Studios, please use in game.")
							return whitelistInfo.WhitelistSetting.IfPlaceIsNotWhitelistedOrErrorOccured("User illegally used product in studios.")
						elseif tostring(whitelistInfo.WhitelistSetting.PrintStatusInfoSettings.UsageInStudioMessage) then
							print(whitelistInfo.WhitelistSetting.PrintStatusInfoSettings.UsageInStudioMessage)
							return whitelistInfo.WhitelistSetting.IfPlaceIsNotWhitelistedOrErrorOccured("User illegally used product in studios.")
						end
					end
				end

				local isManuallyWhitelisted = isUserManuallyWhitelisted(whitelistInfo.Settings.ManualWhitelist)
				if isManuallyWhitelisted == true then
					if whitelistInfo.WhitelistSetting.PrintStatusInfoSettings.WhitelistSucessfulMessage == true then
						print(companyName.." | Whitelist sucessful (manual whitelist).")
						return whitelistInfo.WhitelistSetting.IfPlaceIsWhitelisted()
					elseif tostring(whitelistInfo.WhitelistSetting.PrintStatusInfoSettings.WhitelistSucessfulMessage) then
						print(whitelistInfo.WhitelistSetting.PrintStatusInfoSettings.WhitelistSucessfulMessage)
						return whitelistInfo.WhitelistSetting.IfPlaceIsWhitelisted()
					end
				else
					local doesOwnAsset, assetErr = doesOwnerOwnAsset(whitelistInfo.Settings.AssetId)

					if doesOwnAsset == true and not assetErr then
						if whitelistInfo.WhitelistSetting.PrintStatusInfoSettings.WhitelistSucessfulMessage == true then
							print(companyName.." | Whitelist sucessful (asset whitelist).")
							return whitelistInfo.WhitelistSetting.IfPlaceIsWhitelisted()
						elseif tostring(whitelistInfo.WhitelistSetting.PrintStatusInfoSettings.WhitelistSucessfulMessage) then
							print(whitelistInfo.WhitelistSetting.PrintStatusInfoSettings.WhitelistSucessfulMessage)
							return whitelistInfo.WhitelistSetting.IfPlaceIsWhitelisted()
						end
					elseif doesOwnAsset == false and not assetErr then
						if whitelistInfo.WhitelistSetting.PrintStatusInfoSettings.WhitelistUnsucessfulMessage == true then
							print(companyName.." | Whitelist Error: You are not whitelisted to use "..productName)
							return whitelistInfo.WhitelistSetting.IfPlaceIsNotWhitelistedOrErrorOccured("Not whitelisted.")
						elseif tostring(whitelistInfo.WhitelistSetting.PrintStatusInfoSettings.WhitelistUnsucessfulMessage) then
							print(whitelistInfo.WhitelistSetting.PrintStatusInfoSettings.WhitelistUnsucessfulMessage)
							return whitelistInfo.WhitelistSetting.IfPlaceIsNotWhitelistedOrErrorOccured("Not whitelisted.")
						end
					else
						if whitelistInfo.WhitelistSetting.PrintStatusInfoSettings.WhitelistErrorMessage == true then
							warn(companyName.." | Whitelist Error: "..assetErr)
							return whitelistInfo.WhitelistSetting.IfPlaceIsNotWhitelistedOrErrorOccured(assetErr)
						end
					end
				end
			else
				if whitelistInfo.WhitelistSetting.PrintStatusInfoSettings.WhitelistErrorMessage == true then
					warn(companyName.." | Whitelist Error: "..httpRes)
					return whitelistInfo.WhitelistSetting.IfPlaceIsNotWhitelistedOrErrorOccured(httpRes)
				end
			end
		end
	end,
	["doesPlayerOwnAsset"] = function(asset)
		local doesOwnAsset, err = doesOwnerOwnAsset(asset)
		if not err then return doesOwnAsset else return err end
	end,
	["isHTTPEnabled"] = function()
		local httpSuccess, err = isHttpServicesOn()
		if not err then return httpSuccess else return err end
	end,
	["isInStudios"] = function()
		return isInStudios()
	end
}
