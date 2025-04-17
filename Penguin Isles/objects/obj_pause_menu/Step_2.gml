// End Step Event in obj_pause_menu
// Only process inputs when the pause menu is active
if (!global.is_pause_menu_active) {
    exit;
}

// Skip if click was already handled by another UI element
if (global.click_handled) {
    exit;
}

// Skip input processing if inventory or expanded HUD is visible
if (global.inventory_visible || global.is_expanded) {
    exit;
}

// Update menu options dynamically
op_length = array_length(option[menu_level]);

// Mouse Position Adjusted to GUI Coordinates
var menu_width = 300;
var menu_height = op_length * 40 + 20;
var menu_top = y - menu_height / 2 + 20;
var menu_left = x - menu_width / 2;

if (mouse_x > menu_left && mouse_x < menu_left + menu_width) {
    pos = floor((mouse_y - menu_top) / 40);
} else {
    pos = -1;
}

// Ensure pos is within valid bounds
if (pos < 0 || pos >= op_length) pos = -1;

// Handle menu selection with mouse click
if (mouse_check_button_pressed(mb_left) && pos >= 0) {
    switch (menu_level) {
        case 0: // Main Pause Menu
            switch (pos) {
                case 0: // Resume Game
                    global.is_pause_menu_active = false;
                    global.player_controls_enabled = true;
                    show_debug_message("Game Resumed");
                    break;
                case 1: // Go to Settings
                    menu_level = 1;
                    break;
                case 2: // Quit Game
                    show_debug_message("Calling game_end from obj_pause_menu Quit Game button");
                    game_end();
                    break;
                case 3: // Save Game
                    save_game(); // Call the save function
                    break;
            }
            break;
        case 1: // Settings Menu
            switch (pos) {
                case 0: 
                    break; // Window Size (placeholder)
                case 1: 
                    break; // Brightness (placeholder)
                case 2: 
                    break; // Controls (placeholder)
                case 3: // Back to Pause Menu
                    menu_level = 0;
                    break;
            }
            break;
    }
}

show_debug_message("Pause menu active: " + string(global.is_pause_menu_active) + ", Click handled: " + string(global.click_handled));