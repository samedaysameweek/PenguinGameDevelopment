/// Animation End Event for obj_warp - Simplified Player Warp Trigger
show_debug_message("DEBUG (Warp Anim End): Animation ended. Target Instance: " + string(target_instance));

// Restore Player Visibility (if you hid it in warp_block step)
// if (instance_exists(target_instance) && target_instance == global.player_instance) {
//     target_instance.visible = true;
// }

// Ensure the target instance is still the player before setting globals
if (instance_exists(target_instance) && target_instance == global.player_instance) {
    show_debug_message("DEBUG (Warp Anim End): Setting global warp targets for player.");
    // Store the target coordinates for the controller's Room Start event
    global.warp_target_x = target_x;
    global.warp_target_y = target_y;
    global.warp_target_face = target_face;
    // Optional: Storing ID for verification (can be removed if not needed)
    // global.warp_target_inst_id = target_instance;

} else {
     show_debug_message("WARNING (Warp Anim End): Target instance ("+string(target_instance)+") is not the player or doesn't exist! Cannot set warp targets.");
     // Clear potential stale targets just in case
     global.warp_target_x = undefined;
     global.warp_target_y = undefined;
     global.warp_target_face = undefined;
}

// --- Initiate Room Transition ---
show_debug_message("DEBUG (Warp Anim End): Calling room_goto(" + room_get_name(target_rm) + ")");
if (room_exists(target_rm)) {
    room_goto(target_rm);
} else {
    show_debug_message("ERROR (Warp Anim End): Target room doesn't exist! Cannot transition.");
    // Decide fallback behavior - maybe go to a default room?
    // room_goto(rm_welcome_room);
}

// --- Destroy this temporary warp effect object ---
// This runs AFTER room_goto starts the transition process
instance_destroy();
show_debug_message("DEBUG (Warp Anim End): obj_warp instance destroyed.");