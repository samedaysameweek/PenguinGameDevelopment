// --- obj_inventory: Step Event ---
if (global.chat_active || global.is_pause_menu_active || global.game_paused) exit;

// --- Handle Input ---
// Scroll through inventory slots (QoL Update: Skip Empty Slots)
var scroll = mouse_wheel_down() - mouse_wheel_up(); // 1 for down, -1 for up, 0 for none

if (scroll != 0) {
    var original_slot = active_slot;
    var current_check_slot = active_slot;
    var max_slots = 8; // Number of slots in the quick bar
    var attempts = 0; // Prevent infinite loop if inventory is empty

    // Loop to find the next/previous non-empty slot
    repeat (max_slots) { // Check each slot at most once
        current_check_slot = (current_check_slot - scroll + max_slots) % max_slots; // Move in scroll direction, wrap around

        // Check if the slot index is valid for the underlying inventory array
        // And if the slot is not empty (-1)
        if (current_check_slot < inventory_size && inventory[current_check_slot] != -1) {
            active_slot = current_check_slot; // Found a valid slot
            break; // Exit the loop
        }

         attempts++;
         if(attempts >= max_slots) break; // Stop if we checked all slots (likely all empty)

    } // End repeat loop

    // Update global tracker only if the slot actually changed
    if (active_slot != original_slot) {
        global.active_item_index = inventory[active_slot];
        show_debug_message("Inventory QoL Scroll: Active slot changed to " + string(active_slot) + ", Item Index: " + string(global.active_item_index));
    } else {
         // Optional: Add a small sound or visual feedback if no other item found?
         // show_debug_message("Inventory QoL Scroll: No other items found.");
    }
} // End if (scroll != 0)

// Drop item
if (keyboard_check_pressed(ord("F"))) {
    inventory_drop_active_item();
}

// --- Item Usage Logic ---
// Remove the used item from inventory (Example: Repair Truck)
// NOTE: The condition `global.repair_complete` should be set by the truck object itself when repair happens.
// This logic might be better placed in the truck's interaction code.
if (keyboard_check_pressed(ord("R")) && variable_global_exists("repair_complete") && global.repair_complete) {
    show_debug_message("Inventory Check: Repair triggered ('R' pressed and repair_complete=true)");
    if (inventory_has("Battery")) { // Use new method
        show_debug_message("Inventory: Attempting to remove Battery for repair...");
        inventory_remove("Battery"); // Use new method
    } else if (inventory_has("Wrench")) { // Example if Wrench was used
         show_debug_message("Inventory: Attempting to remove Wrench for repair...");
         inventory_remove("Wrench"); // Use new method
    } else {
        show_debug_message("Inventory: Neither Battery nor Wrench found for repair completion.");
    }
    global.repair_complete = false; // Consume the flag? Decide where this flag is best managed.
}

// Enter/Exit Tube
if (keyboard_check_pressed(ord("T")) && instance_exists(obj_controller)) {
     if (global.current_skin == "player" && inventory_has("Tube")) { // Use new method
         if (obj_controller.switch_skin("tube")) { // Check if switch was successful
             inventory_remove("Tube"); // Use new method
             show_debug_message("Inventory: Removed Tube after switching to tube skin.");
         }
     } else if (global.current_skin == "tube") {
          if (obj_controller.switch_skin("player")) { // Check if switch was successful
              inventory_add("Tube"); // Add it back - Use new method
              show_debug_message("Inventory: Added Tube back after switching to player skin.");
          }
     }
}

// Enter/Exit Toboggan (Similar logic to Tube)
if (keyboard_check_pressed(ord("T")) && instance_exists(obj_controller)) { // Using 'T' again might conflict, consider different key
    if (global.current_skin == "player" && inventory_has("Toboggan")) { // Use new method
        if (obj_controller.switch_skin("toboggan")) {
             inventory_remove("Toboggan"); // Use new method
             show_debug_message("Inventory: Removed Toboggan after switching to toboggan skin.");
        }
    } else if (global.current_skin == "toboggan") {
         if (obj_controller.switch_skin("player")) {
             inventory_add("Toboggan"); // Use new method
             show_debug_message("Inventory: Added Toboggan back after switching to player skin.");
         }
    }
}


// --- Depth Setting ---
depth = -1000; // Ensure UI layering

// --- Quest Notification Trigger (User Event 0) ---
// Call this if any inventory change might affect quest objectives
// Example: event_user(0);