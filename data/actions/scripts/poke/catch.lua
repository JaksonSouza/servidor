dofile('data/lib/pokelib.lua')

function onUse(player, item, fromPosition, target, toPosition, isHotkey)


  if contains(pokes,target:getId()) == false then
      player:sendTextMessage(MESSAGE_STATUS_SMALL, "Use no slot correto.")
      return true
  end

  ballType = item:getId()
  pokeName = pokes[target:getId()].name
  rate = pokes[target:getId()].rate
  iconOn = pokes[target:getId()].on
  healthMax = pokes[target:getId()].healthMax

  Game.pokemonCatch(player,ballType,rate,iconOn,target,pokeName,healthMax)

  return true		
end