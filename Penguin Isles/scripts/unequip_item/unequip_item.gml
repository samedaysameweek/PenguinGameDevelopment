/// @function unequip_item(slot)
/// @param {string} slot The name of the slot to unequip the item from
function unequip_item(slot) {
    // Ensure the global map exists
    if (!ds_exists(global.equipped_items, ds_type_map)) {
        show_debug_message("ERROR: global.equipped_items map does not exist!");
        return;
    }

    // Ensure the slot key exists in the map
    if (ds_map_exists(global.equipped_items, slot)) {
        var current_item = global.equipped_items[? slot];
        if (current_item != -1 && !is_undefined(current_item)) {
            global.equipped_items[? slot] = -1; // Set slot to empty (-1)
            show_debug_message("Unequipped item from slot '" + slot + "'.");
            // Display the current state of the map for debugging
            // show_debug_message("Current global.equipped_items: " + ds_map_write(global.equipped_items));

             // NOTE: Removed call to apply_equipped_items();
             // The player object's Draw event handles the visual update.

        } else {
            show_debug_message("Slot '" + slot + "' was already empty.");
        }
    } else {
        show_debug_message("ERROR: Invalid equipment slot specified: '" + slot + "'");
    }
}