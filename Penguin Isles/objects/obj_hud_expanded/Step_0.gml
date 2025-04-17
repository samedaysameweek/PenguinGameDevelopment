// obj_hud_expanded Step event
if (global.chat_active) exit;
// Handle mouse clicks
if (is_active) {
    if (mouse_check_button_pressed(mb_left)) {
        var mx = device_mouse_x_to_gui(0);
        var my = device_mouse_y_to_gui(0);
	
    var ui_scale = 3;
    var gui_width = display_get_gui_width();
    var gui_height = display_get_gui_height();
    var inv_width = sprite_get_width(spr_hud_expanded) * ui_scale;
    var inv_x = (gui_width - inv_width) / 2;
    var inv_y = gui_height - sprite_get_height(spr_hud_expanded) * ui_scale;
    var close_area_left = inv_x + 54 * ui_scale;
    var close_area_top = inv_y + 2 * ui_scale;
    var close_area_right = inv_x + 112 * ui_scale;
    var close_area_bottom = inv_y + 9 * ui_scale;
	// Define the special actions button area
    var special_area_left = inv_x + 85 * ui_scale;
    var special_area_top = inv_y + 37 * ui_scale;
    var special_area_right = inv_x + 102 * ui_scale;
    var special_area_bottom = inv_y + 54 * ui_scale;

	if (point_in_rectangle(mx, my, close_area_left, close_area_top, close_area_right, close_area_bottom)) {
	    global.expanded_hud_open = false; // Add this line
	    global.is_expanded = false;
	    instance_destroy();
	    global.expanded_hud_instance = noone;
	    show_debug_message("Expanded HUD closed successfully.");
	    global.click_handled = true;
	    return;
	}
		// Open expanded inventory menu
        else if (point_in_rectangle(mx, my, inv_x + 65 * ui_scale, inv_y + 37 * ui_scale, inv_x + 82 * ui_scale, inv_y + 54 * ui_scale)) {
            instance_create_layer(0, 0, "Instances", obj_inventory_expanded);
            show_debug_message("Expanded inventory menu opened.");
        }
        // Open special actions menu
        else if (point_in_rectangle(mx, my, special_area_left, special_area_top, special_area_right, special_area_bottom)) {
        global.is_special_actions_open = !global.is_special_actions_open;
        show_debug_message("Special actions menu toggled: " + (global.is_special_actions_open ? "open" : "closed"));
        return;
		}
        // Throw a snowball (placeholder)
        else if (point_in_rectangle(mx, my, inv_x + 105 * ui_scale, inv_y + 37 * ui_scale, inv_x + 122 * ui_scale, inv_y + 54 * ui_scale)) {
            global.is_expanded = false;
            show_debug_message("Throw snowball clicked - to be implemented.");
            // Add snowball logic here later
        }
        // Go to igloo (placeholder)
        else if (point_in_rectangle(mx, my, inv_x + 125 * ui_scale, inv_y + 37 * ui_scale, inv_x + 142 * ui_scale, inv_y + 54 * ui_scale)) {
            global.is_expanded = false;
            show_debug_message("Go to igloo clicked - to be implemented.");
            // Add igloo room transition here later
        }
        // Open configuration menu
        else if (point_in_rectangle(mx, my, inv_x + 145 * ui_scale, inv_y + 37 * ui_scale, inv_x + 162 * ui_scale, inv_y + 54 * ui_scale)) {
            global.ui_manager.open_ui(obj_config_menu);
            show_debug_message("Configuration menu opened.");
            is_active = false; // Deactivate the expanded HUD
            return;
        }
        
         // Handle special actions menu clicks
    if (global.is_special_actions_open) {
        var special_x = inv_x + 85 * ui_scale;
        var special_y = inv_y + 37 * ui_scale - sprite_get_height(spr_hud_special_actions) * ui_scale;
        
        // Wave action (coordinates: adjust as per your sprite layout)
        if (point_in_rectangle(mx, my, special_x + 1 * ui_scale, special_y + 41 * ui_scale, special_x + 16 * ui_scale, special_y + 55 * ui_scale)) {
            obj_player.action_state = "wave";
            obj_player.action_timer = 0;
            obj_player.action_duration = 80; // 16 frames * 5 steps (0.2 speed)
            obj_player.image_index = 0;
            show_debug_message("Wave action triggered");
            global.is_special_actions_open = false;
            global.is_expanded = false;
            instance_destroy();
        }
        // Sit action
        else if (point_in_rectangle(mx, my, inv_x + 145 * ui_scale, inv_y + 37 * ui_scale, inv_x + 162 * ui_scale, inv_y + 54 * ui_scale)) {
        if (instance_exists(global.player_instance)) {
            if (global.player_instance.action_state == "sit") {
                global.player_instance.action_state = "none";
                show_debug_message("Stopped sitting via HUD.");
            } else {
                global.player_instance.action_state = "sit";
                global.player_instance.action_timer = 0;
                global.player_instance.action_duration = -1;
                global.player_instance.image_index = 0;
                show_debug_message("Started sitting via HUD.");
            }
        }
        global.click_handled = true;
    }
        // Dance action
        else if (point_in_rectangle(mx, my, special_x + 1 * ui_scale, special_y + 1 * ui_scale, special_x + 16 * ui_scale, special_y + 24 * ui_scale)) {
            obj_player.action_state = "dance";
            obj_player.action_timer = 0;
            obj_player.action_duration = 224; // 56 frames * 4 steps (0.25 speed)
            obj_player.image_index = 0;
            show_debug_message("Dance action triggered");
            global.is_special_actions_open = false;
            global.is_expanded = false;
            instance_destroy();
        }
    }
}
}

//show_debug_message("obj_hud_expanded is_active = " + string(is_active));
//show_debug_message("obj_hud_expanded exists: " + string(instance_exists(obj_hud_expanded)));
// Keep existing depth setting
depth = -1000;