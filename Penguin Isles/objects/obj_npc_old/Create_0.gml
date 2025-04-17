xspd = 0;
yspd = 0;

move_spd = 0.5; // Lower speed for smoother movement
move_x = 0;
move_y = 0;
is_moving = false;
collision_delay = 0; // Timer for delaying after a collision
stuck_timer = 0; // Timer to handle stuck state
wait_timer = 3; //Timer to handle how long to pause before walking
last_x = x;      // Tracks previous position for stuck detection
last_y = y;      // Tracks previous position for stuck detection

// Initialize movement variables
target_x = x; // Default to current position
target_y = y; // Default to current position
is_moving = false;
move_speed = 1; // Default movement speed

sprite[RIGHT] = spr_player_right;
sprite[UP] = spr_player_up;
sprite[LEFT] = spr_player_left;
sprite[DOWN] = spr_player_down;
sprite[UP_RIGHT] = spr_player_up_right;
sprite[UP_LEFT] = spr_player_up_left;
sprite[DOWN_RIGHT] = spr_player_down_right;
sprite[DOWN_LEFT] = spr_player_down_left;

face = DOWN;

sliding = false;
slide_dir_x = 0;
slide_dir_y = 0;
slide_speed = 0;

// Random initial direction
direction = choose(0, 45, 90, 135, 180, 225, 270, 315);
change_direction_timer = fps * 2; // Change direction every 2 seconds

phrases = ["Hello there!", "Nice to meet you!", "What brings you here?", "Have a great day!", "Stay safe!"];
current_phrase = ""; // Will hold the currently displayed phrase
talk_timer = 0; // Timer for how long the phrase is displayed
interact_pause = 0; // Timer to pause movement after interaction

