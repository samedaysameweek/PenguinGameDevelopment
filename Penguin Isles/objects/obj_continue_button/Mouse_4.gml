// Set the flag BEFORE loading starts
global.is_loading_game = true;
show_debug_message("Continue button pressed. Setting global.is_loading_game = true");

// Attempt to load the game
load_game();