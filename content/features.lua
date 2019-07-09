local feats = {}

local flutedcolumn = {
  name = "Fluted Column",
  useWalkedOnImage = true,
  description = "A decorative stone column.",
  symbol = "|",
  passableFor={ghost=true},
  color={r=200,g=200,b=200},
  blocksMovement = true,
  alwaysDisplay = true,
  blocksSight = true,
  ghostPassable=true
}
function flutedcolumn:new()
  self.image_name = "flutedcolumn" .. random(1,2)
end
feats['flutedcolumn'] = flutedcolumn

local seaweed = {
  name = "Seaweed",
  description = "A clump of seaweed.",
  symbol = "{",
  color={r=0,g=150,b=0,a=255},
  useWalkedOnImage=true
}
function seaweed:new()
  local btype = random(1,4)
  self.image_name = "seaweed" .. btype
end
function seaweed:enter(entity,fromX,fromY)
  if entity:is_type('flyer') == false and not entity:has_condition('inbushes') then
    entity:give_condition('inbushes',-1)
    if player:can_see_tile(entity.x,entity.y) then
      output:sound('grass_rustle' .. random(1,2))
    end
  end --end flyer if
end --end enter function
possibleFeatures['seaweed'] = seaweed

return feats