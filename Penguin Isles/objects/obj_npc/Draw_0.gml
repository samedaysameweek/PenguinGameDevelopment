// Calculate drawing position
var draw_x = x - 12;  // Center 24x24 sprite
var draw_y = y - 12;
var frame_index = floor(image_index) mod 3;  // 3 frames per direction
var frame_x = frame_data[face][frame_index * 4];
var frame_y = frame_data[face][frame_index * 4 + 1];
var frame_width = frame_data[face][frame_index * 4 + 2];
var frame_height = frame_data[face][frame_index * 4 + 3];

// Draw body and colored overlay
draw_sprite_part_ext(sprite_body, 0, frame_x, frame_y, frame_width, frame_height, draw_x, draw_y, 1, 1, c_white, 1);
draw_sprite_part_ext(sprite_color, 0, frame_x, frame_y, frame_width, frame_height, draw_x, draw_y, 1, 1, npc_color, 1);

// Depth sorting
depth = -y;  // Consistent with set_depth()

// Draw the dialogue box if active
if (current_dialogue_index >= 0) {
    // Text and box parameters
    var margin = 8; // Padding around the text
    var max_width = 200; // Maximum width for the dialogue box
    var text_scale = 0.50; // Scale the text smaller

    // Calculate text dimensions
	draw_set_font(fnt_acme_secretagent_bold);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    var text_width = string_width(dialogue[current_dialogue_index]) * text_scale;
    var text_height = string_height(dialogue[current_dialogue_index]) * text_scale;

    // Calculate box dimensions (add padding around the text)
    var box_width = min(max_width, text_width + margin * 2);
    var box_height = text_height + margin * 2;

    // Position the box
    var box_x = x - box_width / 2;
    var box_y = y - sprite_height - box_height - 0.5;

    // Draw 9-slice sprite background
    draw_sprite_stretched(
        spr_chat,     // Sprite
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
    draw_text_transformed(text_x, text_y, dialogue[current_dialogue_index], text_scale, text_scale, 0);
}
