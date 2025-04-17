// Left Pressed Event in obj_menu_button
if (btn_action == "new_game") {
    room_goto(rm_colorpicker_menu);  // Go to color picker for new game
} else if (btn_action == "continue") {
    load_game();                  // Call the load_game function to resume saved game
} else if (btn_action == "play") {
    room_goto(rm_init);           // Existing action for play
} else if (btn_action == "start") {
    room_goto(rm_saveload);  // Redirect to rm_saveload instead of rm_colour_picker
} else if (btn_action == "settings") {
    room_goto(rm_settings_menu);  // Existing action for settings
} else if (btn_action == "exit") {
    game_end();                   // Existing action for exit
}