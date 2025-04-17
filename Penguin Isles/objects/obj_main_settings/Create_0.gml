// obj_pause_menu create event
depth = -99990; // Ensure it's drawn above all other objects

// Disable player controls
global.player_controls_enabled = false;

width = display_get_width();
height = display_get_height();
op_border = 8;
op_space = 16;
pos = 0;

// Settings menu options
option[0, 0] = "Window Size";
option[0, 1] = "Brightness";
option[0, 2] = "Controls";
option[0, 3] = "Back";

menu_level = 0;
// Ensure menu_level is valid
if (menu_level < 0 || menu_level >= array_length(option)) {
    show_debug_message("ERROR: Invalid initial menu_level " + string(menu_level));
    menu_level = 0; // Reset to default
}
op_length = array_length(option[menu_level]); // Dynamically set op_length

// Pause the game
game_paused = true;