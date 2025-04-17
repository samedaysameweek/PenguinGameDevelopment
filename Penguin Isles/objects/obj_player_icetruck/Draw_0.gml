var draw_x = x;
var draw_y = y;
var frame_index = floor(image_index) mod 2; // 2 frames per direction
var frame_x = frame_data[face][frame_index * 4];
var frame_y = frame_data[face][frame_index * 4 + 1];
var frame_width = frame_data[face][frame_index * 4 + 2];
var frame_height = frame_data[face][frame_index * 4 + 3];

// Determine if flipping is needed
var xscale = 1;
if (face == LEFT || face == DOWN_LEFT || face == UP_LEFT) {
    xscale = -1;
}

// Center the sprite
draw_x -= (frame_width / 2) * xscale;
draw_y -= frame_height / 2;

// Draw all three layers
draw_sprite_part_ext(sprite_base, 0, frame_x, frame_y, frame_width, frame_height, draw_x, draw_y, xscale, 1, c_white, 1);
draw_sprite_part_ext(sprite_colour, 0, frame_x, frame_y, frame_width, frame_height, draw_x, draw_y, xscale, 1, icetruck_tint, 1);
draw_sprite_part_ext(sprite_penguin, 0, frame_x, frame_y, frame_width, frame_height, draw_x, draw_y, xscale, 1, global.player_color, 1);
draw_sprite_part_ext(sprite_window_tint, 0, frame_x, frame_y, frame_width, frame_height, draw_x, draw_y, xscale, 1, c_white, 1);