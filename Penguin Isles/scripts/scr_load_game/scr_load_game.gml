/// @function load_game()
/// @description Loads the game state from savegame.sav
/// @returns {Bool} True if loading was successful, false otherwise.
function load_game() {
    show_debug_message("--- Running load_game ---");
    var _load_successful = false;
    var _load_data = undefined; // Initialize to ensure scope

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
    try { // Wrap file reading in try...catch
        while (!file_text_eof(_file)) {
            _json_string += file_text_readln(_file);
        }
    } catch (_err) {
        show_debug_message("Load Game ERROR: Exception during file read: " + string(_err));
        file_text_close(_file); // Ensure file is closed on error
        return false;
    } finally {
        if (_file != -1) file_text_close(_file); // Ensure file is closed normally
    }


    if (_json_string == "") {
        show_debug_message("Load Game ERROR: Save file is empty or read failed.");
        return false;
    }

    // --- 2. Parse JSON Data (with error check) ---
    try {
         _load_data = json_parse(_json_string);
    } catch (_parse_error) {
         show_debug_message("Load Game ERROR: Failed to parse JSON string: " + string(_parse_error));
         try { show_message_async("Failed to load save data:\nInvalid format."); } catch (ex) {}
         return false; // Exit if JSON is invalid
    }

    // --- NEW: Validate _load_data structure ---
    if (!is_struct(_load_data)) {
        show_debug_message("Load Game ERROR: Parsed data is not a struct. Data: " + string(_load_data));
         try { show_message_async("Failed to load save data:\nIncorrect structure."); } catch (ex) {}
        return false; // Exit if not a struct
    }
    // --- END NEW VALIDATION ---


    // --- 3. Validate Save Data Structure and Version ---
    // Use try...catch for the entire loading process for safety
    try {
        // *** CHECK INVENTORY EXISTENCE AND TYPE ***
        // Original crash point validation
        if (!variable_struct_exists(_load_data, "inventory") || !is_array(_load_data.inventory)) {
            // This specific check might now be redundant due to later checks,
            // but kept for clarity on the original crash point.
            // We'll rely on the check within the main game_state section later.
             show_debug_message("Load Game NOTE: Initial check for root-level 'inventory' array (may be outdated format or nested now).");
            // Do NOT throw error here yet, proceed to check game_state
        }
        // *** END CHECK ***


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
        // (Your existing init checks seem fine here)
        if (!variable_global_exists("inventory") || !is_array(global.inventory)) {
            show_debug_message("Load Game Init: Initializing global.inventory.");
            global.inventory = array_create(INVENTORY_SIZE, -1);
        }
        if (!variable_global_exists("equipped_items") || !ds_exists(global.equipped_items, ds_type_map)) {
             show_debug_message("Load Game Init: Initializing global.equipped_items.");
             if (variable_global_exists("equipped_items") && ds_exists(global.equipped_items, ds_type_map)) ds_map_destroy(global.equipped_items);
             global.equipped_items = ds_map_create();
             ds_map_add(global.equipped_items, "head", -1); ds_map_add(global.equipped_items, "face", -1); ds_map_add(global.equipped_items, "neck", -1);
             ds_map_add(global.equipped_items, "body", -1); ds_map_add(global.equipped_items, "hand", -1); ds_map_add(global.equipped_items, "feet", -1);
        }
         if (!variable_global_exists("room_states") || !ds_exists(global.room_states, ds_type_map)) {
             show_debug_message("Load Game Init: Initializing global.room_states.");
              if (variable_global_exists("room_states") && ds_exists(global.room_states, ds_type_map)) ds_map_destroy(global.room_states);
             global.room_states = ds_map_create();
         }
         // (Add similar checks for active_quests, completed_quests, following_puffles if needed)


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
        global.last_player_color = global.player_color; // Ensure last_player_color is updated on load
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
            global.target_room = rm_welcome_room; // Choose a safe default
        }

        // -- Restore Inventory --
        // <<< MOVE THE INVENTORY EXISTENCE CHECK HERE >>>
        if (!variable_struct_exists(_game_state, "inventory")) throw "Game state missing 'inventory'.";
        var _loaded_inv = _game_state.inventory;
        // <<< ADD is_array CHECK HERE >>>
        if (!is_array(_loaded_inv)) {
            throw "Invalid 'inventory' data format (not an array).";
        }
        // Now we know _loaded_inv exists and is an array
        var _debug_inv_str = "Load Game DEBUG: Raw loaded inventory array: [";
        for(var i=0; i<min(10, array_length(_loaded_inv)); i++) { _debug_inv_str += string(_loaded_inv[i]) + ","; }
        if(array_length(_loaded_inv) > 10) _debug_inv_str += "...";
        _debug_inv_str += "]";
        show_debug_message(_debug_inv_str);

        var _copy_length = min(array_length(_loaded_inv), INVENTORY_SIZE);
        if (!variable_global_exists("inventory") || !is_array(global.inventory) || array_length(global.inventory) != INVENTORY_SIZE) {
             global.inventory = array_create(INVENTORY_SIZE, -1);
        }
        show_debug_message("Load Game: Copying " + string(_copy_length) + " inventory items from save...");
        for (var i = 0; i < _copy_length; i++) {
             // Sanitize input: Ensure we only store numbers (indices) or -1
             global.inventory[i] = (is_real(_loaded_inv[i]) && _loaded_inv[i] >= -1) ? floor(_loaded_inv[i]) : -1;
        }
        for (var i = _copy_length; i < INVENTORY_SIZE; i++) { // Ensure remaining slots are empty
             global.inventory[i] = -1;
        }
        show_debug_message("Load Game: Inventory array copy complete.");
        // (Verbose log of final global inventory is good for debugging, keep it)
        show_debug_message("Load Game DEBUG: Final Global Inventory Contents:");
        var _inv_string = "";
        for (var i=0; i < INVENTORY_SIZE; i++){
             _inv_string += "["+string(i)+":"+string(global.inventory[i])+"]";
             if ((i+1) % 10 == 0 || i == INVENTORY_SIZE -1) { show_debug_message(_inv_string); _inv_string = ""; }
             else if (i < INVENTORY_SIZE - 1) { _inv_string += ", "; }
         }

        // -- Restore Equipped Items --
        if (!variable_struct_exists(_game_state, "equipped_items")) throw "Game state missing 'equipped_items'.";
        var _loaded_equipped = _game_state.equipped_items;
        if (!is_struct(_loaded_equipped)) throw "Invalid 'equipped_items' data format (not a struct).";
        if (ds_exists(global.equipped_items, ds_type_map)) ds_map_destroy(global.equipped_items);
        global.equipped_items = ds_map_create();
        var _keys = variable_struct_get_names(_loaded_equipped);
        for (var i=0; i<array_length(_keys); i++) {
             var _key = _keys[i];
             ds_map_add(global.equipped_items, _key, _loaded_equipped[$ _key]);
        }
        show_debug_message("Load Game: Restored equipped items map.");


        // -- Restore Room States -- (REVISED logic from your provided code seems okay here)
        if (!variable_struct_exists(_game_state, "room_states")) throw "Game state missing 'room_states'.";
        var _loaded_room_states_struct = _game_state.room_states;
        if (!is_struct(_loaded_room_states_struct)) throw "Invalid 'room_states' data format (not a struct).";

        show_debug_message("Load Game: Reconstructing global.room_states DS Map with *arrays* of state structs...");
        // Destroy old DS map and contained DS lists (if any)
        if (ds_exists(global.room_states, ds_type_map)) {
            var _old_keys = ds_map_keys_to_array(global.room_states);
            for(var i = 0; i < array_length(_old_keys); i++) {
                var _old_item = ds_map_find_value(global.room_states, _old_keys[i]);
                if(ds_exists(_old_item, ds_type_list)) ds_list_destroy(_old_item);
                // Arrays don't need explicit destroy
            }
            ds_map_destroy(global.room_states);
        }
        // Create new map
        global.room_states = ds_map_create();
        if (!ds_exists(global.room_states, ds_type_map)) throw "Failed to create global.room_states DS Map during load!";
        // Populate new map with arrays from loaded struct
        var _room_names = variable_struct_get_names(_loaded_room_states_struct);
        for (var i = 0; i < array_length(_room_names); i++) {
            var _room_name_key = _room_names[i];
            var _loaded_object_array = _loaded_room_states_struct[$ _room_name_key];
            if (is_array(_loaded_object_array)) {
                ds_map_add(global.room_states, _room_name_key, _loaded_object_array); // Add the array directly
                 show_debug_message("  - Stored state *array* for room '" + _room_name_key + "' (Size: " + string(array_length(_loaded_object_array)) + ")");
            } else {
                show_debug_message("Load Game WARNING: Data for room '" + _room_name_key + "' in save file was not an array. Storing empty array.");
                ds_map_add(global.room_states, _room_name_key, []);
            }
        }
         show_debug_message("Load Game: Finished reconstructing global.room_states map (now contains arrays).");


        // -- Restore Quests --
        // (Your existing quest loading logic seems okay, ensure DS lists are created if they don't exist)
         if (variable_struct_exists(_game_state, "active_quests")) { /* ... */ }
         if (variable_struct_exists(_game_state, "completed_quests")) { /* ... */ }

        // -- Restore Other Global Flags --
        global.repair_complete = _game_state.repair_complete_flag ?? false;
         // Add restoration for other saved global flags here...

         _load_successful = true;

    } catch (_error) {
        show_debug_message("Load Game ERROR during data loading: " + string(_error));
         try { show_message_async("Error loading game data:\n" + string(_error)); } catch (ex) {} // Show user feedback if possible
        _load_successful = false;
    }


    // --- 6. Finalization ---
    if (_load_successful) {
        show_debug_message("--- Finished load_game (Success) ---");
    } else {
        show_debug_message("--- Finished load_game (Failed) ---");
         global.is_loading_game = false; // Reset flag on failure
    }
    // Clean up parsed data struct if it exists
    // No direct 'delete' for structs, just let it go out of scope or set to noone if needed.
    _load_data = undefined;

    return _load_successful;
}