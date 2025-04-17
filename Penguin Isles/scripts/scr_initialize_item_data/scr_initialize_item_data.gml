/// @function scr_initialize_item_data()
/// @description Defines all static item properties and populates the lookup maps.
///              Should be called ONLY ONCE at game start.
function scr_initialize_item_data() {

    show_debug_message("--- Running scr_initialize_item_data ---");

    // 1. Define Master Item Data Structure
    //    Using a struct where keys are item names. Each item has its properties.
    //    index: Numerical ID for inventory arrays/saving. MUST BE UNIQUE.
    //    type:  Equipment slot ("head", "face", "body", etc.) or "none" if not equippable.
    //    sprite: Sprite used when EQUIPPED (e.g., spr_player_betahat). Use 'undefined' or a placeholder for non-equippables if needed.
    //    object: Object created when DROPPED (e.g., obj_beta_hat). Use 'undefined' if item cannot be dropped as an object.
    //    inv_sprite: (Optional) Sprite specifically for inventory display (if different from equipped/drop). Defaults to using index on spr_inventory_items.
    //    price: (Optional) Cost in coins for shop system.
    //    description: (Optional) Text description for UI.
    global.item_definitions = {
        // Name             : { index: #, type: "slot/none", sprite: spr_,                object: obj_, /* optional... */ }
        "Beta Hat"          : { index: 0,  type: "head", sprite: spr_player_betahat,     object: obj_beta_hat },
        "Party Hat"         : { index: 1,  type: "head", sprite: spr_player_partyhat,    object: obj_party_hat },
        "Wrench"            : { index: 2,  type: "none", sprite: undefined,              object: obj_wrench_item },
        "Tube"              : { index: 3,  type: "none", sprite: undefined,              object: obj_tube },
        "Toboggan"          : { index: 4,  type: "none", sprite: undefined,              object: obj_toboggan },
        "Battery"           : { index: 5,  type: "none", sprite: undefined,              object: obj_battery },
        "Spy Phone"         : { index: 6,  type: "none", sprite: undefined,              object: obj_spyphone_item },
        "Broken Spy Phone"  : { index: 7,  type: "none", sprite: undefined,              object: obj_broken_spyphone_item },
        "EPF Phone"         : { index: 8,  type: "none", sprite: undefined,              object: obj_epfphone_item },
        "Fishing Rod"       : { index: 9,  type: "none", sprite: undefined,              object: obj_fishing_rod },
        "Jackhammer"        : { index: 10, type: "none", sprite: undefined,              object: obj_Jackhammer_item },
        "Snow Shovel"       : { index: 11, type: "none", sprite: undefined,              object: obj_snowshovel_item },
        "Pizza Slice"       : { index: 12, type: "none", sprite: undefined,              object: obj_pizzaslice_item },
        "Puffle O"          : { index: 13, type: "none", sprite: undefined,              object: obj_puffleo_item },
        "Box Puffle O"      : { index: 14, type: "none", sprite: undefined,              object: obj_boxpuffleo_item },
        "Fish"              : { index: 15, type: "none", sprite: undefined,              object: undefined },
        "Mullet"            : { index: 16, type: "none", sprite: undefined,              object: undefined },
        "Wood"              : { index: 17, type: "none", sprite: undefined,              object: obj_wood_item },
        "Snow"              : { index: 18, type: "none", sprite: undefined,              object: undefined },
        "Snow Blaster"      : { index: 19, type: "none", sprite: undefined,              object: obj_snowblaster_item },
        "Ghost Costume"     : { index: 20, type: "body", sprite: spr_ghostcostume_sheet, object: obj_ghostcostume_item },
        "Black Sun Glasses" : { index: 21, type: "face", sprite: spr_blkglasses_sheet,   object: obj_blacksunglasses_item },
        "Black Hoodie"      : { index: 22, type: "body", sprite: spr_blkhoodie_sheet,    object: obj_blackhoodie_item },
        "Miners Hard Hat"   : { index: 23, type: "head", sprite: spr_minerhat_sheet,     object: obj_minershardhat_item },
        "Tour Hat"          : { index: 24, type: "head", sprite: spr_tourhat_sheet,      object: obj_tourhat_item },
        // Add future items here following the { index: #, type: "", sprite: spr_, object: obj_ } format
    };
    show_debug_message("Defined global.item_definitions struct.");

    // 2. Ensure Helper Lookup Maps Exist (Create if they don't)
    //    These provide faster lookups and are used by existing code.
    if (!variable_global_exists("item_index_map") || !ds_exists(global.item_index_map, ds_type_map)) { global.item_index_map = ds_map_create(); show_debug_message("Created global.item_index_map");}
    if (!variable_global_exists("item_type_map") || !ds_exists(global.item_type_map, ds_type_map)) { global.item_type_map = ds_map_create(); show_debug_message("Created global.item_type_map");}
    if (!variable_global_exists("item_sprite_map") || !ds_exists(global.item_sprite_map, ds_type_map)) { global.item_sprite_map = ds_map_create(); show_debug_message("Created global.item_sprite_map");}
    if (!variable_global_exists("item_object_map") || !ds_exists(global.item_object_map, ds_type_map)) { global.item_object_map = ds_map_create(); show_debug_message("Created global.item_object_map");}
    show_debug_message("Ensured item lookup maps exist.");

    // 3. Clear and Populate Helper Maps from the Master Definition
    ds_map_clear(global.item_index_map);
    ds_map_clear(global.item_type_map);
    ds_map_clear(global.item_sprite_map);
    ds_map_clear(global.item_object_map);

    var item_names = variable_struct_get_names(global.item_definitions);
    for (var i = 0; i < array_length(item_names); i++) {
        var name = item_names[i];
        var data = global.item_definitions[$ name]; // Get the struct for this item

        // Populate index map (Name -> Index)
        // Essential for inventory array which stores indices
        if (variable_struct_exists(data, "index")) {
            ds_map_add(global.item_index_map, name, data.index);
        } else {
            show_debug_message("CRITICAL WARNING: Item '" + name + "' missing 'index' property!");
        }

        // Populate type map (Name -> Slot Type)
        // Used for equipping items to the correct slot
        if (variable_struct_exists(data, "type") && data.type != "none") {
            ds_map_add(global.item_type_map, name, data.type);
        }

        // Populate sprite map (Name -> Sprite Resource for EQUIPPED view)
        // Used by player draw event
        if (variable_struct_exists(data, "sprite") && !is_undefined(data.sprite)) {
            if (sprite_exists(data.sprite)) {
                 ds_map_add(global.item_sprite_map, name, data.sprite);
            } else {
                 show_debug_message("WARNING: Sprite " + string(data.sprite) + " for item '" + name + "' does not exist!");
                 // Maybe add a default/placeholder sprite here?
                 // ds_map_add(global.item_sprite_map, name, spr_placeholder_item);
            }
        }

        // Populate object map (Name -> Object Resource for DROPPED view)
        // Used by inventory_drop_active_item
        if (variable_struct_exists(data, "object") && !is_undefined(data.object)) {
            if (object_exists(data.object)) {
                 ds_map_add(global.item_object_map, name, data.object);
            } else {
                show_debug_message("WARNING: Object " + object_get_name(data.object) + " for item '" + name + "' does not exist!");
                 // Maybe add a default/placeholder object?
                 // ds_map_add(global.item_object_map, name, obj_generic_dropped_item);
            }
        }
    }
    show_debug_message("Populated item lookup maps (Index, Type, Sprite, Object).");
    show_debug_message("--- Finished scr_initialize_item_data ---");
}