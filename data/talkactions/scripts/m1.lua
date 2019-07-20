local area = createCombatArea{
    {1, 1, 1},
    {1, 3, 1}
}

function onSay(player, words, param)

    local lvl = player:getLevel()
    local dmgMax = ((lvl * 5))
    local dmgMin = ((dmgMax*0.90))
    local summon = player:getSummons()[1]
  
    return  doAreaCombatHealth(player:getSummons()[1], COMBAT_PHYSICALDAMAGE, summon:getPosition(), area, -dmgMin, -dmgMax, CONST_ME_BLOCKHIT)

end