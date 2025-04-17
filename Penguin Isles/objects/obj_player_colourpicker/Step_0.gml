// Step Event
if (mouse_check_button_pressed(mb_left)) {
    var mx = device_mouse_x_to_gui(0);
    var my = device_mouse_y_to_gui(0);
    
    // Close area
    if (point_in_rectangle(mx, my, x + 98 * scale, y + 1 * scale, x + 156 * scale, y + 11 * scale)) {
        is_destroying = true;
        instance_destroy();
        show_debug_message("Player color picker closed.");
        global.ui_manager.close_ui();
        global.click_handled = true;
        return;
    }
    
    // Color selection
    for (var i = 0; i < 15; i++) {
        var col = i mod 5;
        var row = i div 5;
        var icon_x = start_x + col * (icon_size + spacing);
        var icon_y = start_y + row * (icon_size + spacing);
        if (point_in_rectangle(mx, my, icon_x, icon_y, icon_x + icon_size, icon_y + icon_size)) {
            global.player_color = colors[i];
            if (instance_exists(global.player_instance)) {
                global.player_instance.image_blend = global.player_color;
            }
            is_destroying = true;
            instance_destroy();
            show_debug_message("Player color set to: " + string(colors[i]));
            global.ui_manager.close_ui();
            global.click_handled = true;
            break;
        }
    }
}