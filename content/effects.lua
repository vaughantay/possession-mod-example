local eff = {}

local electricbolt = {
	name = "electric bolt",
	description = "A bolt of electricity.",
	strength = 6,
  hazard = 5,
	symbol = "/",
  timer = 0.1,
	color = {r=200,g=200,b=255,a=255}
}
function electricbolt:update(dt)
  if self.timer <= 0 then
    self:delete()
  else
    self.timer = self.timer-dt
  end
end

eff['electricbolt'] = electricbolt

return eff