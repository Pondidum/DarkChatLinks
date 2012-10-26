local URL_COLOR = "16FF5D"

local originalSetItemRef = SetItemRef
local replacementSetItemRef = function(link, text, button, chatFrame)

	if strsub(link, 1, 3) == "url" then

		local chatFrameEditBox = ChatEdit_ChooseBoxForSend()
		local url = strsub(link, 5)

		ChatEdit_ActivateChat(chatFrameEditBox)

		chatFrameEditBox:Insert(url)
		chatFrameEditBox:HighlightText()

	else
		originalSetItemRef(link, text, button, chatFrame)
	end
	
end
SetItemRef = replacementSetItemRef


local createUrl = function(url)
	return " |cff".. URL_COLOR .. "|Hurl:" .. url .. "|h" .. url .. "|h|r "
end

local addLinkSyntax = function(chatstring)

	if type(chatstring) == "string" then
	
		local extraspace
		
		if not strfind(chatstring, "^ ") then
			extraspace = true
			chatstring = " " .. chatstring
		end
		
		chatstring = gsub (chatstring, " www%.([_A-Za-z0-9-]+)%.(%S+)%s?", createUrl("www.%1.%2"))
		chatstring = gsub (chatstring, " (%a+)://(%S+)%s?", createUrl("%1://%2"))
		chatstring = gsub (chatstring, " ([_A-Za-z0-9-%.]+)@([_A-Za-z0-9-]+)(%.+)([_A-Za-z0-9-%.]+)%s?", createUrl("%1@%2%3%4"))
		chatstring = gsub (chatstring, " (%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?):(%d%d?%d?%d?%d?)%s?", createUrl("%1.%2.%3.%4:%5"))
		chatstring = gsub (chatstring, " (%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?)%s?", createUrl("%1.%2.%3.%4"))
		
		if extraspace then
			chatstring = strsub(chatstring, 2)
		end
		
	end
	
	return chatstring
end

local initialise = function()
	
	for i = 1, NUM_CHAT_WINDOWS do

		local frame = _G["ChatFrame" .. i]

		local addmessage = frame.AddMessage
		local replacement = function(self, text, ...) 
			addmessage(self, addLinkSyntax(text), ...) 
		end
		frame.AddMessage = replacement

	end

end

initialise()