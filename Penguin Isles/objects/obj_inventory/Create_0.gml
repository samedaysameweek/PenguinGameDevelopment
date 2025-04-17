// --- obj_inventory: Create Event ---
inventory_size = INVENTORY_SIZE; // Use the macro instead of hardcoded 42
inventory = array_create(inventory_size, -1); // Uses the variable set above
active_slot = 0;
global.active_item_index = active_slot; // Consider if this global is still needed or if obj_inventory should manage it
persistent = true;
global.is_expanded = false;             // Track expanded state (might move to UI manager later)
global.is_special_actions_open = false; // Track special actions state (might move to UI manager later)

show_debug_message("obj_inventory Create: Initialized with size " + string(inventory_size));

// --- NEW: Inventory Management Methods ---

/// @function inventory_has(item_name)
/// @description Checks if the inventory contains the specified item.
/// @param {string} item_name The name of the item to check for.
/// @returns {bool} True if the item exists, false otherwise.
inventory_has = function(item_name) {
    // Safety check for item data maps
    if (!ds_exists(global.item_index_map, ds_type_map)) {
        show_debug_message("ERROR (inventory_has): global.item_index_map missing!");
        return false;
    }
    var item_index = ds_map_find_value(global.item_index_map, item_name);
    if (is_undefined(item_index) || item_index == -1) {
        // show_debug_message("DEBUG (inventory_has): Item '" + item_name + "' not found in index map.");
        return false; // Item name doesn't exist in our known items
    }
    for (var i = 0; i < inventory_size; i++) {
        if (inventory[i] == item_index) {
            return true;
        }
    }
    return false;
}

/// @function inventory_add(item_name)
/// @description Adds an item to the first available inventory slot.
/// @param {string} item_name The name of the item to add.
/// @returns {bool} True if added successfully, false otherwise (e.g., full or invalid item).
inventory_add = function(item_name) {
    // Safety check for item data maps
    if (!ds_exists(global.item_index_map, ds_type_map)) {
        show_debug_message("ERROR (inventory_add): global.item_index_map missing!");
        return false;
    }

    // Don't add if already present (optional, based on your game design)
    // if (inventory_has(item_name)) {
    //     show_debug_message("INFO (inventory_add): Item '" + item_name + "' already in inventory.");
    //     return false; // Or maybe return true if stacking is allowed later
    // }

    var item_index = ds_map_find_value(global.item_index_map, item_name);
    if (is_undefined(item_index) || item_index == -1) {
        show_debug_message("ERROR (inventory_add): Invalid item name '" + item_name + "'");
        return false;
    }

    for (var i = 0; i < inventory_size; i++) {
        if (inventory[i] == -1) { // Find first empty slot (-1)
            inventory[i] = item_index;
            show_debug_message("Inventory: Added '" + item_name + "' (Index: " + string(item_index) + ") to slot " + string(i));
            // Optional: Update active item if needed
            // global.active_item_index = inventory[active_slot];
            // Quest System Notification (Example - refine later)
            event_user(0); // Trigger User Event 0 for quest checks
            return true;
        }
    }

    show_debug_message("Inventory: Full. Cannot add '" + item_name + "'.");
    return false;
}

/// @function inventory_remove(item_name)
/// @description Removes the first instance of an item from the inventory.
/// @param {string} item_name The name of the item to remove.
/// @returns {bool} True if removed successfully, false otherwise (e.g., not found or invalid item).
inventory_remove = function(item_name) {
    // Safety check for item data maps
    if (!ds_exists(global.item_index_map, ds_type_map)) {
        show_debug_message("ERROR (inventory_remove): global.item_index_map missing!");
        return false;
    }

    var item_index = ds_map_find_value(global.item_index_map, item_name);
    if (is_undefined(item_index) || item_index == -1) {
        show_debug_message("ERROR (inventory_remove): Invalid item name '" + item_name + "'");
        return false;
    }

    for (var i = 0; i < inventory_size; i++) {
        if (inventory[i] == item_index) {
            var removed_from_slot = i;
            inventory[i] = -1; // Mark slot as empty
            show_debug_message("Inventory: Removed '" + item_name + "' (Index: " + string(item_index) + ") from slot " + string(removed_from_slot));
            // Optional: Update active item if the removed item was active
            if (removed_from_slot == active_slot) {
                global.active_item_index = -1; // Or inventory[active_slot] which is now -1
            }
             // Quest System Notification (Example - refine later)
            event_user(0); // Trigger User Event 0 for quest checks
            return true;
        }
    }

    show_debug_message("Inventory: Item '" + item_name + "' not found for removal.");
    return false;
}

/// @function inventory_get_item_count(item_name)
/// @description Counts how many of a specific item are in the inventory.
/// @param {string} item_name The name of the item to count.
/// @returns {int} The number of instances of the item found.
inventory_get_item_count = function(item_name) {
    if (!ds_exists(global.item_index_map, ds_type_map)) {
        show_debug_message("ERROR (inventory_get_item_count): global.item_index_map missing!");
        return 0;
    }
    var item_index = ds_map_find_value(global.item_index_map, item_name);
    if (is_undefined(item_index) || item_index == -1) return 0;

    var count = 0;
    for (var i = 0; i < inventory_size; i++) {
        if (inventory[i] == item_index) {
            count++;
        }
    }
    return count;
}


/// @function inventory_drop_active_item()
/// @description Drops the item currently in the active slot into the game world.
inventory_drop_active_item = function() {
    var item_index_to_drop = inventory[active_slot];
    if (item_index_to_drop == -1) {
        show_debug_message("Inventory: No item in active slot (" + string(active_slot) + ") to drop.");
        return;
    }

    // Safety check for item data maps
    if (!ds_exists(global.item_index_map, ds_type_map) || !ds_exists(global.item_object_map, ds_type_map)) {
         show_debug_message("ERROR (inventory_drop_active_item): Item data maps missing!");
         return;
    }

    // Find the item name from the index value
    var item_name = "";
    var map_keys = ds_map_keys_to_array(global.item_index_map);
    for (var k = 0; k < array_length(map_keys); k++) {
        if (ds_map_find_value(global.item_index_map, map_keys[k]) == item_index_to_drop) {
            item_name = map_keys[k];
            break;
        }
    }

    if (item_name == "") {
        show_debug_message("ERROR (inventory_drop_active_item): Could not find item name for index " + string(item_index_to_drop));
        return;
    }

    // Find the corresponding object to create
    var dropped_object = ds_map_find_value(global.item_object_map, item_name);

    // Find the player instance safely
    var _player = global.player_instance;
    if (!instance_exists(_player)) {
        show_debug_message("ERROR (inventory_drop_active_item): Player instance not found. Cannot drop item.");
        return; // Cannot drop if player doesn't exist
    }

    // Create the dropped item instance
    var drop_x = _player.x;
    var drop_y = _player.y;

    if (!is_undefined(dropped_object) && object_exists(dropped_object)) {
        var dropped_item = instance_create_layer(drop_x, drop_y, "Instances", dropped_object);
        // dropped_item.item_name = item_name; // Item object should set its own name in Create event
        show_debug_message("Inventory: Dropped '" + item_name + "' as " + object_get_name(dropped_object) + " at (" + string(drop_x) + ", " + string(drop_y) + ")");
    } else {
        show_debug_message("WARNING (inventory_drop_active_item): No valid object mapped for '" + item_name + "'. Dropping generic obj_dropped_item.");
        // Fallback to generic dropped item if specific object is missing
        var dropped_item = instance_create_layer(drop_x, drop_y, "Instances", obj_dropped_item);
        // We need to tell the generic item *what* it is
        if (variable_instance_exists(dropped_item, "item_type")) { // Assuming obj_dropped_item uses 'item_type'
             dropped_item.item_type = item_name;
        } else {
             show_debug_message("ERROR: obj_dropped_item has no 'item_type' variable!");
        }
    }

    // Remove the item from the inventory slot
    inventory[active_slot] = -1;
    show_debug_message("Inventory: Removed '" + item_name + "' from slot " + string(active_slot) + " after dropping.");
    global.active_item_index = -1; // Update active item index
}

// REMOVE the old get_item_type function, it's not needed directly by inventory anymore
// get_item_type = function(item_name) { ... }


// --- Initialize Example Item ---
// inventory_add("Beta Hat"); // Example: Add beta hat on creation for testing