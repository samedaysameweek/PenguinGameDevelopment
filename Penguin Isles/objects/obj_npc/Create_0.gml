// Movement settings
xspd = 0;
yspd = 0;
move_spd = 0;
move_x = 0;
move_y = 0;
is_moving = false;
collision_delay = 0;
stuck_timer = 0;
wait_timer = 3;
last_x = x;
last_y = y;
face = DOWN;


// NPC Settings
npc_name = "NPC";  // Default name
if (variable_global_exists("player_colors") && array_length(global.player_colors) > 0) {
    npc_color = global.player_colors[irandom(array_length(global.player_colors) - 1)];
} else {
    npc_color = c_white; // Fallback to white if colors are not defined
}
is_static = true;  // If true, NPC doesn't move

// Dialogue and quest-related variables
quest_active = false;
quest_complete = false;
current_dialogue_index = -1;
dialogue = ["Hello there!", "I have nothing to say."];
player_interacting = false;

// Quest System
is_quest_giver = false;
quest_given = false;
quest_item = "";
quest_quantity = 0;  // Default to 0, set in creation code if needed
quest_stage = 0;  // 0 = not started, 1 = completed
reward_item = "";

// Sprite setup (mirroring obj_player)
sprite_body = spr_player_body;
sprite_color = spr_player_colour;
mask_index = spr_player_down;
image_speed = 0;
image_index = 0;

// Frame data for walking (same as obj_player)
frame_data = array_create(8);
frame_data[DOWN] = [0, 0, 24, 24, 0, 24, 24, 24, 0, 48, 24, 24];
frame_data[UP] = [24, 0, 24, 24, 24, 24, 24, 24, 24, 48, 24, 24];
frame_data[DOWN_LEFT] = [48, 0, 24, 24, 48, 24, 24, 24, 48, 48, 24, 24];
frame_data[DOWN_RIGHT] = [72, 0, 24, 24, 72, 24, 24, 24, 72, 48, 24, 24];
frame_data[LEFT] = [96, 0, 24, 24, 96, 24, 24, 24, 96, 48, 24, 24];
frame_data[RIGHT] = [120, 0, 24, 24, 120, 24, 24, 24, 120, 48, 24, 24];
frame_data[UP_RIGHT] = [144, 0, 24, 24, 144, 24, 24, 24, 144, 48, 24, 24];
frame_data[UP_LEFT] = [168, 0, 24, 24, 168, 24, 24, 24, 168, 48, 24, 24];

// Depth sorting
set_depth();