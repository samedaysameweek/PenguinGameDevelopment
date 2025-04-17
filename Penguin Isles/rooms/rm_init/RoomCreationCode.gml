show_debug_message("rm_init: Creation Code Started.");

if (variable_global_exists("target_room")) {
         show_debug_message("rm_init: Value of global.target_room before check: " + room_get_name(global.target_room) + " (ID: " + string(global.target_room) + ")");
    } else {
         show_debug_message("rm_init: global.target_room does NOT exist before check.");
    }
// Check if we are in the process of loading a game
if (variable_global_exists("is_loading_game") && global.is_loading_game == true) {
    show_debug_message("rm_init: Loading game detected.");

    // Ensure target room exists from the load data
    if (variable_global_exists("target_room") && room_exists(global.target_room)) {
        show_debug_message("rm_init: Valid target room found: " + room_get_name(global.target_room) + ". Transitioning...");
        // Go to the loaded room INSTEAD of the next room
        room_goto(global.target_room);
        // We keep global.is_loading_game = true for now.
        // It will be reset in the Room Start event of the *target* room.
    } else {
        show_debug_message("rm_init Warning: Invalid or missing global.target_room during load. Proceeding to next room.");
        // Fallback if target room is invalid
        global.is_loading_game = false; // Reset flag as loading effectively failed here
		global.is_loading_game_trigger_load_state = false;
        room_goto_next();
    }
} else {
    // Normal new game flow
    show_debug_message("rm_init: Not loading game. Proceeding to next room (New Game).");
	global.is_loading_game_trigger_load_state = false;
    room_goto_next();
}

show_debug_message("rm_init: Creation Code Finished.");