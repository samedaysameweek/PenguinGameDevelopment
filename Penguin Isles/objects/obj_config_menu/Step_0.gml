// obj_config_menu Step Event
if (mouse_check_button_pressed(mb_left)) {
    var mx = device_mouse_x_to_gui(0);
    var my = device_mouse_y_to_gui(0);
    
    // Skin buttons
    var button_y = panel_y + 40;
    for (var i = 0; i < array_length(global.skins); i++) {
        if (point_in_rectangle(mx, my, panel_x + 20, button_y, panel_x + 120, button_y + 30)) {
            obj_controller.switch_skin(global.skins[i].name);
            show_debug_message("Switched to skin: " + global.skins[i].name);
            global.ui_manager.close_ui();
            if (instance_exists(obj_inventory)) {
                obj_inventory.visible = true;  // Restore inventory
                show_debug_message("Inventory visibility set to true after skin switch.");
            }
            break;
        }
        button_y += 40;
    }
    
    // Item buttons
    var items = ["Beta Hat", "Party Hat", "Wrench", "Tube", "Toboggan", "Battery", "Spy Phone", "Broken Spy Phone", "EPF Phone", "Fishing Rod", "Jackhammer", "Snow Shovel", "Pizza Slice", "Puffle O", "Box Puffle O", "Fish", "Mullet", "Wood", "Snow"];
    var item_display_count = 5;
    button_y = panel_y + 40;
    var should_close = false;
    for (var i = item_scroll; i < item_scroll + item_display_count && i < array_length(items); i++) {
        if (point_in_rectangle(mx, my, panel_x + 150, button_y, panel_x + 180, button_y + 30)) {
            obj_inventory.add_to_inventory(items[i]);
            show_debug_message("Spawned item: " + items[i]);
            should_close = true;  // Flag to close after spawning
            break;
        }
        button_y += 40;
    }
    
    // Scroll buttons
    if (point_in_rectangle(mx, my, panel_x + 190, panel_y + 40, panel_x + 210, panel_y + 60)) {
        item_scroll = max(0, item_scroll - 1);
    } else if (point_in_rectangle(mx, my, panel_x + 190, panel_y + 60, panel_x + 210, panel_y + 80)) {
        item_scroll = min(array_length(items) - item_display_count, item_scroll + 1);
    }
    
    // Color picker buttons
    if (point_in_rectangle(mx, my, panel_x + 220, panel_y + 40, panel_x + 320, panel_y + 70)) {
        instance_create_layer(0, 0, "Instances", obj_player_colourpicker);
        global.ui_manager.close_ui();
        if (instance_exists(obj_inventory)) {
            obj_inventory.visible = true;  // Restore inventory
            show_debug_message("Inventory visibility set to true after player colour picker.");
        }
    } else if (point_in_rectangle(mx, my, panel_x + 220, panel_y + 80, panel_x + 320, panel_y + 110)) {
        instance_create_layer(0, 0, "Instances", obj_icetruck_colourpicker);
        global.ui_manager.close_ui();
        if (instance_exists(obj_inventory)) {
            obj_inventory.visible = true;  // Restore inventory
            show_debug_message("Inventory visibility set to true after icetruck colour picker.");
        }
    }
    
    // Close button
    if (point_in_rectangle(mx, my, panel_x + panel_width - 30, panel_y + 10, panel_x + panel_width - 10, panel_y + 30)) {
        global.ui_manager.close_ui();
        if (instance_exists(obj_inventory)) {
            obj_inventory.visible = true;  // Restore inventory
            show_debug_message("Inventory visibility set to true after close button.");
        }
        show_debug_message("Configuration menu closed.");
    }
    
    // Close after spawning item
    if (should_close) {
        global.ui_manager.close_ui();
        if (instance_exists(obj_inventory)) {
            obj_inventory.visible = true;  // Restore inventory
            show_debug_message("Inventory visibility set to true after spawning item.");
        }
    }
}

if (keyboard_check_pressed(vk_escape)) {
    global.ui_manager.close_ui();
    if (instance_exists(obj_inventory)) {
        obj_inventory.visible = true;  // Restore inventory
        show_debug_message("Inventory visibility set to true after ESC.");
    }
    show_debug_message("Configuration menu closed via ESC.");
}