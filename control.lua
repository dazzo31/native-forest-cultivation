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

local gleba_crop_to_tree = {
  ["native-flora-cuttlepop-crop"] = "cuttlepop",
  ["native-flora-slipstack-crop"] = "slipstack",
  ["native-flora-funneltrunk-crop"] = "funneltrunk",
  ["native-flora-hairyclubnub-crop"] = "hairyclubnub",
  ["native-flora-teflilly-crop"] = "teflilly",
  ["native-flora-lickmaw-crop"] = "lickmaw",
  ["native-flora-stingfrond-crop"] = "stingfrond",
  ["native-flora-boompuff-crop"] = "boompuff",
  ["native-flora-sunnycomb-crop"] = "sunnycomb",
  ["native-flora-water-cane-crop"] = "water-cane",
}

local nauvis_tree_names = {
  "tree-01", "tree-02", "tree-03", "tree-04", "tree-05",
  "tree-06", "tree-07", "tree-08", "tree-09"
}

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

local function is_nauvis_surface(surface)
  if not (surface and surface.valid) then
    return false
  end
  if surface.name == "nauvis" then
    return true
  end
  if surface.planet and surface.planet.name == "nauvis" then
    return true
  end
  return false
end

local function is_managed_crop_for_surface(crop_name, surface)
  if not (crop_name and surface and surface.valid) then
    return false
  end
  if is_nauvis_surface(surface) then
    return crop_name == "tree-plant"
  elseif is_gleba_surface(surface) then
    return gleba_crop_to_tree[crop_name] ~= nil
  end
  return false
end

local function get_tree_for_crop(crop_name, surface, position)
  if not (surface and surface.valid) then
    return nil
  end

  if is_nauvis_surface(surface) then
    if crop_name == "tree-plant" then
      local idx = (math.abs(math.floor(position.x * 7 + position.y * 13)) % #nauvis_tree_names) + 1
      return nauvis_tree_names[idx]
    end
    return "tree-08"
  elseif is_gleba_surface(surface) then
    if gleba_crop_to_tree[crop_name] then
      return gleba_crop_to_tree[crop_name]
    end
    -- Fallback based on soil tile strictly to Gleba flora (NEVER Nauvis trees)
    local tile = surface.get_tile(math.floor(position.x), math.floor(position.y))
    local mapped_crop = (tile and gleba_soil_map[tile.name]) or default_gleba_crop
    return gleba_crop_to_tree[mapped_crop] or "cuttlepop"
  end
  return nil
end

local function get_standing_delay_ticks()
  local setting = settings.global["native-forest-standing-delay"]
  local delay_minutes = setting and setting.value or 5.0
  if delay_minutes <= 0 then
    return 0
  end
  return math.floor(delay_minutes * 60 * 60)
end

local function schedule_crop_maturity(crop)
  if not (crop and crop.valid) then
    return
  end
  local surface = crop.surface
  if not is_managed_crop_for_surface(crop.name, surface) then
    return
  end

  local mature_tick = crop.tick_grown
  if not mature_tick or mature_tick <= game.tick then
    return
  end

  storage.mature_schedule = storage.mature_schedule or {}
  storage.mature_schedule[mature_tick] = storage.mature_schedule[mature_tick] or {}
  table.insert(storage.mature_schedule[mature_tick], crop)
end

local function handle_planted_entity(entity, event)
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

  local pos = entity.position

  -- 1. Gleba: Swap tree-plant to the native soil-specific Gleba crop
  if is_gleba_surface(surface) then
    local tile = surface.get_tile(math.floor(pos.x), math.floor(pos.y))
    local crop_name = (tile and gleba_soil_map[tile.name]) or default_gleba_crop

    entity.destroy()
    local new_crop = surface.create_entity{
      name = crop_name,
      position = pos,
      force = "neutral",
      spill = false
    }
    if new_crop and new_crop.valid then
      schedule_crop_maturity(new_crop)
    end
    return
  end

  -- 2. Nauvis: Tree-plant remains as the native cultivateable tree plant.
  if is_nauvis_surface(surface) then
    schedule_crop_maturity(entity)
    return
  end

  -- 3. Strict Surface Whitelisting: Any other surface (Carna, Vulcanus, Fulgora, Aquilo, space platform, modded planets)
  -- Destroy tree-plant immediately to prevent cross-planet ecosystem corruption.
  entity.destroy()

  -- Refund seed to player if manually planted
  if event and event.player_index then
    local player = game.get_player(event.player_index)
    if player and player.valid then
      local inserted = player.insert{name = "tree-seed", count = 1}
      if inserted < 1 then
        surface.spill_item_stack{
          position = pos,
          stack = {name = "tree-seed", count = 1},
          enable_looted = true,
          force = player.force
        }
      end
      player.create_local_flying_text{
        text = {"message.tree-seed-native-only"},
        position = pos
      }
      return
    end
  end

  -- If planted by tower, robot, or script: spill seed on ground
  surface.spill_item_stack{
    position = pos,
    stack = {name = "tree-seed", count = 1},
    enable_looted = true
  }
end

local function on_tower_planted_seed(event)
  handle_planted_entity(event.plant, event)
end

local function on_entity_built(event)
  local entity = event.entity
  if entity and entity.valid and entity.name == "tree-plant" then
    handle_planted_entity(entity, event)
  end
end

local function on_tick(event)
  local current_tick = event.tick

  -- 1. Process mature crops reaching adulthood: transition to standing trees
  if storage.mature_schedule and storage.mature_schedule[current_tick] then
    local crops = storage.mature_schedule[current_tick]
    storage.mature_schedule[current_tick] = nil

    local delay_ticks = get_standing_delay_ticks()
    if delay_ticks > 0 then
      storage.harvest_schedule = storage.harvest_schedule or {}
      local harvest_tick = current_tick + delay_ticks
      storage.harvest_schedule[harvest_tick] = storage.harvest_schedule[harvest_tick] or {}

      for _, crop in ipairs(crops) do
        if crop and crop.valid then
          local crop_name = crop.name
          local surface = crop.surface
          local pos = crop.position

          -- Verify it is strictly a managed crop for this surface
          if is_managed_crop_for_surface(crop_name, surface) then
            local tree_name = get_tree_for_crop(crop_name, surface, pos)
            if tree_name then
              crop.destroy()
              local tree = surface.create_entity{
                name = tree_name,
                position = pos,
                force = "neutral",
                spill = false
              }
              if tree and tree.valid then
                table.insert(storage.harvest_schedule[harvest_tick], {
                  entity = tree,
                  crop_name = crop_name,
                  surface = surface,
                  position = pos
                })
              end
            end
          end
        end
      end
    end
  end

  -- 2. Process standing trees whose standing duration has expired: transition to harvestable crop
  if storage.harvest_schedule and storage.harvest_schedule[current_tick] then
    local items = storage.harvest_schedule[current_tick]
    storage.harvest_schedule[current_tick] = nil

    for _, item in ipairs(items) do
      local tree = item.entity
      if tree and tree.valid then
        local surface = tree.surface
        local pos = tree.position
        local crop_name = item.crop_name

        if is_managed_crop_for_surface(crop_name, surface) then
          tree.destroy()
          local crop = surface.create_entity{
            name = crop_name,
            position = pos,
            force = "neutral",
            spill = false
          }
          if crop and crop.valid then
            crop.tick_grown = 0 -- mature! ready for tower crane harvest
          end
        end
      end
    end
  end
end

local function init_storage()
  storage.mature_schedule = storage.mature_schedule or {}
  storage.harvest_schedule = storage.harvest_schedule or {}
end

local function on_configuration_changed()
  init_storage()

  -- 1. Purge unmanaged crops from storage.mature_schedule
  if storage.mature_schedule then
    for tick, list in pairs(storage.mature_schedule) do
      local filtered = {}
      for _, crop in ipairs(list) do
        if crop and crop.valid and is_managed_crop_for_surface(crop.name, crop.surface) then
          table.insert(filtered, crop)
        end
      end
      if #filtered > 0 then
        storage.mature_schedule[tick] = filtered
      else
        storage.mature_schedule[tick] = nil
      end
    end
  end

  -- 2. Purge unmanaged crops from storage.harvest_schedule & restore vanilla crops if replaced
  if storage.harvest_schedule then
    for tick, list in pairs(storage.harvest_schedule) do
      local filtered = {}
      for _, item in ipairs(list) do
        local tree = item.entity
        local surface = item.surface or (tree and tree.valid and tree.surface)
        local crop_name = item.crop_name
        local pos = item.position or (tree and tree.valid and tree.position)

        if surface and surface.valid and is_managed_crop_for_surface(crop_name, surface) then
          table.insert(filtered, item)
        else
          -- This was an unmanaged crop (e.g. jellystem, yumako-tree, or tree-plant on Gleba)
          if tree and tree.valid then
            tree.destroy()
          end
          -- Restore vanilla plant if it was jellystem or yumako-tree
          if surface and surface.valid and pos and (crop_name == "jellystem" or crop_name == "yumako-tree") then
            local restored = surface.create_entity{
              name = crop_name,
              position = pos,
              force = "neutral"
            }
            if restored and restored.valid then
              restored.tick_grown = 0
            end
          end
        end
      end
      if #filtered > 0 then
        storage.harvest_schedule[tick] = filtered
      else
        storage.harvest_schedule[tick] = nil
      end
    end
  end

  -- 3. Scan Gleba surfaces: Remove any misplaced Nauvis trees (tree-01..tree-09, tree-plant)
  for _, surface in pairs(game.surfaces) do
    if is_gleba_surface(surface) then
      for _, tname in ipairs(nauvis_tree_names) do
        local bad_trees = surface.find_entities_filtered{name = tname}
        for _, tree in ipairs(bad_trees) do
          local pos = tree.position
          local tile = surface.get_tile(math.floor(pos.x), math.floor(pos.y))
          tree.destroy()

          if tile and string.find(tile.name, "jellynut") then
            local restored = surface.create_entity{
              name = "jellystem",
              position = pos,
              force = "neutral"
            }
            if restored and restored.valid then
              restored.tick_grown = 0
            end
          elseif tile and string.find(tile.name, "yumako") then
            local restored = surface.create_entity{
              name = "yumako-tree",
              position = pos,
              force = "neutral"
            }
            if restored and restored.valid then
              restored.tick_grown = 0
            end
          else
            local crop_name = (tile and gleba_soil_map[tile.name]) or default_gleba_crop
            local gleba_tree = gleba_crop_to_tree[crop_name] or "cuttlepop"
            surface.create_entity{
              name = gleba_tree,
              position = pos,
              force = "neutral"
            }
          end
        end
      end

      -- Also handle any tree-plant that may have been placed on Gleba
      local stray_tree_plants = surface.find_entities_filtered{name = "tree-plant"}
      for _, tp in ipairs(stray_tree_plants) do
        local pos = tp.position
        local tile = surface.get_tile(math.floor(pos.x), math.floor(pos.y))
        local crop_name = (tile and gleba_soil_map[tile.name]) or default_gleba_crop
        tp.destroy()
        local new_crop = surface.create_entity{
          name = crop_name,
          position = pos,
          force = "neutral",
          spill = false
        }
        if new_crop and new_crop.valid then
          schedule_crop_maturity(new_crop)
        end
      end
    end
  end

  -- 4. Re-scan active surfaces ONLY for valid managed crops:
  -- Nauvis: only tree-plant
  -- Gleba: only native-flora-*-crop
  for _, surface in pairs(game.surfaces) do
    if is_nauvis_surface(surface) then
      local plants = surface.find_entities_filtered{name = "tree-plant"}
      for _, plant in ipairs(plants) do
        if plant.valid and plant.tick_grown and plant.tick_grown > game.tick then
          schedule_crop_maturity(plant)
        end
      end
    elseif is_gleba_surface(surface) then
      for crop_name, _ in pairs(gleba_crop_to_tree) do
        local crops = surface.find_entities_filtered{name = crop_name}
        for _, crop in ipairs(crops) do
          if crop.valid and crop.tick_grown and crop.tick_grown > game.tick then
            schedule_crop_maturity(crop)
          end
        end
      end
    end
  end
end

if not remote.interfaces["native_forest_cultivation"] then
  remote.add_interface("native_forest_cultivation", {
    schedule_crop = function(crop, mature_tick)
      if crop and crop.valid then
        crop.tick_grown = mature_tick
        schedule_crop_maturity(crop)
        return true
      end
      return false
    end,
    reschedule_harvest = function(original_tick, new_tick)
      if storage.harvest_schedule and storage.harvest_schedule[original_tick] then
        local items = storage.harvest_schedule[original_tick]
        storage.harvest_schedule[original_tick] = nil
        storage.harvest_schedule[new_tick] = storage.harvest_schedule[new_tick] or {}
        for _, it in ipairs(items) do
          table.insert(storage.harvest_schedule[new_tick], it)
        end
        return true
      end
      return false
    end,
    get_standing_delay_ticks = get_standing_delay_ticks,
    run_migration = on_configuration_changed
  })
end

script.on_init(init_storage)
script.on_configuration_changed(on_configuration_changed)
script.on_event(defines.events.on_tick, on_tick)
script.on_event(defines.events.on_tower_planted_seed, on_tower_planted_seed)
script.on_event(defines.events.on_built_entity, on_entity_built)
script.on_event(defines.events.on_robot_built_entity, on_entity_built)
script.on_event(defines.events.script_raised_built, on_entity_built)
