// --- obj_controller: Game Start Event ---

// Ensure static item data is initialized ONLY ONCE when the game truly starts.
if (!variable_global_exists("static_data_initialized") || global.static_data_initialized == false) {
    if (script_exists(asset_get_index("scr_initialize_item_data"))) {
        scr_initialize_item_data(); // Call the script to define item properties
        global.static_data_initialized = true; // Set flag to prevent re-running
        show_debug_message("obj_controller Game Start: Executed scr_initialize_item_data.");
    } else {
        show_debug_message("obj_controller Game Start ERROR: scr_initialize_item_data script not found!");
        // Consider halting the game or showing an error message here
    }
} else {
    show_debug_message("obj_controller Game Start: Static item data already initialized (skipped).");
}

// You can add other truly one-time game initializations here if needed. 