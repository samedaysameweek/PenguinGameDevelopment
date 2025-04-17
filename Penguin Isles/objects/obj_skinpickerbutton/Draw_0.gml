// Draw Event for obj_button
draw_self(); // Draw the button sprite

// Draw the button text
draw_set_color(c_black); // Set text color to black
draw_set_halign(fa_center); // Center text horizontally
draw_set_valign(fa_middle); // Center text vertically

var button_width = sprite_width * image_xscale;
var button_height = sprite_height * image_yscale;

var text_x = x + button_width / 2;
var text_y = y + button_height / 2;

draw_text(text_x, text_y, skin_name); // Center the text