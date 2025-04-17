/// Create Event for obj_initializer
show_debug_message("DEBUG: obj_initializer Create Event START");

// Prevent running initialization if we are loading a game
if (variable_global_exists("is_loading_game") && global.is_loading_game == true) {
    show_debug_message("Skipping obj_initializer Create Event during game load.");
    exit; // Stop the event here
}

// Initialize following_puffles
if (!variable_global_exists("following_puffles") || !ds_exists(global.following_puffles, ds_type_list)) {
    global.following_puffles = ds_list_create();
    show_debug_message("DEBUG: global.following_puffles initialized.");
} else {
     show_debug_message("DEBUG: global.following_puffles already exists.");
}

// Initialize equipped_items map
if (!variable_global_exists("equipped_items") || !ds_exists(global.equipped_items, ds_type_map)) {
    global.equipped_items = ds_map_create();
    ds_map_add(global.equipped_items, "head", -1); // -1 indicates empty slot
    ds_map_add(global.equipped_items, "face", -1);
    ds_map_add(global.equipped_items, "neck", -1); // Added neck slot for completeness
    ds_map_add(global.equipped_items, "body", -1);
    ds_map_add(global.equipped_items, "hand", -1); // Added hand slot for completeness
    ds_map_add(global.equipped_items, "feet", -1); // Added feet slot for completeness
show_debug_message("DEBUG: global.equipped_items initialized in obj_initializer."); // Adjust message if moved
} else {
    show_debug_message("DEBUG: global.equipped_items already exists.");
}
if (!variable_global_exists("inventory_expanded")) {
    global.inventory_expanded = false;
    show_debug_message("DEBUG: global.inventory_expanded initialized.");
}
if (!instance_exists(obj_inventory)) {
    instance_create_layer(0, 0, "Instances", obj_inventory);
    show_debug_message("DEBUG: obj_inventory created.");
}
if (!instance_exists(obj_map_icon)) {
    instance_create_layer(0, 0, "Instances", obj_map_icon);
    show_debug_message("DEBUG: obj_map_icon created.");
}

// Initialize game_paused flag
if (!variable_global_exists("game_paused")) {
    global.game_paused = false;
    show_debug_message("DEBUG: global.game_paused initialized.");
}

// Initialize player visibility flags for hats (might be obsolete if using equipped_items map properly)
if (!variable_global_exists("party_hat_visible")) {
    global.party_hat_visible = false;
    show_debug_message("DEBUG: global.party_hat_visible initialized.");
}
if (!variable_global_exists("beta_hat_visible")) {
    global.beta_hat_visible = false;
    show_debug_message("DEBUG: global.beta_hat_visible initialized.");
}

// Initialize the global camera
if (!variable_global_exists("camera") || !is_real(global.camera)) {
    global.camera = camera_create();
    // Set initial camera properties if needed, e.g., size
    camera_set_view_size(global.camera, 288, 216); // Example size
    camera_set_view_pos(global.camera, 0, 0);
    show_debug_message("DEBUG: New global camera created.");
}
// Always ensure the view uses the global camera
if (view_get_camera(0) != global.camera) {
     view_set_camera(0, global.camera);
     show_debug_message("DEBUG: View 0 assigned to global camera.");
}


// Ensure global player instance reference is managed (best handled by obj_controller)
if (!variable_global_exists("player_instance")) {
    global.player_instance = noone;
    show_debug_message("DEBUG: global.player_instance initialized to noone.");
}

// Initialize icetruck colour picker flag
if (!variable_global_exists("colour_picker_active")) {
    global.colour_picker_active = false;
    show_debug_message("DEBUG: global.colour_picker_active initialized.");
}

show_debug_message("DEBUG: obj_initializer Create Event FINISHED");

// (Self-destruct or deactivate after initialization if desired)
// instance_destroy();