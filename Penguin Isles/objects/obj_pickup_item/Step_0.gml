// obj_pickup_item Step Event
if (keyboard_check_pressed(ord("E")) && instance_exists(global.player_instance) && distance_to_object(global.player_instance) < 16) {
    // Check if the inventory object exists before calling its methods
    if (instance_exists(obj_inventory)) {
        // Use the centralized method
        var added = obj_inventory.inventory_add(item_name);
        if (added) {
            show_debug_message("'" + item_name + "' added to inventory via obj_inventory.");
            instance_destroy(); // Destroy AFTER successfully adding
        } else {
            show_debug_message("Inventory full or item invalid. Cannot pick up '" + item_name + "'.");
            // Optionally provide feedback to the player (e.g., text popup)
        }
    } else {
        show_debug_message("ERROR: obj_inventory instance not found!");
    }
}
set_depth();