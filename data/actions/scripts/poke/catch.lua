dofile('data/lib/pokelib.lua')

function onUse(player, item, fromPosition, target, toPosition, isHotkey)


  if contains(pokes,target:getId()) == false then
      player:sendTextMessage(MESSAGE_STATUS_SMALL, "Use in Pokemon.")
      return true
  end

  Game.pokemonCatch(player,12660,200,2550,target)

  return true		
end