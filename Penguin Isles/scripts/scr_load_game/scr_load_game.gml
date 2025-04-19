/// @function load_game()
/// @description Loads the game state from savegame.sav
/// @returns {Bool} True if loading was successful, false otherwise.
function load_game() {
    show_debug_message("--- Running load_game ---");
    var _load_successful = false;

    // --- 1. Check for and Read Save File ---
    if (!file_exists("savegame.sav")) {
        show_debug_message("Load Game: No save file found.");
        return false;
    }

    var _file = file_text_open_read("savegame.sav");
    if (_file == -1) {
        show_debug_message("Load Game ERROR: Failed to open save file.");
        return false;
    }
    var _json_string = "";
    while (!file_text_eof(_file)) { // Read the whole file
        _json_string += file_text_readln(_file);
    }
    file_text_close(_file);

    if (_json_string == "") {
        show_debug_message("Load Game ERROR: Save file is empty.");
        return false;
    }

    // --- 2. Parse JSON Data ---
    var _load_data = json_parse(_json_string);

    if (!is_struct(_load_data)) {
        show_debug_message("Load Game FATAL ERROR: Failed to parse save file JSON or root is not a struct.");
        return false; // Stop loading
    }

    // --- 3. Validate Save Data Structure and Version ---
    try {
        if (!variable_struct_exists(_load_data, "save_format_version")) throw "Save data missing 'save_format_version'.";
        var _save_version = _load_data.save_format_version;
        show_debug_message("Load Game: Found save version: " + _save_version);
        // ... (version compatibility checks) ...

        if (!variable_struct_exists(_load_data, "game_state")) throw "Save data missing 'game_state' struct.";
        var _game_state = _load_data.game_state;
        if (!is_struct(_game_state)) throw "'game_state' is not a struct.";

        // *** Set Loading Flag ***
        if (!variable_global_exists("is_loading_game") || !global.is_loading_game) {
             show_debug_message("Load Game: Setting global.is_loading_game = true");
             global.is_loading_game = true;
        }

        // --- 4. Ensure Core Global Structures Exist BEFORE loading into them ---
        if (!variable_global_exists("inventory") || !is_array(global.inventory)) {
            show_debug_message("Load Game Init: Initializing global.inventory.");
            global.inventory = array_create(INVENTORY_SIZE, -1);
        }
        if (!variable_global_exists("equipped_items") || !ds_exists(global.equipped_items, ds_type_map)) {
             show_debug_message("Load Game Init: Initializing global.equipped_items.");
             global.equipped_items = ds_map_create();
             ds_map_add(global.equipped_items, "head", -1); ds_map_add(global.equipped_items, "face", -1); ds_map_add(global.equipped_items, "neck", -1);
             ds_map_add(global.equipped_items, "body", -1); ds_map_add(global.equipped_items, "hand", -1); ds_map_add(global.equipped_items, "feet", -1);
        }
         if (!variable_global_exists("room_states") || !ds_exists(global.room_states, ds_type_map)) {
             show_debug_message("Load Game Init: Initializing global.room_states.");
             global.room_states = ds_map_create();
         }
         if (!variable_global_exists("active_quests") || !ds_exists(global.active_quests, ds_type_list)) {
             show_debug_message("Load Game Init: Initializing global.active_quests.");
             global.active_quests = ds_list_create();
         }
         if (!variable_global_exists("completed_quests") || !ds_exists(global.completed_quests, ds_type_list)) {
             show_debug_message("Load Game Init: Initializing global.completed_quests.");
             global.completed_quests = ds_list_create();
         }
         if (!variable_global_exists("following_puffles") || !ds_exists(global.following_puffles, ds_type_list)) {
             show_debug_message("Load Game Init: Initializing global.following_puffles.");
             global.following_puffles = ds_list_create();
         }

        // --- 5. Restore Game State ---

        // -- Restore Player Data --
        if (!variable_struct_exists(_game_state, "player_data")) throw "Game state missing 'player_data'.";
        var _player_data = _game_state.player_data;
        if (!is_struct(_player_data)) throw "'player_data' is not a struct.";
        global.player_x = _player_data.x ?? 100;
        global.player_y = _player_data.y ?? 100;
        global.last_player_face = _player_data.face ?? DOWN;
        global.current_skin = _player_data.skin ?? "player";
        global.player_color = _player_data.color ?? c_white;
        global.last_player_color = global.player_color;
        show_debug_message("Load Game: Restored player data (Pos: " + string(global.player_x) + "," + string(global.player_y) + " Skin: " + global.current_skin + ")");


        // -- Restore Target Room --
        if (!variable_struct_exists(_game_state, "current_room_name")) throw "Game state missing 'current_room_name'.";
        var _room_name = _game_state.current_room_name;
        var _room_id = asset_get_index(_room_name);
        if (room_exists(_room_id)) {
            global.target_room = _room_id;
            show_debug_message("Load Game: Target room set to " + _room_name);
        } else {
            show_debug_message("Load Game WARNING: Saved room '" + _room_name + "' does not exist! Defaulting to Welcome Room.");
            global.target_room = rm_welcome_room;
        }

        // -- Restore Inventory --
        if (!variable_struct_exists(_game_state, "inventory")) throw "Game state missing 'inventory'.";
        var _loaded_inv = _game_state.inventory;
        if (is_array(_loaded_inv)) {
             // *** DEBUG: Print the raw loaded inventory array ***
             var _debug_inv_str = "Load Game DEBUG: Raw loaded inventory array: [";
             for(var i=0; i<min(10, array_length(_loaded_inv)); i++) { _debug_inv_str += string(_loaded_inv[i]) + ","; }
             if(array_length(_loaded_inv) > 10) _debug_inv_str += "...";
             _debug_inv_str += "]";
             show_debug_message(_debug_inv_str);
             // *** END DEBUG ***

            var _copy_length = min(array_length(_loaded_inv), INVENTORY_SIZE);
            if (!variable_global_exists("inventory") || !is_array(global.inventory) || array_length(global.inventory) != INVENTORY_SIZE) {
                 global.inventory = array_create(INVENTORY_SIZE, -1);
            }
            show_debug_message("Load Game: Copying " + string(_copy_length) + " inventory items from save...");
            for (var i = 0; i < _copy_length; i++) {
                 global.inventory[i] = is_real(_loaded_inv[i]) ? _loaded_inv[i] : -1; // Assign item index or -1
            }
             for (var i = _copy_length; i < INVENTORY_SIZE; i++) { // Ensure remaining slots are empty
                 global.inventory[i] = -1;
             }
            show_debug_message("Load Game: Inventory array copy complete.");

             // <<< DEBUG: VERBOSE LOG OF FINAL GLOBAL INVENTORY >>>
             show_debug_message("Load Game DEBUG: Final Global Inventory Contents:");
             var _inv_string = "";
             for (var i=0; i < INVENTORY_SIZE; i++){
                 _inv_string += "["+string(i)+":"+string(global.inventory[i])+"]";
                 if ((i+1) % 10 == 0) { // Print every 10 slots
                     show_debug_message(_inv_string);
                     _inv_string = "";
                 } else if (i < INVENTORY_SIZE - 1) {
                    _inv_string += ", ";
                 }
             }
             if (_inv_string != "") show_debug_message(_inv_string); // Print remaining slots
             // <<< END DEBUG >>>

        } else {
            throw "Invalid 'inventory' data format (not an array).";
        }

        // -- Restore Equipped Items --
        if (!variable_struct_exists(_game_state, "equipped_items")) throw "Game state missing 'equipped_items'.";
        var _loaded_equipped = _game_state.equipped_items;
        if (is_struct(_loaded_equipped)) {
            if (ds_exists(global.equipped_items, ds_type_map)) ds_map_destroy(global.equipped_items); // Destroy old map
            global.equipped_items = ds_map_create(); // Create new empty map
            var _keys = variable_struct_get_names(_loaded_equipped);
            for (var i=0; i<array_length(_keys); i++) {
                 var _key = _keys[i];
                 ds_map_add(global.equipped_items, _key, _loaded_equipped[$ _key]); // Copy data
            }
             show_debug_message("Load Game: Restored equipped items map.");
        } else {
             throw "Invalid 'equipped_items' data format (not a struct).";
        }

        // -- Restore Room States -- (REVISED)
        if (!variable_struct_exists(_game_state, "room_states")) throw "Game state missing 'room_states'.";
        var _loaded_room_states_struct = _game_state.room_states; // This is the structure { room_name: [ {state_struct}, ... ], ... }

        if (is_struct(_loaded_room_states_struct)) {
            show_debug_message("Load Game: Reconstructing global.room_states DS Map with *arrays* of state structs...");

            // 1. Destroy the old DS map structure if it exists
            if (ds_exists(global.room_states, ds_type_map)) {
                var _old_keys = ds_map_keys_to_array(global.room_states);
                for(var i = 0; i < array_length(_old_keys); i++) {
                    // If the map contained DS List IDs previously, destroy them
                    var _old_list = ds_map_find_value(global.room_states, _old_keys[i]);
                    if(ds_exists(_old_list, ds_type_list)) {
                        ds_list_destroy(_old_list);
                    }
                     // If it contained arrays, no explicit destroy needed for the array itself
                }
                ds_map_destroy(global.room_states); // Destroy the old map container
            }

            // 2. Create the new top-level DS Map
            global.room_states = ds_map_create();
            if (!ds_exists(global.room_states, ds_type_map)) {
                 throw "Failed to create global.room_states DS Map during load!";
            }

            // 3. Iterate through the loaded struct (keys are room names)
            var _room_names = variable_struct_get_names(_loaded_room_states_struct);
            for (var i = 0; i < array_length(_room_names); i++) {
                var _room_name_key = _room_names[i];
                var _loaded_object_array = _loaded_room_states_struct[$ _room_name_key]; // Get the array of state structs for this room

                // 4. Store the loaded array *directly* into the DS map
                if (is_array(_loaded_object_array)) {
                    ds_map_add(global.room_states, _room_name_key, _loaded_object_array); // <-- Store the array itself
                    show_debug_message("  - Stored state *array* for room '" + _room_name_key + "' (Size: " + string(array_length(_loaded_object_array)) + ")");
                } else {
                    // If the data wasn't an array as expected, store an empty array
                    show_debug_message("Load Game WARNING: Data for room '" + _room_name_key + "' in save file was not an array. Storing empty array.");
                    ds_map_add(global.room_states, _room_name_key, []); // Store an empty array
                }
            }
             show_debug_message("Load Game: Finished reconstructing global.room_states map (now contains arrays).");

        } else {
             throw "Invalid 'room_states' data format (not a struct).";
        }

        // -- Restore Quests --
         if (variable_struct_exists(_game_state, "active_quests")) {
             var _loaded_active_q = _game_state.active_quests;
             if (is_array(_loaded_active_q)) {
                  if (ds_exists(global.active_quests, ds_type_list)) ds_list_clear(global.active_quests);
                  else global.active_quests = ds_list_create();
                  for (var i = 0; i < array_length(_loaded_active_q); i++) ds_list_add(global.active_quests, _loaded_active_q[i]);
                  show_debug_message("Load Game: Restored active quests list.");
             } else show_debug_message("Load Game Warning: Invalid 'active_quests' format.");
         }
        if (variable_struct_exists(_game_state, "completed_quests")) {
             var _loaded_comp_q = _game_state.completed_quests;
             if (is_array(_loaded_comp_q)) {
                 if (ds_exists(global.completed_quests, ds_type_list)) ds_list_clear(global.completed_quests);
                  else global.completed_quests = ds_list_create();
                  for (var i = 0; i < array_length(_loaded_comp_q); i++) ds_list_add(global.completed_quests, _loaded_comp_q[i]);
                 show_debug_message("Load Game: Restored completed quests list.");
             } else show_debug_message("Load Game Warning: Invalid 'completed_quests' format.");
         }

        // -- Restore Other Global Flags --
        if (variable_struct_exists(_game_state, "repair_complete_flag")) {
             global.repair_complete = _game_state.repair_complete_flag;
         } else { global.repair_complete = false; }
         // Add restoration for other saved global flags here...

         _load_successful = true;

    } catch (_error) {
        show_debug_message("Load Game ERROR during data loading: " + string(_error));
         try { show_message("Error loading game:\n" + string(_error)); } catch (ex) {} // Show user feedback if possible
        _load_successful = false;
    }


    // --- 6. Finalization ---
    if (_load_successful) {
        show_debug_message("--- Finished load_game (Success) ---");
    } else {
        show_debug_message("--- Finished load_game (Failed) ---");
         global.is_loading_game = false; // Reset flag on failure
    }
     if (is_struct(_load_data)) { _load_data = noone; } // Clean up parsed data

    return _load_successful;
}