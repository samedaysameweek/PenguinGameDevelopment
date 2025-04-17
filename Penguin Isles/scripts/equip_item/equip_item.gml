/// @function equip_item(slot, item_name)
/// @param {string} slot The name of the slot to equip the item to (e.g., "head", "body").
/// @param {string} item_name The name of the item to equip.
function equip_item(slot, item_name) {
    show_debug_message("Attempting to equip item: '" + item_name + "' to slot: '" + slot + "'");

    // Ensure the global map exists
    if (!ds_exists(global.equipped_items, ds_type_map)) {
        show_debug_message("ERROR: global.equipped_items map does not exist!");
        // Optionally re-initialize it here if needed, but it should be done in obj_initializer
        return;
    }

    // Ensure the slot key exists in the map
    if (ds_map_exists(global.equipped_items, slot)) {
        // Update the map with the item name
        global.equipped_items[? slot] = item_name;
        show_debug_message("Equipped '" + item_name + "' to slot '" + slot + "'.");
        // Display the current state of the map for debugging
        // show_debug_message("Current global.equipped_items: " + ds_map_write(global.equipped_items));

        // NOTE: Removed call to apply_equipped_items();
        // The player object's Draw event handles the visual update.

    } else {
        show_debug_message("ERROR: Invalid equipment slot specified: '" + slot + "'");
    }
}