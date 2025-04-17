// Get tube sprite position
var tube_x = tube_sprites[face][0];
var tube_y = tube_sprites[face][1];

// Draw tube
draw_sprite_part(spr_tube_sheet, 0, tube_x, tube_y, 24, 24, x, y);

// Draw player sitting inside the tube
var sitting_sprites = array_create(8);
sitting_sprites[DOWN] = [0, 72];
sitting_sprites[DOWN_LEFT] = [24, 72];
sitting_sprites[LEFT] = [48, 72];
sitting_sprites[UP_LEFT] = [72, 72];
sitting_sprites[UP] = [96, 72];
sitting_sprites[UP_RIGHT] = [120, 72];
sitting_sprites[RIGHT] = [144, 72];
sitting_sprites[DOWN_RIGHT] = [168, 72];

var sit_x = sitting_sprites[face][0];
var sit_y = sitting_sprites[face][1];