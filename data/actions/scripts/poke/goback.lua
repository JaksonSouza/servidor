dofile('data/lib/pokelib.lua')

function onUse(player, item, position)

	local pokeId = item:getAttribute("attack")
	local index = result.getDataInt(db.storeQuery("SELECT `index` from pokemon where id = ".. pokeId ..";"), "index")
	local slotItem = player:getSlotItem(CONST_SLOT_FEET)

    if not slotItem or item.uid ~= slotItem.uid then
    	player:sendTextMessage(MESSAGE_STATUS_SMALL, "Use in Slot.")
    	return true
    end

	if item:getId() == pokes[index].on and #player:getSummons() < 1 then
		Game.pokemonGo(player, pokeId, item, pokes[index].use)

	elseif item:getId() == pokes[index].use and #player:getSummons() > 0 then
        Game.pokemonBack(player, pokeId, item, pokes[index].on)
    end
    
	return true		
end