depth = -1000;
// Menu dimensions
menu_width = 109;
menu_height = 72;

// Position the skin picker around the current player instance or center it in the view
if (instance_exists(global.player_instance)) {
    x = global.player_instance.x - menu_width / 2;
    y = global.player_instance.y - menu_height / 2;
} else {
    x = view_xview[0] + (view_wview[0] - menu_width) / 2;
    y = view_yview[0] + (view_hview[0] - menu_height) / 2;
}

// Initialize variables
selected_color = c_white;
global.player_color = c_white;

// Define selection areas
color_wheel_x = x + 31;
color_wheel_y = y + 19;
color_wheel_width = 46;
color_wheel_height = 46;

exit_x = x + 6;
exit_y = y + 6;
exit_width = 9;
exit_height = 9;