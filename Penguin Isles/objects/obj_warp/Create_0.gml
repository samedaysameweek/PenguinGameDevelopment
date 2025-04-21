// obj_warp: Create Event
target_rm = 0;
target_x = 0;
target_y = 0;
target_face = 0;
target_instance = noone;

persistent = false; // <<< CHANGE THIS TO FALSE

// REMOVED: Alarm setting - Cooldown now handled by obj_warp_block
// alarm[0] = room_speed / 2;

show_debug_message("obj_warp initialized (Persistent: " + string(persistent) + "). Target Room: " + string(target_rm));

// Optional: Set sprite based on target instance for visual feedback
// if (instance_exists(target_instance)) {
//     sprite_index = (target_instance == global.player_instance) ? spr_player_warp_effect : spr_warp_effect_default;
//     image_speed = 1; // Or adjust as needed
// }