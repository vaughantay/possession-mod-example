local sunkencity = {}
sunkencity.creatures={'electriceel','merfolkhunter','squid','sharkman','hydromancer'}
sunkencity.genericName = "The Sunken City"
sunkencity.boss="seamonster"
sunkencity.tileset="sunkencity"
sunkencity.depth=4
sunkencity.description="Long ago, a magnificent city sank beneath the waves. It has now begun to re-emerge."
function sunkencity.generateName()
  return "The Sunken City"
end
function sunkencity.create(map,width,height)
  --First, we'll use a layout generator to create a basic layout for the map.
  --In this case, we're using the "bsptree" layout, which creates a series of rooms connected by corridors.
  --The arguments passed after the map, width, and height, are: The % chance that doors will be added between rooms and corridors (0%), the % chance that corridors will be wide (50%), and the % chance that rooms will be forced to be rectangular (10%).
  --This function returns two tables, one with the coordinates of the rooms, and one with the coordinates of the hallways.
  local rooms,hallways = layouts['bsptree'](map,width,height,0,50,10)
  
  --These values will be used later to determine which room is the biggest, which will be used as the boss room.
  --(This isn't necessary for all special levels. Many layouts will assign the upward stairs on their own, and if they don't, they'll be placed semi-randomly far away from each other.)
  local biggestSize, biggestRoom = 0,nil
   
  --Next, we're going to loop through all tiles. If they're not a floor, we'll assign them the value "p." At the end, we'll add water to any tiles marked "p."
  --(We don't do it now because some of these tiles will eventually become walls or other things.)
  for x = 2, width-1, 1 do
		for y=2, height-1, 1 do
      if map[x][y] ~= "." then map[x][y] = "p" end
    end
  end
  
  --Next, we're going to loop through all the rooms and do stuff to them.
  for id, room in ipairs(rooms) do
    --If this is bigger than the previous biggest room, keep track of it for later
    local roomW,roomH = room.maxX-room.minX,room.maxY-room.minY
    if roomW*roomH>biggestSize then
      biggestSize = roomW*roomH
      biggestRoom = id
    end
    
    --Put the walls back in the room:
    for _, wall in pairs(room.walls) do
      if map[wall.x][wall.y] ~= "." then
        if random(1,3) ~= 1 then
          map[wall.x][wall.y] = "#"
        elseif random(1,3) == 1 then
          local bw = Feature('brokenwall',nil,wall.x,wall.y)
          map[wall.x][wall.y] = bw
          bw.image_base = "brokenwhitewall"
        else
          --We'll be looking at map tiles assigned as "b" later. They might be empty, or become water.
          map[wall.x][wall.y] = "b"
        end
      end
    end --end wall for
  end --end room for
  
  --Next, we're going to loop through all the rooms and figure out which room is the farthest away from the biggest room, and use that as the entrance room.
  local farthestDist,farthestRoom = 0,nil
  for _, room in ipairs(rooms) do
    --We're using calc_distance_squared() for speed since the actual distance isn't important, only as a comparison to other distances. We're also being lazy and just comparing the top left corner of each room rather than the center (it's good enough for our purposes)
    local dist = calc_distance_squared(room.minX,room.minY,rooms[biggestRoom].minX,rooms[biggestRoom].minY)
    if dist > farthestDist then
      farthestDist = dist
      farthestRoom = room
    end
  end
  
  --These next three lines designate the room as the "entrance" room in the rooms table, and designate the room in its own definition as being the entrance.
  rooms.entrance.entrance = nil
  rooms.entrance = farthestRoom
  farthestRoom.entrance = true
  --Randomly pick a tile in the room, and set it in the stairs. Notably, we just set the map's stairsDown values, the mapgen code will add the stairs itself.
  local downX,downY = (farthestRoom.maxX-farthestRoom.minX)/2,(farthestRoom.maxY-farthestRoom.minY)/2
  map.stairsDown.x,map.stairsDown.y = farthestRoom.minX+(random(1,2) == 1 and math.ceil(downX) or math.floor(downX)), farthestRoom.minY+(random(1,2) == 1 and math.ceil(downY) or math.floor(downY))
  map:clear_tile(map.stairsDown.x,map.stairsDown.y) --Gotta make sure there's nothing on the tile!
  
  --Now we look through all the tiles again. Anything marked as "b" will either be set to an empty space or shallow water.
  for x=2,width-1,1 do
    for y=2,height-1,1 do
      if map[x][y] == "b" then -- broken wall
        if random(1,2) == 1 then
          map[x][y] = "."
        else
          map[x][y] = "p"
        end
        --Add broken walls to the wall tiles next to the empty space:
        for nx=x-1,x+1,1 do
          for ny=y-1,y+1,1 do
            if nx > 1 and ny > 1 and nx < map.width and ny < map.height and (nx == x or ny == y) and map[nx][ny] == "#" then
              local bw = Feature('brokenwall',nil,nx,ny)
              map[nx][ny] = bw
              bw.image_base = "brokenwhitewall"
            end
          end -- end for ny
        end --end for nx
      end --end if p or b check
    end --end forx
  end --end fory
  
  --Loop through each room and add some room decorations:
  for _, room in ipairs(rooms) do
    local outdoors = (random(1,5) == 1 and true or false)
    if outdoors and room ~= rooms[biggestRoom] then
      --Loop through the walls in each "outdoors" room and remove them:
      for _, wall in pairs(room.walls) do
        map[wall.x][wall.y] = "."
        if random(1,5) == 1 then --randomly put columns in
          local pillar = true
          for wx = wall.x-1,wall.x+1,1 do
            for wy=wall.y-1,wall.y+1,1 do
              if map:tile_has_feature(wx,wy,'flutedcolumn') then
                pillar = false
                break --break out of the wx loop
              end
            end --end wy for
            if pillar == false then
              break --break out of the wy loop
            end
          end --end wx for
          if pillar then
            map:add_feature(Feature('flutedcolumn'),wall.x,wall.y)
          end
        end --end if random(1,5) == 1
      end --end wall for
    end
  end --end room for
  
  --Put in boss room:
  local bossRoom = rooms[biggestRoom]
  local midX = bossRoom.minX+(random(1,2) == 1 and math.floor((bossRoom.maxX-bossRoom.minX)/2) or math.ceil((bossRoom.maxX-bossRoom.minX)/2))
  local midY = bossRoom.minY+(random(1,2) == 1 and math.floor((bossRoom.maxY-bossRoom.minY)/2) or math.ceil((bossRoom.maxY-bossRoom.minY)/2))
  map.bossRoom={minX=bossRoom.minX,maxX=bossRoom.maxX,minY=bossRoom.minY,maxY=bossRoom.maxY}
  --Loop through each of the tiles in the boss room. If it's the middle tile, add the upward stairs. If it's not, make it water.
  for x=bossRoom.minX,bossRoom.maxX,1 do
    for y = bossRoom.minY,bossRoom.maxY,1 do
      if x==midX and y==midY then --middle square
        map.stairsUp.x,map.stairsUp.y = x,y
      else
        map[x][y] = "p"
      end --end x/y ifs
    end --end fory
  end --end forx
  
  --Loop through all the hallways, and turn some of their tiles into water.
  for _,hallway in pairs(hallways) do
    for _,tile in pairs(hallway.base) do
        map[tile.x][tile.y] = "p" 
    end --end tile for
    if hallway.wide then
      for _,tile in pairs(hallway.base) do
          map[tile.x][tile.y] = "p" 
      end --end tile for
    end
  end --end hallway for
  
  --Finally, loop through all tiles one last time. If they're marked as p, turn them into water. If all the surrounding tiles are water, turn them into deep water.
  for x=2,width-1,1 do
    for y=2,height-1,1 do
      if map[x][y] == "p" then
        local deep = true --We will default this to true. If it's still true after checking the border tiles, we'll make it deep, otherwise shallow
        --Check all the tiles bordering this tile to see if they're water
        for xBorder=x-1,x+1,1 do
          for yBorder=y-1,y+1,1 do
            if map[xBorder][yBorder] ~= "p" and map[xBorder][yBorder] ~= "#" and not map:tile_has_feature(xBorder,yBorder,'shallowwater') and not map:tile_has_feature(xBorder,yBorder,'deepwater') then
              deep = false
              break --break out of the loop, because the rest of this doesn't matter
            end
            --Check at the end of the xBorder for loop to see if we need to break out of it too
            if deep == false then
              break
            end
          end --end yBorder for
        end --end xBorder for
        if deep then
          map:change_tile(Feature('deepwater'),x,y)
        else
          local water = map:change_tile(Feature('shallowwater'),x,y)
          water.walkedOnImage = "shallowwaterwadingwhitetiles"
          if random(1,10) == 1 then
            map:add_feature(Feature('seaweed'),x,y)
          end
        end --end deep or not if
      end --end if map == p
    end --end fory
  end --end forx
  
  --This function makes the edges of the map interesting by adding some jaggedness
  mapgen:makeEdges(map,width,height,"shallowwater") 
end --end function

return {sunkencity=sunkencity}