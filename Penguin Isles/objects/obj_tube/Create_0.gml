item_name = "Tube";

// Core variables
face = DOWN;

// Assign sprite sheet directions (indices for spr_tube_sheet)
tube_sprites = array_create(8);
tube_sprites[UP] = [0, 0];        // UP, LEFT
tube_sprites[LEFT] = [0, 0];
tube_sprites[DOWN] = [24, 0];     // DOWN, RIGHT
tube_sprites[RIGHT] = [24, 0];
tube_sprites[UP_LEFT] = [48, 0];  // UP_LEFT, DOWN_RIGHT
tube_sprites[DOWN_RIGHT] = [48, 0];
tube_sprites[DOWN_LEFT] = [72, 0]; // DOWN_LEFT, UP_RIGHT
tube_sprites[UP_RIGHT] = [72, 0];
is_savable = true;