/// @function update_equipped_items_display()
/// @description Draws equipped items in their respective slots on the HUD.
function update_equipped_items_display() {
    if (!ds_exists(global.equipped_items, ds_type_map) || !ds_exists(global.item_sprite_map, ds_type_map)) {
        show_debug_message("Error: Required global maps not initialized.");
        return;
    }

    var gui_width = display_get_gui_width();
    var gui_height = display_get_gui_height();
    var slot_size = 32; // Size of each slot in pixels
    var start_x = gui_width - (6 * slot_size) - 10; // Right side, 6 slots
    var start_y = gui_height / 2 - (3 * slot_size); // Centered vertically

    var slots = ["head", "face", "neck", "body", "hand", "feet"];
    for (var i = 0; i < array_length(slots); i++) {
        var slot = slots[i];
        var item_name = ds_map_find_value(global.equipped_items, slot);
        var slot_x = start_x + (i mod 3) * slot_size;
        var slot_y = start_y + (i div 3) * slot_size;

	}
}