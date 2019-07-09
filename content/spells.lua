local spells = {

thrownet = Spell({
	name = "Throw Net",
	description = "Throw a net at a creature.",
	cooldown = 10,
  AIcooldown=20,
	target_type = "creature",
	flags = {aggressive=true},
	cast = function(self,target,caster)
		if player:can_sense_creature(caster) then
      output:out(caster:get_name() .. " throws a net at " .. target:get_name() .. ".")
    end
    Projectile('net',caster,target)
	end
}),

ink = Spell({
	name = "Spit Ink",
	description = "Spit ink at a creature.",
	cooldown = 10,
  AIcooldown=20,
	target_type = "creature",
	flags = {aggressive=true},
	cast = function(self,target,caster)
		if player:can_sense_creature(caster) then
      output:out(caster:get_name() .. " spits ink at " .. target:get_name() .. ".")
    end
    Projectile('ink',caster,target)
	end
}),

waterdweller = Spell({
	name = "Water-Dweller",
	description = "You're a natural in the water, but pretty awkward on the land.",
	target_type = "passive",
  advance = function(self,possessor)
    if currMap[possessor.x][possessor.y] == "." then
      possessor:give_condition('floppingonland',-1)
      return true
    end
    
    local water = false
    if type(currMap[possessor.x][possessor.y]) == "table" and currMap[possessor.x][possessor.y].water == true then
      water = true
    end
    if water == false then
      for _,feat in pairs(currMap.contents[possessor.x][possessor.y]) do
        if feat.water == true then
          water = true
          break
        end
      end
    end
    if water == false then
      possessor:give_condition('floppingonland',-1)
    end
  end
}),

waterelemental = Spell({
	name = "Summon Water Elemental",
	description = "Summons a living(?) being made of water.",
	cooldown = 250,
	target_type = "self",
	flags = {aggressive=true,defensive=true,fleeing=true},
	cast = function (self,target,caster)
		if player:can_see_tile(caster.x,caster.y) then
      output:out(caster:get_name() .. " summons a water elemental!")
      output:sound('splash')
    end
		local done = false
		while (done == false) do
			local x,y = random(caster.x-3,caster.x+3),random(caster.y-3,caster.y+3)
			if (currMap:isClear(x,y)) then
        currMap:add_effect(Effect('animation','splash',5,{x=x,y=y},{r=49,g=162,b=242},x,y,nil,true))
				local g = Creature('waterelemental')
				currMap:add_creature(g,x,y)
        g:become_thrall(caster)
			end
			done = true
		end
	end
}),

bubble = Spell({
	name = "Bubble",
	description = "Trap a creature in a floating bubble that moves them randomly around. Or, if you cast it on yourself, float through the air in a bubble you control.",
	target_type = "creature",
  cooldown=30,
	cast = function (self,target,caster)
		target:give_condition('bubbled',15)
	end
}),

electricbolt = Spell({
	name = "Electric Bolt",
	description = "Shoot a bolt of electricity! It will hit everyone between you and the target.",
	cooldown = 10,
  AIcooldown = 20,
  range=5,
	target_type = "square",
	cast = function(self,target,caster)
		local line = currMap:get_line(caster.x,caster.y,target.x,target.y,true)
    for _,tile in pairs(line) do
      currMap:add_effect(Effect('electricbolt'),tile[1],tile[2])
      local creat = currMap:get_tile_creature(tile[1],tile[2])
      if creat then
        local dmg = creat:damage(random(6,9),caster,"electric")
        if player:can_sense_creature(creat) then
          output:out(creat:get_name() .. " is shocked by " .. caster:get_name().. "'s electric bolt and takes " .. dmg .. " damage.")
        end
      end
    end
    --Do stuff at the endpoint of the bolt:
    
	end,
  get_target_tiles = function(self,target,caster)
    local targets = {}
    if target.x == caster.x and target.y == caster.y then return {} end
    local line = currMap:get_line(caster.x,caster.y,target.x,target.y,true)
    for _,tile in pairs(line) do
      targets[#targets+1] = {x=tile[1],y=tile[2]}
    end
    return targets
  end --end target draw function
}),

electricskin = Spell({
	name = "Electric Skin",
	description = "Anyone who touches you will get quite a jolt.",
	target_type = "passive",
	damaged = function(self,possessor,attacker)
		if (random(1,3) == 1) then
      for x = possessor.x-1,possessor.x+1,1 do
        for y = possessor.y-1,possessor.y+1,1 do
          local creat = currMap:get_tile_creature(x,y)
          if creat and creat ~= possessor then
            local dmg = creat:damage(random(4,7),possessor,"electric")
            if player:can_sense_creature(creat) then
              output:out(creat:get_name() .. " takes a jolt from " .. possessor:get_name() .. ", taking " .. dmg .. " damage.")
            end
          else
            currMap:add_effect(Effect('animation','electricdamage',5,{x=x,y=y},{r=150,g=0,b=150}),x,y)
          end
        end
      end
		end
	end
}),

}

return spells