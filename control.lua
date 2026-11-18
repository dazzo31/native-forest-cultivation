local gleba_soil_map = {
  -- Cultivatable soils
  ["natural-yumako-soil"] = "native-flora-cuttlepop-crop",
  ["artificial-yumako-soil"] = "native-flora-cuttlepop-crop",
  ["overgrowth-yumako-soil"] = "native-flora-cuttlepop-crop",
  ["natural-jellynut-soil"] = "native-flora-teflilly-crop",
  ["artificial-jellynut-soil"] = "native-flora-teflilly-crop",
  ["overgrowth-jellynut-soil"] = "native-flora-teflilly-crop",

  -- Wetlands: Cuttlepop, Teflilly, Water-cane
  ["wetland-yumako"] = "native-flora-cuttlepop-crop",
  ["wetland-jellynut"] = "native-flora-cuttlepop-crop",
  ["wetland-pink-tentacle"] = "native-flora-cuttlepop-crop",
  ["wetland-red-tentacle"] = "native-flora-cuttlepop-crop",
  ["wetland-green-slime"] = "native-flora-teflilly-crop",
  ["wetland-light-green-slime"] = "native-flora-teflilly-crop",
  ["wetland-blue-slime"] = "native-flora-teflilly-crop",
  ["wetland-dead-skin"] = "native-flora-water-cane-crop",
  ["wetland-light-dead-skin"] = "native-flora-water-cane-crop",

  -- Lowlands: Slipstack, Funneltrunk, Hairy clubnub, Lickmaw, Boompuff, Water-cane
  ["lowland-cream-cauliflower"] = "native-flora-slipstack-crop",
  ["lowland-cream-cauliflower-2"] = "native-flora-slipstack-crop",
  ["lowland-red-vein"] = "native-flora-funneltrunk-crop",
  ["lowland-red-vein-2"] = "native-flora-funneltrunk-crop",
  ["lowland-red-vein-3"] = "native-flora-funneltrunk-crop",
  ["lowland-red-vein-4"] = "native-flora-funneltrunk-crop",
  ["lowland-red-vein-dead"] = "native-flora-funneltrunk-crop",
  ["lowland-olive-blubber"] = "native-flora-hairyclubnub-crop",
  ["lowland-olive-blubber-2"] = "native-flora-hairyclubnub-crop",
  ["lowland-olive-blubber-3"] = "native-flora-hairyclubnub-crop",
  ["lowland-brown-blubber"] = "native-flora-lickmaw-crop",
  ["lowland-red-infection"] = "native-flora-lickmaw-crop",
  ["lowland-cream-red"] = "native-flora-boompuff-crop",
  ["lowland-pale-green"] = "native-flora-boompuff-crop",
  ["lowland-dead-skin"] = "native-flora-water-cane-crop",
  ["lowland-dead-skin-2"] = "native-flora-water-cane-crop",

  -- Midlands: Stingfrond, Sunnycomb
  ["midland-cracked-lichen"] = "native-flora-stingfrond-crop",
  ["midland-cracked-lichen-dull"] = "native-flora-stingfrond-crop",
  ["midland-cracked-lichen-dark"] = "native-flora-stingfrond-crop",
  ["midland-yellow-crust"] = "native-flora-sunnycomb-crop",
  ["midland-yellow-crust-2"] = "native-flora-sunnycomb-crop",
  ["midland-yellow-crust-3"] = "native-flora-sunnycomb-crop",
  ["midland-yellow-crust-4"] = "native-flora-sunnycomb-crop",
  ["midland-turquoise-bark"] = "native-flora-sunnycomb-crop",
  ["midland-turquoise-bark-2"] = "native-flora-sunnycomb-crop",
}

local default_gleba_crop = "native-flora-cuttlepop-crop"

local function is_gleba_surface(surface)
  if not (surface and surface.valid) then
    return false
  end
  if surface.name == "gleba" then
    return true
  end
  if surface.planet and surface.planet.name == "gleba" then
    return true
  end
  return false
end

local function handle_planted_entity(entity)
  if not (entity and entity.valid) then
    return
  end
  if entity.name ~= "tree-plant" then
    return
  end

  local surface = entity.surface
  if not (surface and surface.valid) then
    return
  end

  -- If planted on Gleba, swap to the native soil-specific Gleba crop
  if is_gleba_surface(surface) then
    local pos = entity.position
    local tile = surface.get_tile(math.floor(pos.x), math.floor(pos.y))
    local crop_name = (tile and gleba_soil_map[tile.name]) or default_gleba_crop

    entity.destroy()

    surface.create_entity{
      name = crop_name,
      position = pos,
      force = "neutral",
      spill = false
    }
  end
  -- On Nauvis, tree-plant remains as the native cultivateable tree plant.
end

local function on_tower_planted_seed(event)
  handle_planted_entity(event.plant)
end

local function on_entity_built(event)
  local entity = event.entity
  if entity and entity.valid and entity.name == "tree-plant" then
    handle_planted_entity(entity)
  end
end

script.on_event(defines.events.on_tower_planted_seed, on_tower_planted_seed)
script.on_event(defines.events.on_built_entity, on_entity_built)
script.on_event(defines.events.on_robot_built_entity, on_entity_built)
script.on_event(defines.events.script_raised_built, on_entity_built)
