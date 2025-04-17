// Define drawing position and frame (static, facing DOWN)
var draw_x = x;
var draw_y = y;
var frame_x = 0; // Assuming frame 0 is the DOWN direction
var frame_y = 0;
var frame_width = 48; // Match sprite sheet dimensions
var frame_height = 48;

depth = -1000; // Maintain existing depth

// Draw layered sprites
draw_sprite_part(sprite_base, 0, frame_x, frame_y, frame_width, frame_height, draw_x, draw_y);
draw_sprite_part_ext(sprite_colour, 0, frame_x, frame_y, frame_width, frame_height, draw_x, draw_y, 1, 1, icetruck_tint, 1);
draw_sprite_part(sprite_window, 0, frame_x, frame_y, frame_width, frame_height, draw_x, draw_y);

// Display repair prompt if player is near
if (distance_to_object(obj_player) < 24) {
    draw_set_font(fnt_earlygb);
    draw_set_color(c_black);
    draw_text(x - 20, y - 20, "Press 'R' to repair");
}