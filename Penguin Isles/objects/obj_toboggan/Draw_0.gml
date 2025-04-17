var base_x = toboggan_sprites[face][0];
var base_y = toboggan_sprites[face][1];
var flip = (face == DOWN_LEFT || face == UP_RIGHT) ? -1 : 1;
draw_sprite_part_ext(spr_toboggan_sheet, 0, base_x, base_y, 24, 24, x - 12, y - 12, flip, 1, c_white, 1);