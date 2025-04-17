// obj_warp_map: Left Pressed Event (Handles Click to Warp)
if (target_rm != noone) {
    show_debug_message("Warping to Room: " + string(target_rm) + " at (" + string(target_x) + ", " + string(target_y) + ")");
    
    // Store last room before warping
    global.last_room = room;  
    
    // Create warp instance to handle transition
    var warp_inst = instance_create_depth(0, 0, -9999, obj_warp);
    warp_inst.target_rm = target_rm;
    warp_inst.target_x = target_x;
    warp_inst.target_y = target_y;
    warp_inst.target_face = target_face;
    warp_inst.target_instance = global.player_instance;

	global.camera_reset = true; // Ensure camera resets correctly
    // Room transition handling
    room_goto(target_rm);

    // Improved handling to check if player instance exists after room transition
    alarm[0] = 2;  // Set alarm to delay camera setup and check for player existence
}
