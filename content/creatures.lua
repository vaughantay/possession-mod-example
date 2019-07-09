local monsters = {}

local fishfrogmanthing = {
  name = "fishfrogmanthing",
  description = "Half fish, half frog, half man-thing, this proud warrior race of amphibious extraterrestrials fled their homeworld and tries to eke out a meager existence on ours.",
  symbol = "F",
  types={"animal","intelligent","swimmer"},
  level = 4,
  strength = 13,
  critical_chance=3,
  melee = 27,
  dodging = 22,
  possession_chance = 50,
  max_hp = 125,
  perception = 9,
  aggression = 50,
  notice_chance = 70,
  bravery=90,
  stealth=-5,
  ranged_chance=20,
  color={r=150,g=150,b=100,a=255},
  animated=true,
  spritesheet=true,
  animation_time=0.1,
  image_max=3
}
monsters['fishfrogmanthing'] = fishfrogmanthing

local sharkman = {
  name = "sharkman",
  description = "He's not here to deliver candygrams.",
  symbol = "S",
  types={"animal","intelligent","swimmer"},
  pathType="swimmer",
  ai_flags={"bully"},
  faction="chaos",
  gender="male",
  hit_conditions={{condition="bleeding",minTurns=2,maxTurns=5,chance=25}},
  crit_conditions={{condition="bleeding",turns=5,chance=100}},
  level = 4,
  strength = 13,
  critical_chance=3,
  melee = 27,
  dodging = 22,
  possession_chance = 50,
  max_hp = 125,
  perception = 9,
  aggression = 50,
  notice_chance = 70,
  stealth=-5,
  color={r=150,g=150,b=150,a=255},
  animated=true,
  spritesheet=true,
  animation_time=0.1,
  image_max=3,
  reverseAnimation=true
}
function sharkman:nameGen()
  local names = {"blood","bone","crush","death","fang","fear","fin","fish","flesh","kill","jaw","maw","meat","mouth","murder","rage","rip","snap","swim","tear","teeth","tooth"}
  return ucfirst(names[random(#names)] .. names[random(#names)])
end
monsters['sharkman'] = sharkman

local merfolkhunter = {
  name = "merfolk hunter",
  description = "Don't be confused, this isn't someone who hunts merfolk, they're a merfolk who hunts whatever prey it is that merfolk hunt. Which is pretty much everything, so look out.",
  symbol = "m",
  types={"intelligent","swimmer"},
  pathType="swimmer",
  nameType="merfolk",
  specialOnly=true,
  level = 4,
  strength = 13,
  critical_chance=3,
  melee = 27,
  dodging = 22,
  possession_chance = 50,
  max_hp = 125,
  perception = 9,
  aggression = 50,
  notice_chance = 70,
  bravery=90,
  stealth=-5,
  spells={'thrownet','waterdweller'},
  faction="merfolk",
  gender="either",
  specialOnly=true,
  ranged_chance=20,
  color={r=150,g=150,b=100,a=255},
  animated=true,
  spritesheet=true,
  animation_time=0.3,
  image_max=4,
  image_varieties=3,
  image_name = "mermaid3",
  new = function(self)
    local base = ""
    if self.gender == "male" then
      base = "merman"
    else
      base = "mermaid"
    end
    self.image_name = base .. self.image_variety
    self.soundgroup = base
    self.name = base .. " hunter"
  end
}
monsters['merfolkhunter'] = merfolkhunter

local electriceel = {
  name = "electric eel",
  description = "A snakelike fish with the capability of generating an electric current in its body. Don't touch it or you'll get an electric feel.",
  symbol = "e",
  types={"animal","swimmer"},
  pathType="swimmer",
  specialOnly=true,
  level = 4,
  strength = 13,
  critical_chance=3,
  melee = 27,
  dodging = 22,
  possession_chance = 50,
  max_hp = 125,
  perception = 9,
  aggression = 50,
  notice_chance = 70,
  bravery=50,
  resistances={electricity=100},
  spells={'electricbolt','electricskin','waterdweller'},
  ranged_chance=50,
  color={r=50,g=42,b=31,a=255},
  animated=true,
  spritesheet=true,
  animation_time=0.15,
  image_max=4
}
monsters['electriceel'] = electriceel

local squid = {
  name = "fairly large but not giant squid",
  description = "It may not be a giant squid, but it's still pretty big.",
  symbol = "s",
  types={"animal","intelligent","swimmer"},
  pathType="swimmer",
  specialOnly=true,
  level = 4,
  strength = 13,
  critical_chance=3,
  melee = 27,
  dodging = 22,
  possession_chance = 50,
  max_hp = 125,
  perception = 9,
  aggression = 50,
  notice_chance = 70,
  bravery=50,
  spells={'ink','waterdweller'},
  ranged_chance=50,
  color={r=150,g=150,b=100,a=255},
  animated=true,
  spritesheet=true,
  animation_time=0.15,
  image_max=4,
  image_name = "squid1",
  image_varieties=3,
}
monsters['squid'] = squid

local hydromancer = {
  name="hydromancer",
  description = "The art of hydromancy was thought lost, but apparently there are still some practitioners.",
  symbol = "h",
  types={"intelligent","human"},
  nameType = "wizard",
  level = 2,
  strength = 5,
  possession_chance=55,
  max_hp=65,
  melee = 15,
  dodging = 18,
  perception = 8,
  aggression = 85,
  min_distance = 3,
  run_chance = 25,
  ranged_chance = 70,
  bravery=40,
  stealth=15,
  gender = 'either',
  spells = {'waterelemental','bubble'},
  color={r=0,g=87,b=132,a=255},
  animated=true,
  spritesheet=true,
  image_max=6,
  animation_time = 0.2,
  image_varieties=3
}
possibleMonsters['hydromancer'] = hydromancer

local waterelemental = {
  name = "water elemental",
  description = "A humanoid blob of water, given limited sentience through magical means.",
  symbol ="G",
  types={"swimmer","mindless","bloodless"},
  pathType="swimmer",
  ai_flags={"stubborn"},
  color={r=255,g=255,b=255},
  melee = 20,
  dodging = 0,
  perception=3,
  max_hp = 125,
  strength = 10,
  level = 3,
  speed=75,
  possession_chance = 1000,
  spells = {'sleepless'},
  neverSpawn = true,
  weaknesses={electricity=100,ice=25},
  resistances={fire=50,poison=100},
  animated=true,
  spritesheet=true,
  randomAnimation=true,
  animation_time=0.5,
  image_max=5,
  ignoreMasterPossession=true
}
possibleMonsters['waterelemental'] = waterelemental

local seamonster = {
  name = "leviathan",
  description = "A giant creature from the depths of the sea!",
  bossText = "As you begin to go up the stairs, you hear a roar behind you. A horrific sea monster rises from the depths!",
  symbol = "L",
  types={"swimmer"},
  ai_flags={"playerstalker"},
  pathType="swimmer",
  specialOnly=true,
  corpse=false,
  level = 4,
  strength = 18,
  melee = 40,
  dodging = 30,
  possession_chance=-1000,
  max_hp = 210,
  perception = 6,
  notice_chance = 60,
  aggression = 80,
  color={r=150,g=150,b=150},
  ranged_chance = 50,
  specialOnly = true,
  terrainLimit={'shallowwater','deepwater'},
  isBoss = true,
  animated=true,
  image_max=3,
  spritesheet=true,
  reverseAnimation=true,
  animation_time = 0.33
}
monsters['seamonster'] = seamonster

return monsters