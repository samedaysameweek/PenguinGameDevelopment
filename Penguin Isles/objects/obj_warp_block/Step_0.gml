/// Step Event for obj_warp_block - REVISED LOGIC

// Skip if a warp is in progress or cooldown is active
if (instance_exists(obj_warp)) {
    show_debug_message("DEBUG Warp Block: Warp already in progress, skipping.");
    exit;
}
if (global.warp_cooldown) {
    if (instance_exists(global.player_instance) && place_meeting(x, y, global.player_instance)) {
        show_debug_message("DEBUG Warp Block: Player colliding but global.warp_cooldown is TRUE.");
    }
    exit;
}

// Initialize variables for warp handling
var _warp_instance = noone;
var _warp_target_face = target_face;

// Check for player collision
if (instance_exists(global.player_instance) && place_meeting(x, y, global.player_instance)) {
    _warp_instance = global.player_instance;
    if (variable_instance_exists(global.player_instance, "face")) {
        _warp_target_face = global.player_instance.face;
    }
    show_debug_message("DEBUG: Player detected. Prioritizing warp.");
}

// Check for polar bear collision (only if player is not warping)
if (_warp_instance == noone) {
    var _polar_bear = instance_place(x, y, obj_polarbear);
    if (_polar_bear != noone) {
        _warp_instance = _polar_bear;
        _warp_target_face = _polar_bear.current_direction;
        show_debug_message("DEBUG: Polar Bear detected on obj_warp_block. Warping.");
    }
}

// Create warp instance if a target was found
if (_warp_instance != noone) {
    // Validate and assign target room
    if (!variable_instance_exists(id, "target_rm") || !room_exists(target_rm)) {
        target_rm = room; // Fallback to the current room
        show_debug_message("DEBUG: Invalid target room. Defaulting to current room.");
    } else {
        show_debug_message("DEBUG: Valid target room identified: " + string(target_rm));
    }

    // Prevent duplicate player instances during polar bear warps
    if (_warp_instance.object_index == obj_polarbear && instance_exists(global.player_instance)) {
        show_debug_message("DEBUG: Polar bear warp detected. Ensuring no duplication.");
        global.player_instance.destroy();
    }

    show_debug_message("Creating obj_warp for instance: " + string(_warp_instance) + " (" + object_get_name(_warp_instance.object_index) + ")");
    var warp_inst = instance_create_layer(x, y, "Instances", obj_warp);
    warp_inst.target_instance = _warp_instance;
    warp_inst.target_face = _warp_target_face;
    warp_inst.target_rm = target_rm; // Assign the validated target room
    warp_inst.target_x = target_x; // Assign the target x-coordinate
    warp_inst.target_y = target_y; // Assign the target y-coordinate

    // Activate cooldown and set timer for reset
    global.warp_cooldown = true;
    alarm[0] = room_speed * 2; // 2-second cooldown
}