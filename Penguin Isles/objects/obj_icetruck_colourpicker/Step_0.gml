// Step Event
if (mouse_check_button_pressed(mb_left)) {
    var mx = device_mouse_x_to_gui(0);
    var my = device_mouse_y_to_gui(0);
    
    // Close area
    if (point_in_rectangle(mx, my, x + 98 * scale, y + 1 * scale, x + 156 * scale, y + 11 * scale)) {
        instance_destroy();
        show_debug_message("Icetruck color picker closed.");
        global.ui_manager.close_ui();
        global.click_handled = true;
        return;
    }
    
    // Color selection
    for (var i = 0; i < 15; i++) {
        var col = i mod 5;
        var row = i div 5;
        var icon_x = start_x + col * 25;
        var icon_y = start_y + row * 25;
        if (point_in_rectangle(mx, my, icon_x, icon_y, icon_x + 20, icon_y + 20)) {
            if (instance_exists(obj_player_icetruck)) {
                obj_player_icetruck.icetruck_tint = colors[i];
                show_debug_message("Icetruck tint set to: " + string(colors[i]));
            } else {
                show_debug_message("No icetruck instance found to set tint.");
            }
            instance_destroy();
            global.ui_manager.close_ui();
            global.click_handled = true;
            break;
        }
    }
}