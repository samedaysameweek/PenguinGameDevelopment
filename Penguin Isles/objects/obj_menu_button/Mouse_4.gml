// Mouse Left Pressed Event in obj_menu_button

// --- New Game Actions ---
if (btn_action == "new_game") {
    // Set loading flag to false explicitly for a new game start
    global.is_loading_game = false;
    show_debug_message("obj_menu_button: New Game selected. Setting is_loading_game=false.");
    // Go to the first step of new game (e.g., color picker or init room)
    room_goto(rm_colorpicker_menu); // Or potentially rm_init if color picker is skipped
    exit; // Exit event after handling action
}
else if (btn_action == "start") { // Assuming 'start' is also a new game variant
    global.is_loading_game = false;
    show_debug_message("obj_menu_button: Start button selected. Setting is_loading_game=false.");
    room_goto(rm_saveload); // Go to init room directly
    exit; // Exit event after handling action
}

// --- Continue Game Action ---
else if (btn_action == "continue") {
    // Ensure loading flag is set *before* calling load_game
    global.is_loading_game = true;
    show_debug_message("obj_menu_button: Continue selected. Setting is_loading_game=true.");

    var _load_result = load_game(); // Call the load_game function

    // *** ADDED TRANSITION LOGIC ***
    if (_load_result == true) {
        // If loading succeeded, go to rm_init which will handle the actual room jump
        show_debug_message("obj_menu_button: load_game successful. Transitioning to rm_init...");
        room_goto(rm_init);
    } else {
        // If loading failed, show a message and reset the flag
        show_debug_message("obj_menu_button: load_game failed. Staying in current room.");
        // CORRECTED LINE BELOW: Removed the second argument
        show_message_async("Failed to load save game."); // User feedback
        global.is_loading_game = false; // Reset flag if load failed
    }
    exit; // Exit event after handling action
}

// --- Other Menu Actions ---
else if (btn_action == "play") { // This might be obsolete if "start" or "new_game" are used
    global.is_loading_game = false;
     show_debug_message("obj_menu_button: Play button selected. Setting is_loading_game=false.");
    room_goto(rm_init);
    exit; // Exit event after handling action
}
else if (btn_action == "settings") {
    room_goto(rm_settings_menu);
    exit; // Exit event after handling action
}
else if (btn_action == "exit") {
    game_end();
    exit; // Exit event after handling action
}

// Fallback if btn_action isn't recognized (shouldn't happen ideally)
show_debug_message("obj_menu_button: Unrecognized action: " + string(btn_action));