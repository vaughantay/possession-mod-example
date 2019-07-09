local cons = {
  
  floppingonland = Condition({
    name = "Uncomfortable on Land",
    bonuses={speed=-25,hit_chance=-5,dodge_chance=-15},
    advance = function(self,possessor)
      local water = false
      if type(currMap[possessor.x][possessor.y]) == "table" and currMap[possessor.x][possessor.y].water == true then
        water = true
      end
      for _,feat in pairs(currMap.contents[possessor.x][possessor.y]) do
        if feat.water == true then
          water = true
          break
        end
      end
      if water == true then
        possessor:cure_condition('floppingonland')
      end
    end
  }),

	bubbled = Condition({
		name = "Bubbled",
		bad = true,
    applied = function(self,possessor)
      --Add the condition animation (though it's not really an animation here)
      currMap:add_effect(Effect('conditionanimation',{owner=possessor,condition="bubbled",symbol="0",image_base="bubble_large",spritesheet=true,image_max=1,speed=0,color={r=0,g=255,b=255,a=255},use_color_with_tiles=true}),possessor.x,possessor.y)
      --Mess with creature types:
      possessor.originalPathType = possessor.pathType
      possessor.pathType = "flyer"
      if possessor.types then
        if not possessor:is_type('flyer') then
          possessor.originalTypes = copy_table(possessor.types)
          table.insert(possessor.types,'flyer')
        else
          possessor.originalTypes = possessor.types
        end
      else
        possessor.types = {'flyer'}
      end
      
      if player:can_sense_creature(possessor) then
        --sound?
      end
    end,
    advance = function(self,possessor)
      if possessor.id ~= "hydromancer" then
        local moveX,moveY = random(possessor.x-1,possessor.x+1),random(possessor.y-1,possessor.y+1)
        local tries = 0
        while tries < 10 and (not currMap:isClear(moveX,moveY,false,false,true) or (moveX == possessor.x and moveY == possessor.y)) do
          moveX,moveY = random(possessor.x-1,possessor.x+1),random(possessor.y-1,possessor.y+1)
          tries = tries + 1
        end
        if tries < 10 then possessor:moveTo(moveX,moveY,true) end
      end
    end,
    moves = function(self,possessor)
      if possessor.id ~= "hydromancer" then
        return false
      end
    end,
    cured = function(self,possessor)
      if possessor.originalTypes then
        possessor.types = possessor.originalTypes
        possessor.originalTypes = nil
      else
        possessor.types = nil
      end
      possessor.pathType = possessor.originalPathType
      possessor.originalPathType = nil
    end
	}),
}

return cons