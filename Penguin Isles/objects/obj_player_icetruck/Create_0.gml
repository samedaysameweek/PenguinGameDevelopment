// Core variables
xspd = 0;
yspd = 0;
move_spd = 3; // Adjust as needed for ice truck speed
state = "driving"; // Since this is the ice truck, assume driving state
if (!variable_global_exists("player_color")) { global.player_color = c_white; }

// Ice truck-specific tint
icetruck_tint = c_yellow; // Default tint for spr_icetruck_colour

// Direction
face = DOWN;
is_savable = true;

// Sprite definitions
sprite_base = spr_icetruck_base;
sprite_colour = spr_icetruck_colour;
sprite_penguin = spr_icetruck_penguin_colour;
sprite_window_tint = spr_icetruck_window
mask_index = spr_icetruck_down; // Use base sprite for collisions
sprite_index = spr_icetruck_base;

// Animation variables
image_index = 0; // Current frame
image_speed = 0.1; // Animation speed (adjust as needed)

// Frame data for driving (96x240 sprite sheet: 2 frames per direction)
frame_data = array_create(8); // Array for 8 directions
// [frame1_x, frame1_y, width, height, frame2_x, frame2_y, width, height]
frame_data[DOWN] = [0, 0, 48, 48, 48, 0, 48, 48];           // Row 1
frame_data[DOWN_RIGHT] = [0, 48, 48, 48, 48, 48, 48, 48];  // Row 2
frame_data[RIGHT] = [0, 96, 48, 48, 48, 96, 48, 48];       // Row 3
frame_data[UP_RIGHT] = [0, 144, 48, 48, 48, 144, 48, 48];  // Row 4
frame_data[UP] = [0, 192, 48, 48, 48, 192, 48, 48];        // Row 5
// Left-facing directions will use right-facing frames with flipping
frame_data[DOWN_LEFT] = frame_data[DOWN_RIGHT];
frame_data[LEFT] = frame_data[RIGHT];
frame_data[UP_LEFT] = frame_data[UP_RIGHT];

// Debugging
if (place_meeting(x, y, obj_wall)) {
    show_debug_message("Icetruck colliding with wall at position (" + string(x) + ", " + string(y) + ")");
}

show_debug_message("obj_player_icetruck: Initialized.");