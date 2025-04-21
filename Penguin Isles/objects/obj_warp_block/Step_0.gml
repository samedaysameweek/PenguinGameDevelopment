/// Step Event for obj_warp_block - Player Only Warp
// Skip if a warp is already in progress or player cooldown is active
if (instance_exists(obj_warp) || global.warp_cooldown) {
    exit; // Do nothing if already warping or on cooldown
}

// Check ONLY for the global player instance collision
if (instance_exists(global.player_instance) && place_meeting(x, y, global.player_instance)) {

    show_debug_message("DEBUG: Player detected on warp block " + string(id) + ". Initiating warp.");

    // --- Room Validation ---
    if (!room_exists(target_rm)) {
        show_debug_message("ERROR: Target room invalid (" + string(target_rm) + "). Defaulting to current room.");
        target_rm = room; // Default to current room if target is invalid
    } else {
        show_debug_message("DEBUG: Valid target room: " + room_get_name(target_rm));
    }

    // --- Determine Player Face ---
    var _warp_target_face = target_face; // Default from block properties
    // Use player's current face if the variable exists
    if (variable_instance_exists(global.player_instance, "face")) {
        _warp_target_face = global.player_instance.face;
    }

    // --- Create the Temporary Warp Effect/Trigger Instance ---
    // Ensure the target layer exists (safety check)
    if (!layer_exists("Instances")) { layer_create(0, "Instances"); }
    var warp_inst = instance_create_layer(x, y, "Instances", obj_warp);
    warp_inst.target_instance = global.player_instance; // Tell warp obj who triggered
    warp_inst.target_rm = target_rm;
    warp_inst.target_x = target_x;
    warp_inst.target_y = target_y;
    warp_inst.target_face = _warp_target_face; // Pass face direction

    // --- Set PLAYER Cooldown and Start Alarm on THIS Warp Block ---
    global.warp_cooldown = true; // Activate the global cooldown
    alarm[0] = room_speed * 2; // Set 2-second cooldown using THIS warp_block's Alarm 0
    show_debug_message("DEBUG: Player warp initiated. Cooldown started (2s). Alarm[0] set on warp block " + string(id));

    // --- Player Visibility during warp (Optional: Hide player during effect) ---
    // global.player_instance.visible = false; // Uncomment if you want player to hide during warp visual

}