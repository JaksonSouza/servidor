dofile('data/lib/pokelib.lua')

function onUse(player, item, fromPosition, target, toPosition, isHotkey)

   local lastId = result.getDataInt(db.storeQuery("select max(id) from pokemon;"), "max(id)")
   local luck = math.random(1, 1000)
   local ballType = item:getId()
   local playerId = player:getGuid()
   player:sendExtendedOpcode(51, "001.png")
   
  if contains(pokes,target:getId()) == false then
      player:sendTextMessage(MESSAGE_STATUS_SMALL, "Use in Pokemon.")
      return true
  end

	--if target:getId() == target:getId() then
    	--if target:getId() == target:getId() then
        	local pokeBall = result.getDataInt(db.storeQuery("SELECT `Poke Ball` from balls where `player_id`="..playerId.." and `key`= "..target:getId()..";"), "Poke Ball")
       	    local greatBall = result.getDataInt(db.storeQuery("SELECT `Great Ball` from balls where `player_id`="..playerId.." and `key`= "..target:getId()..";"), "Great Ball")
        	local superBall = result.getDataInt(db.storeQuery("SELECT `Super Ball` from balls where `player_id`="..playerId.." and `key`= "..target:getId()..";"), "Super Ball")
       	    local ultraBall = result.getDataInt(db.storeQuery("SELECT `Ultra Ball` from balls where `player_id`="..playerId.." and `key`= "..target:getId()..";"), "Ultra Ball")
        	local rate = (pokes[target:getId()].rate*balls[ballType].rate) 
            item:remove(1)
            local query = result.getDataString(db.storeQuery("SELECT `key` from balls where `player_id`="..playerId.." and `key`= "..target:getId()..";"), "key")
   		    if query == tostring(target:getId()) then
   				db.query("UPDATE `balls` SET `"..balls[ballType].name.."` = `"..balls[ballType].name.."`+1 where `player_id` = "..playerId.." and `key`= "..target:getId()..";")
   		    else
   				pokeBall=0
   				greatBall=0
   				superBall=0
   				ultraBall=0

   				if ballType == 26382 then --pokeball
   					pokeBall=1
   				elseif ballType == 26383 then --greatball
   					greatBall=1
   				elseif ballType == 26384 then --superball
   					superBall=1
   				elseif ballType == 26385 then --ultraball
   					ultraBall=1
   				end
 				db.query("INSERT INTO `balls` (`player_id`,`key`,`Poke Ball`,`Great Ball`,`Super Ball`,`Ultra Ball`) VALUES ("..playerId..","..target:getId()..","..pokeBall..","..greatBall..","..superBall..","..ultraBall..");")
   			end
        
    		pokeBall = result.getDataInt(db.storeQuery("SELECT `Poke Ball` from balls where `player_id`="..playerId.." and `key`= "..target:getId()..";"), "Poke Ball")
    		greatBall = result.getDataInt(db.storeQuery("SELECT `Great Ball` from balls where `player_id`="..playerId.." and `key`= "..target:getId()..";"), "Great Ball")
   			superBall = result.getDataInt(db.storeQuery("SELECT `Super Ball` from balls where `player_id`="..playerId.." and `key`= "..target:getId()..";"), "Super Ball")
   			ultraBall = result.getDataInt(db.storeQuery("SELECT `Ultra Ball` from balls where `player_id`="..playerId.." and `key`= "..target:getId()..";"), "Ultra Ball")

    		if luck >= 1 and luck <= rate then

            local bp = player:getSlotItem(CONST_SLOT_BACKPACK)
            local depot = player:getDepotChest(1)
    			  local aux=target:getId()
    			  addEvent(function()
   				            catch = Game.createItem(pokes[target:getId()].on)
           		        catch:setAttribute("attack", lastId+1)
         	  	        catch:setAttribute(4, "Contém "..pokes[aux].description..".")
         	  	        catch:setAttribute("name",item:getName())
         	  	        --local window = ModalWindow(1000, "Caught","") 
         	  	        --window:addButton(101, "Ok")
                        --window:setDefaultEscapeButton(101)
         	  	       
                      if bp:getEmptySlots(true) > 0 then
                          catch:moveTo(player)
                      else
                           catch:moveTo(depot)
                           player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE,"You caught a Pokemon! ("..pokes[aux].name.."). You've wasted: "..pokeBall.." Poke Ball and "..greatBall.." Great Ball and "..superBall.." Super Ball and "..ultraBall.." Ultra Ball to catch it. FOI ENVIADO PRO DP")

                      end
   				      end, 4000)
   	       		  
              	  db.query("INSERT INTO `pokemon` (`id`,`index`,`name`,`ballType`,`health`) VALUES (null,"..target:getId()..",'"..pokes[target:getId()].name.."',"..ballType..","..pokes[target:getId()].healthmax..");")
              	  db.query("DELETE FROM balls WHERE `key` = "..target:getId().." and `player_id` = "..playerId..";")
        	   	    target:getPosition():sendMagicEffect(balls[ballType].sucess)
			  	        target:remove()
             else
   					    target:getPosition():sendMagicEffect(balls[ballType].fail)
   					    target:remove()
   					    addEvent(function()
         				   player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE,balls[ballType].name.." broke.")
   				      end, 4000)
   			 end       
   	    
   	return true		
end