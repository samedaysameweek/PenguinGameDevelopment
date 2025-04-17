// Save Game Function
function save_game() {
    // --- Pre-checks (Good practice) ---
    if (!instance_exists(global.player_instance)) {
        show_debug_message("Error: Cannot save - player instance not found.");
        return;
    }
    if (!variable_global_exists("inventory")) {
        show_debug_message("Warning: global.inventory not initialized before save. Creating empty.");
        global.inventory = array_create(42, -1); // Or your defined size
    }
    if (!ds_exists(global.equipped_items, ds_type_map)) {
        show_debug_message("ERROR: global.equipped_items map does not exist before save. Cannot save items.");
        // Decide how to handle this - maybe create an empty map?
        global.equipped_items = ds_map_create(); // Create empty map to avoid crash
        // Add default empty slots if desired
        ds_map_add(global.equipped_items, "head", -1);
        ds_map_add(global.equipped_items, "face", -1);
        ds_map_add(global.equipped_items, "neck", -1);
        ds_map_add(global.equipped_items, "body", -1);
        ds_map_add(global.equipped_items, "hand", -1);
        ds_map_add(global.equipped_items, "feet", -1);
    }
     if (!ds_exists(global.room_states, ds_type_map)) {
         show_debug_message("Warning: global.room_states map does not exist before save. Creating empty.");
         global.room_states = ds_map_create();
     }
     if (!ds_exists(global.active_quests, ds_type_list)) {
         show_debug_message("Warning: global.active_quests list does not exist before save. Creating empty.");
         global.active_quests = ds_list_create();
     }
     if (!ds_exists(global.completed_quests, ds_type_list)) {
         show_debug_message("Warning: global.completed_quests list does not exist before save. Creating empty.");
         global.completed_quests = ds_list_create();
     }

    save_room_state(room); // Ensure the current room's state is saved
    // --- Construct Save Data Struct ---
    var save_data = {
        version: "1.0.0",

		player: {
		    x: global.player_instance.x,
		    y: global.player_instance.y,
		    skin: global.current_skin,
		    color: {
		        r: color_get_red(global.player_color),
		        g: color_get_green(global.player_color),
		        b: color_get_blue(global.player_color)
		    },
		    face: variable_instance_get(global.player_instance, "face"),
		    inventory: global.inventory,
		    expanded_hud_open: variable_global_exists("expanded_hud_open") ? global.expanded_hud_open : false,
		    equipped_items: ds_map_to_struct(global.equipped_items)
		},

// Ensure game_state is created correctly
    game_state: {
         current_room: room, // Save the current room ID

         // Convert room_states map (of ds_lists) to a struct (of arrays) for JSON
         room_states: (function() {
             var _rooms_struct = {}; // Renamed for clarity
             if (ds_exists(global.room_states, ds_type_map)) {
                 var _room_key = ds_map_find_first(global.room_states);
                 while (!is_undefined(_room_key)) {
                     var _state_list_id = ds_map_find_value(global.room_states, _room_key);
                     if (ds_exists(_state_list_id, ds_type_list)) {
                         // Convert the ds_list of instance state structs into an array of structs
                         _rooms_struct[$ _room_key] = ds_list_to_array(_state_list_id);
                     } else {
                         show_debug_message("Save Warning: Invalid ds_list found in room_states for key: " + string(_room_key));
                         _rooms_struct[$ _room_key] = []; // Save empty array as fallback
                     }
                     _room_key = ds_map_find_next(global.room_states, _room_key);
                 }
             } else {
                  show_debug_message("Save Warning: global.room_states map does not exist during save.");
             }
             return _rooms_struct; // Return the fully built struct
         })(), // Immediately call the inline function

         // Convert lists to arrays for JSON compatibility
         active_quests: ds_list_to_array(global.active_quests),
         completed_quests: ds_list_to_array(global.completed_quests)
             // Add other game state vars here if needed
        },

        following_puffles: [], // Keep this structure for puffles

        objects: {} // Keep this structure for specific objects
    };
    
    show_debug_message("Saving current_room: " + room_get_name(save_data.game_state.current_room) + " (ID: " + string(save_data.game_state.current_room) + ")");

	// Populate objects with existence and removal checks
	save_data.objects = {};
	var object_types = [
	    { name: "icetruck", obj: obj_icetruck },
	    { name: "tube", obj: obj_tube },
	    { name: "toboggan", obj: obj_toboggan }
	];
	for (var i = 0; i < array_length(object_types); i++) {
	    var ot = object_types[i];
	    if (object_exists(ot.obj)) {
	        var inst = instance_find(ot.obj, 0);
	        if (instance_exists(inst)) {
	            save_data.objects[$ ot.name] = {
	                x: inst.x,
	                y: inst.y,
	                exists: true
	            };
	        } else {
	            save_data.objects[$ ot.name] = { exists: false };
	        }
	    } else {
	        save_data.objects[$ ot.name] = { exists: false };
	        show_debug_message("Save Game: Object " + ot.name + " no longer exists in project.");
	    }
	}

    // Handle following puffles
    for (var i = 0; i < ds_list_size(global.following_puffles); i++) {
        var puffle = global.following_puffles[| i];
        if (instance_exists(puffle)) {
            var puffle_state = {
                x: puffle.x,
                y: puffle.y,
                color: puffle.color,
                state: puffle.state
            };
            array_push(save_data.following_puffles, puffle_state);
        }
    }

    // --- Convert to JSON and Save ---
    var json = json_stringify(save_data);
    var file = file_text_open_write("savegame.sav");
    if (file != -1) {
        file_text_write_string(file, json);
        file_text_close(file);
        show_debug_message("Game saved successfully.");
        // Optional: Create a backup
        // file_copy("savegame.sav", "savegame.bak");
    } else {
        show_debug_message("Error: Failed to open savegame.sav for writing.");
    }
}

// --- Helper Functions (Ensure these are defined HERE or globally, but not duplicated) ---
function ds_map_to_struct(map_id) {
    var _struct = {};
    if (ds_exists(map_id, ds_type_map)) {
        var _key = ds_map_find_first(map_id);
        while (!is_undefined(_key)) {
            var _value = ds_map_find_value(map_id, _key);
             // Ensure value is JSON-compatible
             if (is_struct(_value) || is_array(_value) || is_real(_value) || is_string(_value) || is_bool(_value) || is_undefined(_value)) {
                 _struct[$ _key] = _value;
             } else {
                 show_debug_message("ds_map_to_struct: Converting unsupported value type for key '" + string(_key) + "' to string.");
                 _struct[$ _key] = string(_value); // Convert unsupported to string as fallback
             }
            _key = ds_map_find_next(map_id, _key);
        }
    } else {
        show_debug_message("Warning: ds_map_to_struct called with non-existent map ID: " + string(map_id));
    }
    return _struct;
}

// Add this helper function if it's missing from scr_save_game.gml
function ds_list_to_array(list_id) {
    var _arr = [];
    if (ds_exists(list_id, ds_type_list)) {
        for (var i = 0; i < ds_list_size(list_id); i++) {
            var _value = ds_list_find_value(list_id, i);
            // Ensure value is JSON-compatible (structs/arrays/primitives)
            if (is_struct(_value) || is_array(_value) || is_real(_value) || is_string(_value) || is_bool(_value) || is_undefined(_value)) {
               array_push(_arr, _value);
           } else {
               show_debug_message("ds_list_to_array: Converting unsupported value type at index " + string(i) + " to string.");
               array_push(_arr, string(_value)); // Convert unsupported to string as fallback
           }
        }
    } else {
        show_debug_message("Warning: ds_list_to_array called with non-existent list ID: " + string(list_id));
    }
    return _arr;
}