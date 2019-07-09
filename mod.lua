--When loading a mod, the game sets the working directory to the mod's folder. When you load files, you only need to worry about their path within the mod's folder
--Content doesn't *need* to be in external file, I just prefer it to make things more organized
local creatures = require "content.creatures"
local conditions = require "content.conditions"
local effects = require "content.effects"
local features = require "content.features"
local levels = require "content.levels"
local projectiles = require "content.projectiles"
local spells = require "content.spells"
local tilesets = require "content.tilesets"

local nameLists = {}
local nameGenerators = {}

--You don't actually need to create an entire name generator if it's just for one creature, you can create a nameGen() function in the creature definition itself.  See the Sharkman for an example
--But this is an example of what a new name generator could look like

--First, we'll define lists that will then be added to the global nameGen.lists
--You could just define the name parts you're going to use in the generator function itself, but defining them in a list makes them accessible and extensible by others (if someone wanted to make a mod for your mod?)
nameLists.merfolkLast1 = {"aqua","bath","brine","blue","bubble","carp","coral","damp","fish","flood","gill","humid","hydro","kelp","lake","ocean","reef","salt","sea","shark","shoal","soak","sog","soggy","splash","storm","tide","wash","water","wet"}
nameLists.merfolkLast2 = {"bottom","breeze","bringer","bubble","coral","current","drench","fish","fisher","fjord","floe","folk","ford","friend","gush","healer","knower","lake","lover","mann","pond","reef","rinse","ripple","sea","shoal","son","splash","spray","ston","stone","squirt","storm","tide","unit","volk","wash","water","watcher","wave"}

--Now we create the function itself. This will be added to the global nameGen as well
--Function name should generally take the format generate_XYZ_name, which will let it be used from a creature definition using the attribute nameType="XYZ" (see the merfolk hunter for example)
function nameGenerators:generate_merfolk_name(creat)
  local a = namegen:get_from_list('merfolkLast1')
  local b = namegen:get_from_list('merfolkLast2')
  --Some words repeat in the various lists, so we'll ensure that we're not using the same word twice:
  while a == b do
    b = namegen:get_from_list('merfolkLast2')
  end
  return namegen:generate_first_name(creat) .. " " .. ucfirst(a .. b)
end

--You don't have to return all these values, if there's no actual content assigned to them. This is just a list of all the things that it's possible to pass to the game
return {ai=ai,conditions=conditions,creatures=creatures,damage_types=damage_types,effects=effects,features=features,layouts=layouts,levels=levels,levelModifiers=levelModifiers,nameGenerators=nameGenerators,nameLists=nameLists,projectiles=projectiles,rangedAttacks=rangedAttacks,roomDecorators=roomDecorators,rooms=rooms,spells=spells,tilesets=tilesets}