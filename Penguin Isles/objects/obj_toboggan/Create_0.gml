item_name = "Toboggan";
face = DOWN;
is_savable = true;

// Define sprite positions for spr_toboggan_sheet
toboggan_sprites = array_create(8);
toboggan_sprites[DOWN] = [0, 0];         // DOWN
toboggan_sprites[UP] = [24, 0];          // UP
toboggan_sprites[DOWN_RIGHT] = [48, 0];  // DOWN_RIGHT
toboggan_sprites[UP_LEFT] = [72, 0];     // UP_LEFT
toboggan_sprites[LEFT] = [96, 0];        // LEFT
toboggan_sprites[RIGHT] = [120, 0];      // RIGHT
toboggan_sprites[DOWN_LEFT] = [144, 0];   // Same as DOWN_RIGHT, flipped in Draw
toboggan_sprites[UP_RIGHT] = [168, 0];    // Same as UP_LEFT, flipped in Draw