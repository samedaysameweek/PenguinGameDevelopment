// Update op_length dynamically based on menu_level
op_length = array_length(option[menu_level]);

// Menu navigation using the mouse
var mouse_x_pos = device_mouse_x(0); // Get mouse x-coordinate
var mouse_y_pos = device_mouse_y(0); // Get mouse y-coordinate

var menu_width = 300; // Width of the menu
var menu_height = 40 * op_length + 20; // Height of the menu
var menu_top = y - menu_height / 2 + 20; // Top of the menu options
var menu_left = x - menu_width / 2; // Left of the menu

if (mouse_x_pos > menu_left && mouse_x_pos < menu_left + menu_width) {
    pos = floor((mouse_y_pos - menu_top) / 40); // Calculate option index
} else {
    pos = -1; // Mouse is not over the menu
}

// Ensure pos stays within bounds
if (pos < 0 || pos >= op_length) {
    pos = -1;
}

// Handle selection with mouse click
if (mouse_check_button_pressed(mb_left) && pos >= 0) {
    switch (menu_level) {
        case 0: // Main settings menu
             switch (pos) {
                case 0: 
                    break; // Window Size (placeholder)
                case 1: 
                    break; // Brightness (placeholder)
                case 2: 
                    break; // Controls (placeholder)
				case 3:	
					room_goto(rm_main_menu);
					break;
            }
            break;
    }
}
