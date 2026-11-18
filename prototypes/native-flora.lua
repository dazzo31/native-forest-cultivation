local seconds = 60
local growth_ticks = 5 * seconds * 60

local gleba_flora = {
  {source = "cuttlepop", tint = {r = 0.95, g = 0.45, b = 0.60, a = 1}},
  {source = "slipstack", tint = {r = 0.65, g = 0.80, b = 0.90, a = 1}},
  {source = "funneltrunk", tint = {r = 0.85, g = 0.55, b = 0.30, a = 1}},
  {source = "hairyclubnub", tint = {r = 0.70, g = 0.50, b = 0.85, a = 1}},
  {source = "teflilly", tint = {r = 0.35, g = 0.80, b = 0.75, a = 1}},
  {source = "lickmaw", tint = {r = 0.80, g = 0.25, b = 0.25, a = 1}},
  {source = "stingfrond", tint = {r = 0.70, g = 0.90, b = 0.35, a = 1}},
  {source = "boompuff", tint = {r = 0.95, g = 0.85, b = 0.35, a = 1}},
  {source = "sunnycomb", tint = {r = 0.95, g = 0.65, b = 0.25, a = 1}},
  {source = "water-cane", tint = {r = 0.45, g = 0.85, b = 0.45, a = 1}}
}

local nauvis_trees = {
  "tree-01", "tree-02", "tree-03", "tree-04", "tree-05",
  "tree-06", "tree-07", "tree-08", "tree-09"
}

local gleba_pressure = 2000

local new_prototypes = {}

local function add(prototype)
  new_prototypes[#new_prototypes + 1] = prototype
end

local function assign_surface(sprite, surface)
  if not sprite then
    return
  end
  if sprite.layers then
    for _, layer in ipairs(sprite.layers) do
      assign_surface(layer, surface)
    end
  else
    sprite.surface = surface
  end
end

-- The plant sprite-table builder dereferences every variation's normal map unconditionally
-- (PlantPrototype assignSortingIndices), so a source missing normals segfaults the engine
-- during atlas post-build.
local function has_normals(source)
  for _, variation in ipairs(source.variations or {}) do
    if not variation.normal then
      return false
    end
  end
  return true
end

local function merge_emissions(entity, target_emissions)
  if not entity then return end
  local current = entity.emissions_per_second or {}
  local new_emissions = table.deepcopy(current)
  for pollutant, rate in pairs(target_emissions) do
    if new_emissions[pollutant] == nil or new_emissions[pollutant] > rate then
      new_emissions[pollutant] = rate
    end
  end
  entity.emissions_per_second = new_emissions
end

-- Cultivate Gleba native crops using vanilla tree-seed:
-- crops drop native products and wood to sustain tree-seed crafting.
local function register_gleba_crop(entry)
  local source = assert(data.raw.tree[entry.source], "Missing native flora prototype: " .. entry.source)
  local crop_name = "native-flora-" .. entry.source .. "-crop"
  local growth_template = assert(data.raw.plant["tree-plant"], "Space Age planted-tree prototype is required")

  local crop = table.deepcopy(source)
  crop.type = "plant"
  crop.name = crop_name
  crop.localised_name = {"entity-name.native-flora-crop", {"entity-name." .. entry.source}}
  crop.autoplace = {probability_expression = 0}
  crop.surface_conditions = {{property = "pressure", min = gleba_pressure, max = gleba_pressure}}
  crop.growth_ticks = growth_ticks
  crop.harvest_emissions = {spores = 1}
  crop.emissions_per_second = {spores = -0.05, pollution = -0.005}
  crop.agricultural_tower_tint = {primary = entry.tint, secondary = {r = 0.45, g = 0.35, b = 0.20, a = 1}}

  -- Gleba crops drop native products and wood for crafting seeds (Space Age wood loop)
  local crop_results = {}
  local has_wood = false
  for _, prod in ipairs(source.minable.results or {}) do
    if prod.name == "wood" then
      crop_results[#crop_results + 1] = {type = "item", name = "wood", amount = math.max(prod.amount or 1, 4)}
      has_wood = true
    elseif prod.name ~= "tree-seed" then
      crop_results[#crop_results + 1] = table.deepcopy(prod)
    end
  end
  if not has_wood then
    crop_results[#crop_results + 1] = {type = "item", name = "wood", amount = 4}
  end

  crop.minable = {mining_time = 0.5, results = crop_results}
  crop.dying_explosion = nil
  crop.remains_when_mined = nil
  crop.created_effect = nil

  for _, variation in ipairs(crop.variations) do
    assign_surface(variation.trunk, "gleba")
    assign_surface(variation.leaves, "gleba")
    assign_surface(variation.normal, "gleba")
    assign_surface(variation.shadow, "gleba")
    if variation.water_reflection then
      assign_surface(variation.water_reflection.pictures, "gleba")
    end
  end

  crop.growth_variations = {}
  crop.growth_mounds = {}
  for index = 1, #crop.variations do
    local growth_variation = table.deepcopy(growth_template.growth_variations[(index - 1) % #growth_template.growth_variations + 1])
    for _, field in ipairs({"growth_warp", "trunk_warp", "shadow_warp", "harvest_warp", "trunk_alpha", "shadow_alpha", "harvest_alpha"}) do
      assign_surface(growth_variation[field], "gleba")
    end
    crop.growth_variations[index] = growth_variation

    local growth_mound = table.deepcopy(growth_template.growth_mounds[(index - 1) % #growth_template.growth_mounds + 1])
    assign_surface(growth_mound, "gleba")
    crop.growth_mounds[index] = growth_mound
  end
  add(crop)
end

for _, entry in ipairs(gleba_flora) do
  if data.raw.tree[entry.source] then
    merge_emissions(data.raw.tree[entry.source], {spores = -0.05, pollution = -0.005})
  end
  if has_normals(data.raw.tree[entry.source]) then
    register_gleba_crop(entry)
  else
    log("native-forest-cultivation: skipping " .. entry.source .. " (variations lack normal maps, unsupported by plant rendering)")
  end
end

for _, source_name in ipairs(nauvis_trees) do
  if data.raw.tree[source_name] then
    merge_emissions(data.raw.tree[source_name], {pollution = -0.005})
  end
end

-- Extend tree-plant so single vanilla tree-seed can be planted on Gleba fertile soils
if data.raw.plant["tree-plant"] then
  local tree_plant = data.raw.plant["tree-plant"]
  merge_emissions(tree_plant, {pollution = -0.005, spores = -0.05})
  if tree_plant.surface_conditions then
    for _, cond in ipairs(tree_plant.surface_conditions) do
      if cond.property == "pressure" then
        cond.max = gleba_pressure
      end
    end
  end

  if tree_plant.autoplace and tree_plant.autoplace.tile_restriction then
    local gleba_soils = {
      "natural-yumako-soil", "artificial-yumako-soil", "overgrowth-yumako-soil",
      "natural-jellynut-soil", "artificial-jellynut-soil", "overgrowth-jellynut-soil",
      "wetland-yumako", "wetland-jellynut",
      "lowland-cream-cauliflower", "lowland-cream-cauliflower-2",
      "lowland-cream-red", "lowland-pale-green",
      "lowland-dead-skin", "lowland-dead-skin-2",
      "lowland-red-vein", "lowland-red-vein-2", "lowland-red-vein-3", "lowland-red-vein-4", "lowland-red-vein-dead",
      "lowland-olive-blubber", "lowland-olive-blubber-2", "lowland-olive-blubber-3",
      "lowland-brown-blubber", "lowland-red-infection",
      "midland-cracked-lichen", "midland-cracked-lichen-dull", "midland-cracked-lichen-dark",
      "midland-turquoise-bark", "midland-turquoise-bark-2",
      "midland-yellow-crust", "midland-yellow-crust-2", "midland-yellow-crust-3", "midland-yellow-crust-4",
      "wetland-green-slime", "wetland-light-green-slime", "wetland-blue-slime",
      "wetland-dead-skin", "wetland-light-dead-skin",
      "wetland-pink-tentacle", "wetland-red-tentacle"
    }
    local existing = {}
    for _, tile in ipairs(tree_plant.autoplace.tile_restriction) do
      existing[tile] = true
    end
    for _, tile in ipairs(gleba_soils) do
      if data.raw.tile[tile] and not existing[tile] then
        table.insert(tree_plant.autoplace.tile_restriction, tile)
      end
    end
  end
end

-- Allow tree-seed recipe (2 wood -> 1 tree-seed) to be crafted on Gleba
if data.raw.recipe["tree-seed"] then
  local recipe = data.raw.recipe["tree-seed"]
  if recipe.surface_conditions then
    for _, cond in ipairs(recipe.surface_conditions) do
      if cond.property == "pressure" then
        cond.max = gleba_pressure
      end
    end
  end
end

data:extend(new_prototypes)
