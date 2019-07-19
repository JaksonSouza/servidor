dofile('data/lib/pokelib.lua')

function onUse(player, item, fromPosition, target, toPosition, isHotkey)


  if contains(pokes,target:getId()) == false then
      player:sendTextMessage(MESSAGE_STATUS_SMALL, "Use in Pokemon.")
      return true
  end

  ballType = item:getId()
  pokeName = pokes[target:getId()].name
  rate = pokes[target:getId()].rate
  iconOn = pokes[target:getId()].on
  healthmax = pokes[target:getId()].healthmax

  Game.pokemonCatch(player,ballType,rate,iconOn,target,pokeName,healthmax)

  return true		
end