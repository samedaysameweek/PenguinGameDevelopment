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
            } else {
                show_debug_message("Load Game WARNING: current_room missing from save data. Defaulting to Welcome Room.");
                global.target_room = rm_welcome_room;
            }

            // Load Room States (Load the entire map now)
            if (variable_struct_exists(game_state, "room_states")) {
                var room_states_struct = game_state.room_states;
                if (is_struct(room_states_struct)) {
                    // Clear existing room states map carefully
                    var _old_keys = ds_map_keys_to_array(global.room_states);
                    for (var i = 0; i < array_length(_old_keys); i++) {
                         var _list_id = global.room_states[? _old_keys[i]];
                         if (ds_exists(_list_id, ds_type_list)) ds_list_destroy(_list_id);
                    }
                    ds_map_clear(global.room_states);

                    // Populate from loaded struct
                    var room_names = variable_struct_get_names(room_states_struct);
                    for (var i = 0; i < array_length(room_names); i++) {
                         var room_name = room_names[i];
                         var state_list_array = room_states_struct[$ room_name];
                         if (is_array(state_list_array)) {
                             var state_ds_list = ds_list_create();
                             for (var j = 0; j < array_length(state_list_array); j++) {
                                  if (is_struct(state_list_array[j])) {
                                      ds_list_add(state_ds_list, state_list_array[j]);
                                  }
                             }
                             ds_map_add(global.room_states, room_name, state_ds_list);
                         } else { show_debug_message("Load Game WARNING: Room state data for '" + room_name + "' is not an array."); }
                    }
                    show_debug_message("Load Game: Loaded " + string(array_length(room_names)) + " room states into global.room_states.");
                } else { show_debug_message("Load Game WARNING: room_states data in save is not a struct."); ds_map_clear(global.room_states); }
            } else { show_debug_message("Load Game: No room_states found in save data."); ds_map_clear(global.room_states); }


            // Load Quests
            ds_list_clear(global.active_quests);
            if (variable_struct_exists(game_state, "active_quests") && is_array(game_state.active_quests)) {
                 array_copy_to_list(game_state.active_quests, global.active_quests);
                 show_debug_message("Load Game: Loaded " + string(ds_list_size(global.active_quests)) + " active quests.");
            } else { show_debug_message("Load Game: No valid active_quests array found in save data."); }

            ds_list_clear(global.completed_quests);
             if (variable_struct_exists(game_state, "completed_quests") && is_array(game_state.completed_quests)) {
                 array_copy_to_list(game_state.completed_quests, global.completed_quests);
                 show_debug_message("Load Game: Loaded " + string(ds_list_size(global.completed_quests)) + " completed quests.");
             } else { show_debug_message("Load Game: No valid completed_quests array found in save data."); }

             // Add other game state variables here if needed

        } else {
             throw "Required 'game_state' struct missing from save data.";
        }

        // --- Load Player Data ---
         if (variable_struct_exists(save_data, "player")) {
             var player_data = save_data.player;

             global.player_x = player_data.x ?? 170; // Use nullish coalescing for defaults
             global.player_y = player_data.y ?? 154;
             global.current_skin = player_data.skin ?? "player";
             global.last_player_face = player_data.face ?? DOWN;
             global.expanded_hud_open = player_data.expanded_hud_open ?? false; // Assuming this was saved

             // Load Color
             if (variable_struct_exists(player_data, "color") && is_struct(player_data.color)) {
                var c = player_data.color;
                global.player_color = make_color_rgb(c.r ?? 255, c.g ?? 255, c.b ?? 255);
             } else { global.player_color = make_color_rgb(51, 51, 51); } // Default color

             // Load Inventory
             // Ensure global.inventory exists and is an array *before* loading
             if (!variable_global_exists("inventory") || !is_array(global.inventory)) {
                show_debug_message("Load Game WARNING: global.inventory invalid before load! Re-creating.");
                global.inventory = array_create(INVENTORY_SIZE, -1); // Use Macro for default size
             } else {
                 // If it exists, make sure it has the correct size (in case it was somehow altered)
                 if (array_length(global.inventory) != INVENTORY_SIZE) {
                     array_resize(global.inventory, INVENTORY_SIZE);
                     // Fill potentially new slots with -1 (or however you handle empty)
                     for(var i=0; i<INVENTORY_SIZE; i++) { if (is_undefined(global.inventory[i])) global.inventory[i] = -1;}
                     show_debug_message("Load Game WARNING: Resized global.inventory to " + string(INVENTORY_SIZE));
                 }
             }


             if (variable_struct_exists(player_data, "inventory") && is_array(player_data.inventory)) {
                var loaded_inv = player_data.inventory;
                // Check size against the *expected* size defined by the macro
                if (array_length(loaded_inv) == INVENTORY_SIZE) {
                    // Explicitly check if loaded_inv is *really* an array before cloning
                    if (is_array(loaded_inv)){
                         global.inventory = array_clone(loaded_inv); // Clone the loaded data
                         show_debug_message("Load Game: Loaded inventory from save data.");
                    } else {
                         show_debug_message("Load Game ERROR: player_data.inventory was not truly an array despite passing first check! Resetting inventory.");
                         global.inventory = array_create(INVENTORY_SIZE, -1);
                    }
                } else {
                     show_debug_message("Load Game WARNING: Saved inventory size mismatch! Resetting inventory.");
                      global.inventory = array_create(INVENTORY_SIZE, -1);
                }
             } else {
                 global.inventory = array_create(INVENTORY_SIZE, -1);
                 show_debug_message("Load Game: No valid inventory array found in save data. Resetting.");
             }

             // Load Equipped Items
             ds_map_clear(global.equipped_items);
             // Add default empty slots FIRST
             ds_map_add(global.equipped_items, "head", -1); ds_map_add(global.equipped_items, "face", -1); /* etc. for all slots */
             ds_map_add(global.equipped_items, "neck", -1); ds_map_add(global.equipped_items, "body", -1);
             ds_map_add(global.equipped_items, "hand", -1); ds_map_add(global.equipped_items, "feet", -1);
             if (variable_struct_exists(player_data, "equipped_items") && is_struct(player_data.equipped_items)) {
                var equipped_struct = player_data.equipped_items;
                var keys = variable_struct_get_names(equipped_struct);
                for (var i = 0; i < array_length(keys); i++) {
                     var key = keys[i];
                     // IMPORTANT: Only add if the key is a valid slot in the game's current definition
                     if (ds_map_exists(global.equipped_items, key)) {
                        global.equipped_items[? key] = equipped_struct[$ key];
                     } else {
                         show_debug_message("Load Game WARNING: Ignoring unknown equipped slot '" + key + "' from save data.");
                     }
                }
                show_debug_message("Load Game: Loaded equipped items.");
             } else { show_debug_message("Load Game: No valid equipped_items struct found."); }

             show_debug_message("Load Game: Loaded Player Data - Skin: " + global.current_skin + ", Color: " + string(global.player_color));

			// Load Following Puffles
			if (variable_struct_exists(save_data, "following_puffles") && is_array(save_data.following_puffles)) {
			    ds_list_clear(global.following_puffles);
			    var puffle_array = save_data.following_puffles;
			    for (var i = 0; i < array_length(puffle_array); i++) {
			        var puffle_data = puffle_array[i];
			        if (is_struct(puffle_data)) {
			            var puffle_inst = instance_create_layer(puffle_data.x, puffle_data.y, "Instances", obj_puffle);
			            puffle_inst.following_player = true;
			            puffle_inst.persistent = true;
			            puffle_inst.color = puffle_data.color ?? "white";
			            puffle_inst.state = puffle_data.state ?? PuffleState.FOLLOWING;
			            switch (puffle_inst.color) {
			                case "red": puffle_inst.image_blend = make_color_rgb(255, 0, 0); break;
			                case "blue": puffle_inst.image_blend = make_color_rgb(0, 0, 255); break;
			                // Add other colors as per obj_puffle Create event
			                default: puffle_inst.image_blend = c_white;
			            }
			            ds_list_add(global.following_puffles, puffle_inst);
			            show_debug_message("Loaded following puffle at (" + string(puffle_data.x) + ", " + string(puffle_data.y) + ")");
			        }
			    }
			    show_debug_message("Load Game: Loaded " + string(ds_list_size(global.following_puffles)) + " following puffles.");
			} else {
			    show_debug_message("Load Game: No following puffles found in save data.");
			}
         } else {
              throw "Required 'player' struct missing from save data.";
         }

        // *** CHANGE: Transition directly to the TARGET room ***
        show_debug_message("Load Game: Successfully loaded data. Transitioning to target room: " + room_get_name(global.target_room));
        room_goto(global.target_room);
        return true;

    } catch (_error) {
        show_debug_message("Load Game ERROR during data loading: " + string(_error));
        global.is_loading_game = false; // Reset flag on error
         // Optionally try backup load here
         // Optionally reset to a default state or go to main menu
        // room_goto(rm_main_menu);
        return false;
    }
}

// Helper function to copy array to ds_list (Keep as is)
function array_copy_to_list(arr, list) {
    if (!is_array(arr) || !ds_exists(list, ds_type_list)) return;
    for (var i = 0; i < array_length(arr); i++) {
        ds_list_add(list, arr[i]);
    }
}