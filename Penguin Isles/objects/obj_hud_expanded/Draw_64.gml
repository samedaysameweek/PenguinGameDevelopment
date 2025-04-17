// obj_hud_expanded: Draw GUI Event
if (is_active) {
if (global.is_expanded) {
    var ui_scale = 3;
    var gui_width = display_get_gui_width();
    var gui_height = display_get_gui_height();
    var inv_width = sprite_get_width(spr_hud_expanded) * ui_scale;
    var inv_height = sprite_get_height(spr_hud_expanded) * ui_scale;
    var inv_x = (gui_width - inv_width) / 2;
    var inv_y = gui_height - inv_height;
    draw_sprite_ext(spr_hud_expanded, 0, inv_x, inv_y, ui_scale, ui_scale, 0, c_white, 1);

    // Draw inventory items
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

    // Draw special actions menu
    if (global.is_special_actions_open) {
        var special_x = inv_x + 85 * ui_scale;
        var special_y = inv_y + 37 * ui_scale - sprite_get_height(spr_hud_special_actions) * ui_scale;
        draw_sprite_ext(spr_hud_special_actions, 0, special_x, special_y, ui_scale, ui_scale, 0, c_white, 1);
    }
	update_equipped_items_display();
}
}