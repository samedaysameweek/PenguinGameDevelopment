/// Animation End Event for obj_warp
show_debug_message("DEBUG: obj_warp transition initiated. Moving player before room transition.");
global.player_instance = target_instance;
if (target_instance != noone) {
    global.warp_target_x = target_x;
    global.warp_target_y = target_y;
    global.warp_target_face = target_face;
    show_debug_message("Player successfully moved to new position.");
} else {
    show_debug_message("ERROR: Target instance not found during warp.");
}

room_goto(target_rm);

// Camera setup is handled in Room Start, so remove manual size setting here
if (instance_exists(global.camera)) {
    view_camera[0] = global.camera; // Ensure view uses the global camera
    show_debug_message("DEBUG: Camera assigned to view[0] after room transition.");
}