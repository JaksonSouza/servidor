function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local position = target:getPosition()

	if player:getStorageValue(10000) == 1 then
		local poke = player:getSummons()[1]
		--poke:setFollowCreature(nil)
	poke:moveTo(position)
		player:say(poke:getName()..", move!", TALKTYPE_ORANGE_1)
	else
		player:sendTextMessage(MESSAGE_STATUS_SMALL, "No have pokemon.")   			   
	end
return true
end