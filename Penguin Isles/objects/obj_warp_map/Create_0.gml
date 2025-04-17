// obj_warp_map: Create Event
target_rm = noone;  // Set this in Creation Code
target_x = 0;  
target_y = 0;  
target_face = 0;  
depth = -9999;  // Ensure it's drawn on top
// Create Event for obj_warp
if (!variable_global_exists("warp_cooldown")) {
    global.warp_cooldown = false;
}