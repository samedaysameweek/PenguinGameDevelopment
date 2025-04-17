// Create Event in obj_pause_menu
depth = -99990; // Ensure pause menu is drawn on top
global.is_pause_menu_active = false;
global.inventory_visible = false; 

image_speed = 0.5; // Menu animation speed

op_border = 8;
op_space = 16;
pos = 0;

// Pause menu options
option[0, 0] = "Back to Game";
option[0, 1] = "Settings";
option[0, 2] = "Quit Game";
option[0, 3] = "Save Game"; // Added "Save Game" option

// Settings menu options
option[1, 0] = "Window Size";
option[1, 1] = "Brightness";
option[1, 2] = "Controls";
option[1, 3] = "Back";

menu_level = 0; 
op_length = array_length(option[menu_level]); // Set initial length dynamically