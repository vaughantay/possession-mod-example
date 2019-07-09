local projectiles = {}

local net = {
  name = "net",
  description = "A throwing net.",
  symbol = "#",
  angled = true,
  color = {r=255,g=164,b=100},
  time_per_tile = .02
}
function net:hits(target)
  if target.baseType == "creature" then
    target:give_condition('entangled',tweak(5))
    currMap:add_effect(Effect('conditionanimation',{owner=target,condition="entangled",symbol="#",image_base="lassotangle",image_max=2,speed=target.animation_time,color={r=255,g=164,b=100,a=255},use_color_with_tiles=false,spritesheet=true}),target.x,target.y)
    target:notice(self.source)
  end --end creature if
  self:delete()
end --end hits function
projectiles['net'] = net

local ink = {
  name = "ink",
  description = "A glob of ink.",
  symbol = "*",
  angled = true,
  color = {r=33,g=33,b=33},
  time_per_tile = .1
}
function ink:hits(target)
  if target.baseType == "creature" then
    target:notice(self.source)
    target:give_condition('blinded',tweak(3))
  end --end creature if
  self:delete()
end --end hits function
projectiles['ink'] = ink

return projectiles