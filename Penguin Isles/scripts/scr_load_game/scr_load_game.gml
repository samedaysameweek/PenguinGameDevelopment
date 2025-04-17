/// @function load_game()
/// @description Loads the game state from savegame.sav
function load_game() {
    show_debug_message("--- Running load_game ---");

    // Check for save file
    if (!file_exists("savegame.sav")) {
        show_debug_message("Load Game: No save file found.");
        return false;
    }

    // Read save file
    var file = file_text_open_read("savegame.sav");
    if (file == -1) {
        show_debug_message("Load Game ERROR: Failed to open save file.");
        return false;
    }
    var json_string = file_text_read_string(file);
    file_text_close(file);

    var save_data = noone; // Initialize save_data

    // --- Attempt to Parse JSON ---
    try {
        save_data = json_parse(json_string);
        if (!is_struct(save_data)) {
             throw "Parsed data is not a struct.";
        }
    } catch (_error) {
        show_debug_message("Load Game FATAL ERROR: Failed to parse save file JSON: " + string(_error));
        // Optionally attempt backup load here
        return false; // Stop loading
    }

    // --- Load Data within Try/Catch for robustness ---
    try {
        // Validate save data version
        if (!variable_struct_exists(save_data, "version")) {
            throw "Save file missing version information";
        }
        if (save_data.version != "1.0.0") {
            show_debug_message("Load Game WARNING: Save file version mismatch. Attempting to load anyway.");
            // Add version migration logic here in the future if needed
        }

        // *** Set Loading Flag ***
        global.is_loading_game = true;
        show_debug_message("Load Game: Set global.is_loading_game = true");

        // --- Ensure Global Structures Exist (Crucial before loading into them) ---
        // (These should ideally also be checked/created in init_globals, but good safety here)
        if (!variable_global_exists("room_states") || !ds_exists(global.room_states, ds_type_map)) { global.room_states = ds_map_create(); }
        if (!variable_global_exists("active_quests") || !ds_exists(global.active_quests, ds_type_list)) { global.active_quests = ds_list_create(); }
        if (!variable_global_exists("completed_quests") || !ds_exists(global.completed_quests, ds_type_list)) { global.completed_quests = ds_list_create(); }
        if (!variable_global_exists("equipped_items") || !ds_exists(global.equipped_items, ds_type_map)) { global.equipped_items = ds_map_create(); /* Add default empty slots */ }
        if (!variable_global_exists("inventory") || !is_array(global.inventory)) { global.inventory = array_create(42, -1); }

        // Default target room if loading fails partially
        global.target_room = rm_welcome_room;

        // --- Load Game State ---
        if (variable_struct_exists(save_data, "game_state")) {
            var game_state = save_data.game_state;

            // Load target room
            if (variable_struct_exists(game_state, "current_room")) {
                var loaded_room = game_state.current_room;
                if (room_exists(loaded_room)) {
                    global.target_room = loaded_room;
                    show_debug_message("Load Game: Target room set to " + room_get_name(global.target_room));
                } else {
                    show_debug_message("Load Game WARNING: Saved room ID " + string(loaded_room) + " does not exist! Defaulting to Welcome Room.");
                    global.target_room = rm_welcome_room;
                }
            }

            // --- Load Inventory ---
            if (variable_struct_exists(game_state, "inventory")) {
                var loaded_inv = game_state.inventory;
                if (is_array(loaded_inv)) {
                    global.inventory = array_clone(loaded_inv); // Clone loaded data
                } else {
                    show_debug_message("WARNING: Invalid inventory data format. Initializing empty inventory.");
                    global.inventory = array_create(42, -1); // Initialize empty inventory
                }
            }

            // --- Deserialize Room States ---
            if (variable_struct_exists(game_state, "room_states")) {
                var loaded_room_states = game_state.room_states;
                if (is_struct(loaded_room_states)) {
                    global.room_states = ds_map_create();
                    for (var k = ds_map_find_first(loaded_room_states); k != noone; k = ds_map_find_next(loaded_room_states, k)) {
                        var room_name = k;
                        var room_data = loaded_room_states[room_name];
                        if (is_array(room_data)) {
                            for (var j = 0; j < array_length(room_data); j++) {
                                var obj_data = room_data[j];
                                var inst = instance_create_layer(obj_data.x, obj_data.y, "Instances", obj_data.object_index);
                                ds_map_to_struct(inst, obj_data.properties);
                            }
                        }
                    }
                } else {
                    show_debug_message("WARNING: Invalid room state data format.");
                }
            }
        }
    } catch (_error) {
        show_debug_message("Load Game ERROR during data loading: " + string(_error));
    }

    global.is_loading_game = false;
    show_debug_message("--- Finished load_game ---");
    return true;
}