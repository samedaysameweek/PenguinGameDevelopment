var sprite_data = get_puffle_sprite_data(face);
var base_subimage = sprite_data[0];
var xscale = sprite_data[1];
var anim_frame = floor(image_index) % 8;
var final_subimage = base_subimage + anim_frame;

var col = final_subimage % 8;
var row = floor(final_subimage / 8);
var left = col * 24;
var top = row * 24;

// Adjust draw_x based on xscale to center the sprite
var draw_x = x - (12 * xscale); // Shift left for xscale=1, right for xscale=-1
var draw_y = y - 12;

draw_sprite_part_ext(spr_puffle_walk, 0, left, top, 24, 24, draw_x, draw_y, xscale, 1, image_blend, 1);