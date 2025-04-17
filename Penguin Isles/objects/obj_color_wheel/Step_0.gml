// Handle mouse click for selecting a color
if (mouse_check_button_pressed(mb_left)) {
    var mx = device_mouse_x_to_gui(0);
    var my = device_mouse_y_to_gui(0);

    if (point_in_rectangle(mx, my, x, y, x + sprite_width, y + sprite_height)) {
        var sx = mx - x; // Convert to surface coordinates
        var sy = my - y;

        // Ensure the surface exists before sampling
        if (surface_exists(surf_color_wheel)) {
            selected_color = surface_getpixel(surf_color_wheel, sx, sy);
        } else {
            selected_color = c_black; // Fallback
        }

        // Apply color globally if valid
        if (selected_color != c_black) {
            global.player_color = selected_color;
            if (instance_exists(global.player_instance)) {
                global.player_instance.image_blend = global.player_color;
            }
            show_debug_message("Color selected: " + string(selected_color));
        }
        
        // Close the color wheel and return to previous room
        if (variable_global_exists("last_room") && global.last_room != noone) {
            room_goto(global.last_room);
        } else {
            room_goto(rm_town); // Default return room
        }
        instance_destroy();
    }
}


// Debug mouse position
show_debug_message("Mouse X: " + string(mouse_x) + " | Mouse Y: " + string(mouse_y));
show_debug_message("GUI Mouse X: " + string(device_mouse_x_to_gui(0)) + " | GUI Mouse Y: " + string(device_mouse_y_to_gui(0)));
show_debug_message("View X: " + string(camera_get_view_x(view_camera[0])) + " | View Y: " + string(camera_get_view_y(view_camera[0])));
