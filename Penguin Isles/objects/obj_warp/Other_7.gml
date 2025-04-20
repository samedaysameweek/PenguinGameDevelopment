/// Animation End Event for obj_warp - REVISED (Focus on target_instance)

show_debug_message("DEBUG (Warp Anim End): Animation ended. Processing warp for target_instance: " + string(target_instance));

// Make sure the specific target instance still exists
if (!instance_exists(target_instance)) {
    show_debug_message("ERROR (Warp Anim End): Target instance (" + string(target_instance) + ") no longer exists!");
    room_goto(target_rm); // Go to room anyway
    instance_destroy(); // Destroy self
    exit;
}

show_debug_message("DEBUG (Warp Anim End): Moving instance: " + string(target_instance) + " (" + object_get_name(target_instance.object_index) + ") before room transition.");

/// Animation End Event for obj_warp - REVISED (Focus on target_instance)

show_debug_message("DEBUG (Warp Anim End): Animation ended. Processing warp for target_instance: " + string(target_instance));

// Make sure the specific target instance still exists
if (!instance_exists(target_instance)) { /* ... Error handling ... */ }
else
{
    show_debug_message("DEBUG (Warp Anim End): Moving instance: " + string(target_instance) + " (" + object_get_name(target_instance.object_index) + ") before room transition.");

    // --- Position the SPECIFIC target instance ---
    target_instance.x = target_x; target_instance.y = target_y;
    if (variable_instance_exists(target_instance, "current_direction")) { target_instance.current_direction = target_face; }
    else if (variable_instance_exists(target_instance, "face")) { target_instance.face = target_face; }
    show_debug_message("DEBUG (Warp Anim End): Instance " + string(target_instance) + " moved.");

   // --- Store Warp Coords ONLY IF it was the Player ---
    global.warp_target_x = undefined; global.warp_target_y = undefined; global.warp_target_face = undefined; global.warp_target_inst_id = noone; // Clear first
    if (target_instance == global.player_instance) { global.warp_target_x = target_x; global.warp_target_y = target_y; global.warp_target_face = target_face; global.warp_target_inst_id = target_instance; show_debug_message("DEBUG (Warp Anim End): Stored PLAYER warp target pos."); }
    else { if (!target_instance.persistent) { target_instance.persistent = true; show_debug_message("DEBUG (Warp Anim End): Made NPC persistent."); } show_debug_message("DEBUG (Warp Anim End): NPC warped. Global targets remain undefined."); }
}

// Go to the target room
room_goto(target_rm);

// Destroy self *after* initiating room transition, allowing Alarm 0 to potentially trigger
instance_destroy(); // <<< ADD THIS