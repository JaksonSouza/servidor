dofile('data/actions/scripts/poke/goback.lua')

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local position = target:getPosition()

	if player:getStorageValue(10000) == 1 then
		poke:setFollowCreature()
		poke:orderTo(position,0,0,0,0,30)
		player:say(poke:getName()..", move!", TALKTYPE_ORANGE_1)
	else
		player:sendTextMessage(MESSAGE_STATUS_SMALL, "No have pokemon.")   			   
	end
return true
end