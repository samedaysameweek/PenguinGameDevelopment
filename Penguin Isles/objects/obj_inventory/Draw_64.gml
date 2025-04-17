// In obj_inventory Draw GUI Event
if (instance_exists(id)) {
    if (visible) {
        var ui_scale = 3;
        var gui_width = display_get_gui_width();
        var gui_height = display_get_gui_height();
        var inv_width = sprite_get_width(spr_inventory_ui) * ui_scale;
        var inv_height = sprite_get_height(spr_inventory_ui) * ui_scale;
        var inv_x = (gui_width - inv_width) / 2;
        var inv_y = gui_height - inv_height + 0 * ui_scale;

        if (!global.is_expanded) {
            draw_sprite_ext(spr_inventory_ui, 0, inv_x, inv_y, ui_scale, ui_scale, 0, c_white, 1);

            // Update slot positions
            var slot_positions = [
                [inv_x + 5 * ui_scale, inv_y + 14 * ui_scale],
                [inv_x + 25 * ui_scale, inv_y + 14 * ui_scale],
                [inv_x + 45 * ui_scale, inv_y + 14 * ui_scale],
                [inv_x + 65 * ui_scale, inv_y + 14 * ui_scale],
                [inv_x + 85 * ui_scale, inv_y + 14 * ui_scale],
                [inv_x + 105 * ui_scale, inv_y + 14 * ui_scale],
                [inv_x + 125 * ui_scale, inv_y + 14 * ui_scale],
                [inv_x + 145 * ui_scale, inv_y + 14 * ui_scale]
            ];

            // Draw inventory items
            for (var i = 0; i < 8; i++) {
                if (!is_undefined(inventory[i]) && inventory[i] != -1) { // Skip empty slots
                    var slot_x = slot_positions[i][0];
                    var slot_y = slot_positions[i][1];
                    var item_index = inventory[i];
                    var x_offset, y_offset;
                    if (item_index < 21) { // First row: items 0–20
                        x_offset = item_index * 18;
                        y_offset = 0;
                    } else { // Second row: items 21–24
                        x_offset = (item_index - 21) * 18;
                        y_offset = 18;
                    }
                    draw_sprite_part_ext(spr_inventory_items, 0, x_offset, y_offset, 18, 18, slot_x, slot_y, ui_scale, ui_scale, c_white, 1);
                    if (i == active_slot) {
                        draw_sprite_ext(spr_inventory_highlight, 0, slot_x - 1 * ui_scale, slot_y - 1 * ui_scale, ui_scale, ui_scale, 0, c_white, 1);
                    }
                }
            }
        }

        // Click detection to open expanded HUD
        if (mouse_check_button_pressed(mb_left) && !instance_exists(obj_hud_expanded)) {
            var click_area_left = inv_x + 54 * ui_scale;
            var click_area_top = inv_y + 2 * ui_scale;
            var click_area_right = inv_x + 112 * ui_scale;
            var click_area_bottom = inv_y + 9 * ui_scale;
            var gui_mouse_x = device_mouse_x_to_gui(0);
            var gui_mouse_y = device_mouse_y_to_gui(0);
            if (gui_mouse_x >= click_area_left && gui_mouse_x <= click_area_right &&
                gui_mouse_y >= click_area_top && gui_mouse_y <= click_area_bottom) {
                global.is_expanded = true;
                instance_create_layer(0, 0, "Instances", obj_hud_expanded);
                show_debug_message("Expanded HUD opened - global.is_expanded set to true");
            }
        }
    }
}