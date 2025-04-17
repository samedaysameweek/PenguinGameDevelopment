// Draw NPC as usual
draw_self();

// Ensure chat box is drawn above everything
if (talk_timer > 0) {
    // Text setup
    var text = current_phrase;
    var text_scale = 0.5; // Scale factor for text
    var text_padding = 10; // Padding around the text

    // Calculate text dimensions
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    var text_width = string_width(text) * text_scale; // Scaled width of the text
    var text_height = string_height(text) * text_scale; // Scaled height of the text

    // Calculate box dimensions (add padding around the text)
    var box_width = max(64, text_width + text_padding * 2); // Minimum width for aesthetics
    var box_height = text_height + text_padding * 2;

    // Position the box
    var box_x = x - box_width / 2;
    var box_y = y - sprite_height - box_height - 10;

    // Draw 9-slice sprite background
    draw_sprite_stretched(
        spr_menu,     // Sprite
        0,                       // Sub-image index
        box_x,                   // X position
        box_y,                   // Y position
        box_width,               // Scaled width
        box_height               // Scaled height
    );

    // Draw the scaled text
    var text_x = box_x + box_width / 2;
    var text_y = box_y + box_height / 2;
    draw_set_color(c_black);
    draw_text_transformed(text_x, text_y, text, text_scale, text_scale, 0);
}
