dofile('data/lib/pokelib.lua')

function onUse(player, item, position)

	local pokeId = item:getAttribute("attack")
	local corpse = item:getAttribute("defense")

	local slotItem = player:getSlotItem(CONST_SLOT_FEET)

    if not slotItem or item.uid ~= slotItem.uid then
    	player:sendTextMessage(MESSAGE_STATUS_SMALL, "Use no slot correto.")
    	return true
    end

	if item:getId() == pokes[corpse].on and #player:getSummons() < 1 then
		Game.pokemonGo(player, pokeId, item, pokes[corpse].use)

	elseif item:getId() == pokes[corpse].use and #player:getSummons() > 0 then
        Game.pokemonBack(player, pokeId, item, pokes[corpse].on)
    end
    
	return true		
end