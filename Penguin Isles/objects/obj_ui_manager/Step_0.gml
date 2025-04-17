// obj_ui_manager Step Event
var is_ui_room = (room == rm_init || room == rm_main_menu || room == rm_map || room == rm_pause_menu || room == rm_settings_menu);
if (!is_ui_room && !global.is_pause_menu_active) {
    if (instance_exists(inventory_instance) && active_ui == noone) {
        inventory_instance.visible = true;
    }
}
if (active_ui != noone && !instance_exists(active_ui)) {
    active_ui = noone;  // Clear if destroyed
    if (instance_exists(inventory_instance)) {
        inventory_instance.visible = true;
        show_debug_message("UI Manager restored inventory visibility.");
    }
}

// Function to open UI (within obj_ui_manager Step Event)
open_ui = function(ui_object) {
    show_debug_message("UI Manager: Request to open UI object: " + object_get_name(ui_object));

    // --- CRITICAL: Ensure UI Layer Exists ---
    // Check for the layer *immediately before* attempting to create on it.
    if (!layer_exists("UI")) {
         // If it doesn't exist, create it. This is the most reliable place.
         layer_create(-10000, "UI"); // Ensure high depth for UI layer
         show_debug_message("UI Manager (open_ui): Created missing 'UI' Layer.");
    }
    // --- End Layer Check ---

    // Close existing UI first (if any)
    if (active_ui != noone && instance_exists(active_ui)) {
        show_debug_message("UI Manager: Destroying previous active UI (" + string(active_ui) + ", Object: " + object_get_name(instance_exists(active_ui) ? active_ui.object_index : -1) + ")");
        instance_destroy(active_ui);
        active_ui = noone; // Clear the reference immediately
    } else if (active_ui != noone) {
        // If reference exists but instance doesn't, just clear the reference
         show_debug_message("UI Manager: Clearing stale active_ui reference.");
        active_ui = noone;
    }

    // Create the new UI instance on the (now guaranteed) UI layer
    active_ui = instance_create_layer(0, 0, "UI", ui_object);
    if (instance_exists(active_ui)) {
        show_debug_message("UI Manager: Successfully created new active UI (" + string(active_ui) + ") for object: " + object_get_name(ui_object));
    } else {
        show_debug_message("UI Manager ERROR: Failed to create UI instance for: " + object_get_name(ui_object));
        active_ui = noone; // Ensure reference is clear on failure
    }

    // Hide inventory while UI is open
    if (instance_exists(inventory_instance)) {
        inventory_instance.visible = false;
    }

    return active_ui; // Return the new instance ID (or noone if failed)
} // End open_ui function definition