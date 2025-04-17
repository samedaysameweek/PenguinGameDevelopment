/// @function save_game()
/// @description Saves the game state to savegame.sav
function save_game() {
    show_debug_message("--- Running save_game ---");

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
        show_debug_message("ERROR: global.equipped_items map does not exist before save. Creating empty map.");
        global.equipped_items = ds_map_create();
        // Add default empty slots
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

    // --- Serialize Room States ---
    global.room_states = ds_map_create();
    for (var i = 0; i < room_instance_count; i++) {
        var inst = room_instance_find(room, i);
        if (instance_exists(inst) && inst.is_savable) {
            var room_name = room_get_name(room);
            if (!ds_map_exists(global.room_states, room_name)) {
                global.room_states[room_name] = [];
            }
            array_push(global.room_states[room_name], {
                object_index: inst.object_index,
                x: inst.x,
                y: inst.y,
                properties: ds_map_to_struct(inst)
            });
        }
    }

    // --- Save Data ---
    var save_data = {
        version: "1.0.0",
        game_state: {
            inventory: global.inventory,
            room_states: global.room_states,
            current_room: room
        }
    };

    // --- Convert to JSON and Save ---
    var json = json_stringify(save_data);
    var file = file_text_open_write("savegame.sav");
    if (file != -1) {
        file_text_write_string(file, json);
        file_text_close(file);
        show_debug_message("Game saved successfully.");
    } else {
        show_debug_message("Error: Failed to open savegame.sav for writing.");
    }

    show_debug_message("--- Finished save_game ---");
}