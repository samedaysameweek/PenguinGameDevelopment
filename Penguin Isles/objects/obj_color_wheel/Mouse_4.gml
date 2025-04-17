var mx = (device_mouse_x_to_gui(0) / display_get_gui_width()) * camera_get_view_width(global.camera) + camera_get_view_x(global.camera);
var my = (device_mouse_y_to_gui(0) / display_get_gui_height()) * camera_get_view_height(global.camera) + camera_get_view_y(global.camera);

// Check if the player clicked inside the exit button (6,6 to 14,14)
if (point_in_rectangle(mx, my, exit_x, exit_y, exit_x + exit_width, exit_y + exit_height)) {
    show_debug_message("Closing color wheel...");
    with (obj_pause_menu) instance_destroy();
    instance_destroy();
    return;
}

// Check if the click is inside the color wheel selection area
if (point_in_rectangle(mx, my, color_wheel_x, color_wheel_y, color_wheel_x + color_wheel_width, color_wheel_y + color_wheel_height)) {
    var sx = mx - color_wheel_x; // Convert to surface coordinates
	var sy = my - color_wheel_y;

	if (sx >= 0 && sy >= 0 && sx < sprite_get_width(spr_color_bar) && sy < sprite_get_height(spr_color_bar)) {
		selected_color = surface_getpixel(surf_color_wheel, sx, sy);
	}

   if (selected_color != c_black) { // Avoid selecting transparent areas
    global.player_color = selected_color;

    if (instance_exists(global.player_instance)) {
        global.player_instance.image_blend = global.player_color;
    }

    show_debug_message("Color selected: " + string(selected_color));
    
    // Close color wheel & pause menu
    with (obj_pause_menu) instance_destroy();
    instance_destroy();
	}
}

show_debug_message("Color picked: " + string(draw_getpixel(mx, my)));
show_debug_message("Fixed Mouse World X: " + string(mouse_world_x) + " | Y: " + string(mouse_world_y));
show_debug_message("View X: " + string(camera_get_view_x(global.camera)) + " | View Y: " + string(camera_get_view_y(global.camera)));
