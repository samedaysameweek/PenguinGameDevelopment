// Check if a warp instance exists
if (instance_exists(obj_warp)) {
    var warp_inst = instance_find(obj_warp, 0);
    if (warp_inst != noone) {
        if (instance_exists(global.player_instance)) {
            global.player_instance.x = warp_inst.target_x;
            global.player_instance.y = warp_inst.target_y;
            // Optional: Adjust the player's facing direction
            if (is_real(warp_inst.target_face)) {
                global.player_instance.face = warp_inst.target_face;
            }
        } else {
            show_debug_message("WARNING: Player instance does not exist for warping.");
        }
        instance_destroy(warp_inst);
    }
}