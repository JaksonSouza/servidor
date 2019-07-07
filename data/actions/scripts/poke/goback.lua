dofile('data/lib/pokelib.lua')

function removeCreature(player)
		local summons = player:getSummons()
		for _, pid in ipairs(summons) do
			doRemoveCreature(pid)
		end
return true
end

function pokemonGo(player, pokeName, pokeId, ballType)
    if player:getGroup():getId() ~= 3 then
		player:setGroup(Group(4))
	end

    poke = Game.createMonster(pokeName, player:getPosition())
    player:setStorageValue(10000, 1)
	local health = result.getDataInt(db.storeQuery("SELECT `health` from pokemon where id = ".. pokeId ..";"), "health")
	poke:setHealth(health)
	poke:setMaster(player)
	poke:setFollowCreature(poke:getMaster())
	--poke:setName(pokeName,pokeName..". Pertence a "..player:getName())
	poke:getPosition():sendMagicEffect(balls[ballType].goback)
	player:say(pokeName..", eu escolho você!", TALKTYPE_ORANGE_1)
    
    local attackers = Game.getSpectators(player:getPosition(), false, false, 0, 10, 0, 10)
	for i = 1, #attackers do
    	if attackers[i]:getTarget() == player then
        	attackers[i]:setTarget(poke)
       	    attackers[i]:setFollowCreature(poke)
    	end
	end
	return true
end

function pokemonBack(player, pokeName, pokeId, ballType)
	if player:getGroup():getId() ~= 3 then
		player:setGroup(Group(1))
	end

	player:setStorageValue(10000, -1)
	db.query("UPDATE `pokemon` SET `health` = ".. poke:getHealth() .." WHERE `id` = "..pokeId..";")
	poke:getPosition():sendMagicEffect(balls[ballType].goback)
	player:say(pokeName..", volte.", TALKTYPE_ORANGE_1)
	removeCreature(player)
	return true		
end

function onUse(player, item, position)

	local pokeId = item:getAttribute("attack")
	local ballType = result.getDataInt(db.storeQuery("SELECT `ballType` from pokemon where id = ".. pokeId ..";"), "ballType")
	local pokeName = result.getDataString(db.storeQuery("SELECT `name` from pokemon where id = ".. pokeId ..";"), "name")
	local index = result.getDataInt(db.storeQuery("SELECT `index` from pokemon where id = ".. pokeId ..";"), "index")
	local slotItem = player:getSlotItem(CONST_SLOT_FEET)

    if not slotItem  then
    	player:sendTextMessage(MESSAGE_STATUS_SMALL, "Use in Slot.")
    	return true
    elseif item.uid ~= slotItem.uid then
    	player:sendTextMessage(MESSAGE_STATUS_SMALL, "Use in Slot.")
    	return true
    end
	if item:getId() == pokes[index].on and #player:getSummons() < 1 then
		pokemonGo(player, pokeName, pokeId, ballType)
		item:transform(pokes[index].use)

	elseif item:getId() == pokes[index].use and #player:getSummons() > 0 then
        pokemonBack(player, pokeName, pokeId, ballType)
        item:transform(pokes[index].on)
      --  item:setAttribute("name",balls[ballType].name)
      --  item:setAttribute(4, "Contém um "..pokeName..", derrotado.")
        

    elseif item:getId() == pokes[index].on and #player:getSummons() == 1 then
		player:sendTextMessage(MESSAGE_STATUS_SMALL, "Limit 1 Pokemon.")
    end
	return true		
end