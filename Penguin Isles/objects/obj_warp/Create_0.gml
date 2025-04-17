// obj_warp: Create Event
target_rm = 0;
target_x = 0;
target_y = 0;
target_face = 0;
target_instance = noone;

global.warp_cooldown = true;
alarm[0] = room_speed / 2;

show_debug_message("obj_warp initialized. Target Room: " + string(target_rm));
