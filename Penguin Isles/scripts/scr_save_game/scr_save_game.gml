/// @function save_game()
/// @description Saves the current game state to savegame.sav
function save_game() {
    show_debug_message("--- Running save_game ---");

    // Ensure all necessary global structures exist
    if (!ds_exists(global.room_states, ds_type_map)) global.room_states = ds_map_create();

    var _current_room_name = room_get_name(room);
    var _state_array = [];

    // Collect state from all savable instances
    with (all) {
        if (object_index == obj_controller || object_index == obj_ui_manager) continue;

        if (variable_instance_exists(id, "is_savable") && is_savable) {
            var _state_data = {
                object_index_name: object_get_name(object_index),
                x: x, y: y,
                image_xscale: image_xscale ?? 1,
                image_yscale: image_yscale ?? 1,
                image_blend: image_blend ?? c_white,
                image_alpha: image_alpha ?? 1,
            };
            array_push(_state_array, _state_data);
        }
    }
	
    // Update global.room_states
    if (ds_map_exists(global.room_states, _current_room_name)) {
        var _old_data = ds_map_find_value(global.room_states, _current_room_name);
        if (is_array(_old_data)) {
            // No need to destroy arrays, just replace them
            ds_map_replace(global.room_states, _current_room_name, _state_array);
        }
    } else {
        ds_map_add(global.room_states, _current_room_name, _state_array);
    }

    show_debug_message("Saved room state for: " + _current_room_name);


    // --- Prepare Data Structures for Saving ---
    var _equipped_items_struct = ds_map_to_struct_recursive(global.equipped_items);

    show_debug_message("save_game: Manually converting global.room_states map (containing arrays) to struct...");
    var _room_states_struct = {};
    var _map_keys = ds_map_keys_to_array(global.room_states);
    for (var i = 0; i < array_length(_map_keys); i++) {
        var _key = _map_keys[i];
        var _value = ds_map_find_value(global.room_states, _key);
        if (is_array(_value)) {
             _room_states_struct[$ _key] = array_clone_recursive(_value);
        } else {
            show_debug_message("save_game WARNING: Expected array for room '" + _key + "', found " + typeof(_value) + ". Storing empty array.");
            _room_states_struct[$ _key] = [];
        }
    }
    show_debug_message("save_game: Finished manually converting room states.");

    var _following_puffles_array = ds_list_to_array_recursive(global.following_puffles); // Placeholder
    var _active_quests_array = ds_list_to_array_recursive(global.active_quests);
    var _completed_quests_array = ds_list_to_array_recursive(global.completed_quests);

    // --- REMOVED: Intermediate inventory variable assignment ---
    // var _inventory_to_save = global.inventory; // REMOVED

    // --- Prepare Main Save Data Struct ---
		var _save_data = {
        save_format_version: "1.3.2", // Increment version for inventory fix
        save_timestamp: date_current_datetime(),
        game_state: {
            inventory: array_duplicate(global.inventory),
			room_states: ds_map_to_struct_recursive(global.room_states),
            player_data: {
                x: global.player_instance.x,
                y: global.player_instance.y,
                face: variable_instance_exists(global.player_instance, "face") ? global.player_instance.face : DOWN,
                skin: global.current_skin,
                color: global.player_color,
             },
            current_room_name: _current_room_name,
            // *** CHANGE: Clone the inventory array directly here ***
            equipped_items: _equipped_items_struct,
            following_puffles: _following_puffles_array,
            active_quests: _active_quests_array,
            completed_quests: _completed_quests_array,
            repair_complete_flag: global.repair_complete ?? false,
            // Add other global vars
        }
    };

    // *** ADDED: Debug log to show inventory state *just before* stringify ***
    var _inv_debug_str = "Save Game DEBUG: Inventory state before stringify: [";
    // Ensure global.inventory exists and is an array before trying to access it
    if (variable_global_exists("inventory") && is_array(global.inventory)) {
        for(var i=0; i<min(10, array_length(global.inventory)); i++) {
             _inv_debug_str += string(global.inventory[i]) + ",";
        }
        if(array_length(global.inventory) > 10) { _inv_debug_str += "..."; }
    } else {
        _inv_debug_str += "ERROR: global.inventory is missing or not an array!";
    }
     _inv_debug_str += "]";
     show_debug_message(_inv_debug_str);
     // *** END DEBUG LOG ***


    // --- Convert to JSON and Save ---
    var _json_string = json_stringify(_save_data);

    // File writing and cleanup
    if (_json_string == "") { /* error msg */ return; }
    var _file = file_text_open_write("savegame.sav");
    if (_file != -1) {
	file_text_write_string(_file, _json_string);
	file_text_close(_file);
        show_debug_message("Game saved successfully to savegame.sav (using inv clone)."); // Update log
    } else { /* error msg */ }

    show_debug_message("Game saved successfully.");
}