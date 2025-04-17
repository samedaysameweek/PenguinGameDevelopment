xspd = 0;
yspd = 0;
move_spd = 1.5; // Same as tube, adjust if desired
sliding = true;
slide_dir_x = 0;
slide_dir_y = 0;
slide_speed = 3;
face = DOWN;
is_savable = true;

// Define sprite positions for spr_toboggan_sheet
toboggan_sprites = array_create(8);
toboggan_sprites[DOWN] = [0, 0];
toboggan_sprites[UP] = [24, 0];
toboggan_sprites[DOWN_RIGHT] = [48, 0];
toboggan_sprites[UP_LEFT] = [72, 0];
toboggan_sprites[LEFT] = [96, 0];
toboggan_sprites[RIGHT] = [120, 0];
toboggan_sprites[UP_RIGHT] = [144, 0];
toboggan_sprites[DOWN_LEFT] = [168, 0];

mask_index = spr_tube_down; // Create this sprite if not already present
sprite_index = spr_toboggan_sheet;
global.player_instance = id;
global.current_skin = "Toboggan";
show_debug_message("obj_player_toboggan: Initialized. Player instance ID: " + string(id));