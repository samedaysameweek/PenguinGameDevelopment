if (mouse_check_button(mb_left) && position_meeting(mouse_x, mouse_y, id)) {
    image_index = 1;  // Show frame 1 when clicked
} else {
    image_index = 0;  // Revert to frame 0 when not clicked
}
draw_self();

// Set alpha for text to match button
draw_set_alpha(image_alpha);

// Set text alignment
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Calculate text position
var text_x = x + sprite_width / 2;
var text_y = y + sprite_height / 2;

// Draw the button text
draw_set_color(text_color);
draw_set_font(btn_font);
draw_text_ext(text_x, text_y, btn_text, -1, sprite_width - 100);

// Reset alpha and alignment
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);