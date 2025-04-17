// Movement variables
xspd = 0;
yspd = 0;
move_spd = 2;
direction = choose(0, 45, 90, 135, 180, 225, 270, 315);
direction_timer = 120; // Change direction every 2 seconds at 60 FPS

// Animation variables
face = DOWN;
image_index = 0;
image_speed = 0.1;

// AI State System
enum PuffleState {
    IDLE,
    FOLLOWING,
    PLAYING,
    EATING
}
state = PuffleState.IDLE; // Start in IDLE for testing
idle_timer = 0;
follow_distance = 32;
is_savable = true;
persistent = false;
color = "white";
following_player = false;
player_idle_timer = 0; // Timer for player inactivity

// Eating timer
eating_timer = 0;

// Ensure collision mask
sprite_index = spr_puffle; // Set sprite for collision detection

/// Set Random Puffle Color
var color_variations = [
    make_color_rgb(255, 0, 0),    // Red
    make_color_rgb(0, 0, 255),    // Blue
    make_color_rgb(0, 255, 0),    // Green
    make_color_rgb(255, 255, 0),  // Yellow
    make_color_rgb(128, 0, 128),  // Purple
    make_color_rgb(255, 192, 203),// Pink
    make_color_rgb(255, 165, 0),  // Orange
    make_color_rgb(255, 255, 255) // White
];

// Correct way to select a random color
image_blend = color_variations[irandom(array_length(color_variations) - 1)];

prev_face = face; // Add this line