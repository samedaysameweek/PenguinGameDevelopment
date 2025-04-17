// Create Event for obj_player_ninja

// Core variables
xspd = 0;
yspd = 0;
move_spd = 3;

// Sliding variables
sliding = false;
slide_dir_x = 0;
slide_dir_y = 0;
slide_speed = 0;

// Driving variables
driving = false;
ice_truck_sprite = spr_icetruck_facedown;
original_sprite = sprite_index;

// Set direction and sprites
face = DOWN;
init_sprites(spr_ninja_right, spr_ninja_up, spr_ninja_left, spr_ninja_down, spr_ninja_up_right, spr_ninja_up_left, spr_ninja_down_right, spr_ninja_down_left);

// Debugging
show_debug_message("obj_player_ninja: Initialized. Driving state: " + string(driving));