// Create Event for obj_player_tube

// Core variables
xspd = 0;
yspd = 0;
move_spd = 1.5;
sliding = true;
slide_dir_x = 0;
slide_dir_y = 0;
slide_speed = 3;

// Set direction
face = DOWN;

// Define sprite positions for the tube
tube_sprites = array_create(8);
tube_sprites[UP] = [0, 0];        
tube_sprites[LEFT] = [0, 0];      
tube_sprites[DOWN] = [24, 0];     
tube_sprites[RIGHT] = [24, 0];    
tube_sprites[UP_LEFT] = [48, 0];  
tube_sprites[DOWN_RIGHT] = [48, 0];
tube_sprites[DOWN_LEFT] = [72, 0]; 
tube_sprites[UP_RIGHT] = [72, 0];

// Ensure a valid face direction
if (!array_length(tube_sprites[face])) {
    face = DOWN; // Default if invalid
}

mask_index = spr_tube_down; // Ensure collision works

// Set global player instance
global.player_instance = id;
global.current_skin = "tube";
sprite_index = spr_tube_sheet;
is_savable = true;

// Debugging
show_debug_message("obj_player_tube: Initialized. Player instance ID: " + string(id));
