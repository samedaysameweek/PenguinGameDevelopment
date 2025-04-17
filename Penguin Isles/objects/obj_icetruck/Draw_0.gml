// Define drawing position and frame (static, facing DOWN)
var draw_x = x;
var draw_y = y;
var frame_x = 0; // Assuming DOWN direction
var frame_y = 0;
var frame_width = 48;
var frame_height = 48;

depth = -1000; // Maintain existing depth

// Draw layered sprites
draw_sprite_part(sprite_base, 0, frame_x, frame_y, frame_width, frame_height, draw_x, draw_y);
draw_sprite_part_ext(sprite_colour, 0, frame_x, frame_y, frame_width, frame_height, draw_x, draw_y, 1, 1, icetruck_tint, 1);
draw_sprite_part(sprite_window, 0, frame_x, frame_y, frame_width, frame_height, draw_x, draw_y);

// Display interaction prompt when player is close
if (distance_to_object(global.player_instance) < 16 && global.current_skin == "player") {
    var text = "Press 'E' to drive";
    var text_width = string_width(text);
    draw_set_font(fnt_earlygb);
    draw_set_color(c_black);
    draw_text(x + (sprite_width / 2) - (text_width / 2), y - 20, text);
}