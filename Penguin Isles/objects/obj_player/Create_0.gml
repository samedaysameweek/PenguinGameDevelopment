// Core variables
xspd = 0;
yspd = 0;
move_spd = 1;
state = "walking";
if (!variable_global_exists("player_color")) { global.player_color = c_white; }
if (variable_global_exists("last_player_color")) { global.player_color = global.last_player_color; } else { global.player_color = c_white; }

// Sliding variables
sliding = false;
slide_dir_x = 0;
slide_dir_y = 0;
slide_speed = 0;

// Driving variables
driving = false;
original_sprite = sprite_index;

// Set direction and sprites
face = DOWN;
sprite_body = spr_player_body; // Default sprite
sprite_color = spr_player_colour;
if (!global.is_loading_game) {
    image_blend = global.player_color;
    show_debug_message("obj_player Create: Applying initial player color: " + string(global.player_color));
} else {
    image_blend = global.player_color;
    show_debug_message("obj_player Create: Applying loaded player color: " + string(global.player_color));
}
mask_index = spr_player_down;
throw_anim_base = "";  // "down_right" or "up_right"
throw_flip = false;    // Whether to flip the sprite horizontally

// Frame data for walking (192x72 sprite sheet: 3 frames per direction)
frame_data = array_create(8);
frame_data[DOWN] = [0, 0, 24, 24, 0, 24, 24, 24, 0, 48, 24, 24];
frame_data[UP] = [24, 0, 24, 24, 24, 24, 24, 24, 24, 48, 24, 24];
frame_data[DOWN_LEFT] = [48, 0, 24, 24, 48, 24, 24, 24, 48, 48, 24, 24];
frame_data[DOWN_RIGHT] = [72, 0, 24, 24, 72, 24, 24, 24, 72, 48, 24, 24];
frame_data[LEFT] = [96, 0, 24, 24, 96, 24, 24, 24, 96, 48, 24, 24];
frame_data[RIGHT] = [120, 0, 24, 24, 120, 24, 24, 24, 120, 48, 24, 24];
frame_data[UP_RIGHT] = [144, 0, 24, 24, 144, 24, 24, 24, 144, 48, 24, 24];
frame_data[UP_LEFT] = [168, 0, 24, 24, 168, 24, 24, 24, 168, 48, 24, 24];

// Special actions system
action_state = "none";  // "none", "dance", "wave", "sit", "jackhammer", "snowshovel", "throw"
action_timer = 0;
action_duration = 0;
sit_delay = 0;
image_index = 0;              // Current animation frame
image_speed = 0;              // Animation speed
action_has_spawned_projectile = false;

// Frame data and sprite maps for special actions
action_frame_data = ds_map_create();
action_sprite_body = ds_map_create();
action_sprite_color = ds_map_create();
action_anim_speed = ds_map_create();

// Sit (8 frames, 24x24, y=72 in spr_player_body)
ds_map_add(action_frame_data, "sit", [
    [0, 72, 24, 24], [24, 72, 24, 24], [48, 72, 24, 24], [72, 72, 24, 24],
    [96, 72, 24, 24], [120, 72, 24, 24], [144, 72, 24, 24], [168, 72, 24, 24]
]);
ds_map_add(action_sprite_body, "sit", spr_player_body);
ds_map_add(action_sprite_color, "sit", spr_player_colour);
ds_map_add(action_anim_speed, "sit", 0); // Static

// Wave (16 frames, 24x24, y=96-120 in spr_player_body)
ds_map_add(action_frame_data, "wave", [
    [0, 96, 24, 24], [24, 96, 24, 24], [48, 96, 24, 24], [72, 96, 24, 24],
    [96, 96, 24, 24], [120, 96, 24, 24], [144, 96, 24, 24], [168, 96, 24, 24],
    [0, 120, 24, 24], [24, 120, 24, 24], [48, 120, 24, 24], [72, 120, 24, 24],
    [96, 120, 24, 24], [120, 120, 24, 24], [144, 120, 24, 24], [168, 120, 24, 24]
]);
ds_map_add(action_sprite_body, "wave", spr_player_body);
ds_map_add(action_sprite_color, "wave", spr_player_colour);
ds_map_add(action_anim_speed, "wave", 0.1); // ~5 FPS

// Dance (56 frames, 24x24, y=144-288 in spr_player_body)
ds_map_add(action_frame_data, "dance", [
    [0, 144, 24, 24], [24, 144, 24, 24], [48, 144, 24, 24], [72, 144, 24, 24], [96, 144, 24, 24], [120, 144, 24, 24], [144, 144, 24, 24], [168, 144, 24, 24],
    [0, 168, 24, 24], [24, 168, 24, 24], [48, 168, 24, 24], [72, 168, 24, 24], [96, 168, 24, 24], [120, 168, 24, 24], [144, 168, 24, 24], [168, 168, 24, 24],
    [0, 192, 24, 24], [24, 192, 24, 24], [48, 192, 24, 24], [72, 192, 24, 24], [96, 192, 24, 24], [120, 192, 24, 24], [144, 192, 24, 24], [168, 192, 24, 24],
    [0, 216, 24, 24], [24, 216, 24, 24], [48, 216, 24, 24], [72, 216, 24, 24], [96, 216, 24, 24], [120, 216, 24, 24], [144, 216, 24, 24], [168, 216, 24, 24],
    [0, 240, 24, 24], [24, 240, 24, 24], [48, 240, 24, 24], [72, 240, 24, 24], [96, 240, 24, 24], [120, 240, 24, 24], [144, 240, 24, 24], [168, 240, 24, 24],
    [0, 264, 24, 24], [24, 264, 24, 24], [48, 264, 24, 24], [72, 264, 24, 24], [96, 264, 24, 24], [120, 264, 24, 24], [144, 264, 24, 24], [168, 264, 24, 24],
    [0, 288, 24, 24], [24, 288, 24, 24], [48, 288, 24, 24], [72, 288, 24, 24], [96, 288, 24, 24], [120, 288, 24, 24], [144, 288, 24, 24], [168, 288, 24, 24]
]);
ds_map_add(action_sprite_body, "dance", spr_player_body);
ds_map_add(action_sprite_color, "dance", spr_player_colour);
ds_map_add(action_anim_speed, "dance", 0.125); // ~4 FPS

// Jackhammer (50 frames, 32x24, spr_player_body_jackhammer)
ds_map_add(action_frame_data, "jackhammer", [
    [0, 0, 32, 24], [32, 0, 32, 24], [64, 0, 32, 24], [96, 0, 32, 24], [128, 0, 32, 24], [160, 0, 32, 24],
    [0, 24, 32, 24], [32, 24, 32, 24], [64, 24, 32, 24], [96, 24, 32, 24], [128, 24, 32, 24], [160, 24, 32, 24],
    [0, 48, 32, 24], [32, 48, 32, 24], [64, 48, 32, 24], [96, 48, 32, 24], [128, 48, 32, 24], [160, 48, 32, 24],
    [0, 72, 32, 24], [32, 72, 32, 24], [64, 72, 32, 24], [96, 72, 32, 24], [128, 72, 32, 24], [160, 72, 32, 24],
    [0, 96, 32, 24], [32, 96, 32, 24], [64, 96, 32, 24], [96, 96, 32, 24], [128, 96, 32, 24], [160, 96, 32, 24],
    [0, 120, 32, 24], [32, 120, 32, 24], [64, 120, 32, 24], [96, 120, 32, 24], [128, 120, 32, 24], [160, 120, 32, 24],
    [0, 144, 32, 24], [32, 144, 32, 24], [64, 144, 32, 24], [96, 144, 32, 24], [128, 144, 32, 24], [160, 144, 32, 24],
    [0, 168, 32, 24], [32, 168, 32, 24], [64, 168, 32, 24], [96, 168, 32, 24], [128, 168, 32, 24], [160, 168, 32, 24],
    [0, 192, 32, 24], [32, 192, 32, 24], [64, 192, 32, 24], [96, 192, 32, 24], [128, 192, 32, 24], [160, 192, 32, 24]
]);
ds_map_add(action_sprite_body, "jackhammer", spr_player_body_jackhammer);
ds_map_add(action_sprite_color, "jackhammer", spr_player_colour_jackhammer);
ds_map_add(action_anim_speed, "jackhammer", 0.15); // ~3.33 FPS

// Snow Shovel (16 frames, 24x48, spr_player_body_snowshovel)
ds_map_add(action_frame_data, "snowshovel", [
    [0, 0, 24, 48], [24, 0, 24, 48], [48, 0, 24, 48], [72, 0, 24, 48], [96, 0, 24, 48], [120, 0, 24, 48], [144, 0, 24, 48], [168, 0, 24, 48],
    [0, 48, 24, 48], [24, 48, 24, 48], [48, 48, 24, 48], [72, 48, 24, 48], [96, 48, 24, 48], [120, 48, 24, 48], [144, 48, 24, 48], [168, 48, 24, 48]
]);
ds_map_add(action_sprite_body, "snowshovel", spr_player_body_snowshovel);
ds_map_add(action_sprite_color, "snowshovel", spr_player_colour_snowshovel);
ds_map_add(action_anim_speed, "snowshovel", 0.1); // ~5 FPS

// Throw (8 frames, 24x24, y=312 in spr_player_body - adjust if needed)
ds_map_add(action_frame_data, "throw", [
    [0, 0, 24, 24], [24, 0, 24, 24], [48, 0, 24, 24], [72, 0, 24, 24],
    [96, 0, 24, 24], [120, 0, 24, 24], [144, 0, 24, 24], [168, 0, 24, 24]
]);
ds_map_add(action_sprite_body, "throw", spr_throwsnowball_body);
ds_map_add(action_sprite_color, "throw", spr_throwsnowball_colour);
ds_map_add(action_anim_speed, "throw", 0.25); // ~2 FPS

// Debugging
show_debug_message("obj_player: Initialized. Driving state: " + string(driving));