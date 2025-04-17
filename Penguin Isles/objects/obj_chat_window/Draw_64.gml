// obj_chat_window: Draw GUI Event
if (global.chat_active && array_length(dialog_data) > 0 && global.chat_npc != noone) {
    // Get GUI dimensions (matches viewport: 288x216)
    var gui_width = display_get_gui_width();  // 288
    var gui_height = display_get_gui_height(); // 216

    // Get original window sprite size
    var orig_width = sprite_get_width(spr_npc_dialouge_full_window);
    var orig_height = sprite_get_height(spr_npc_dialouge_full_window);

    // Calculate scale to fill viewport width (288 pixels)
    var window_scale = gui_width / orig_width; // e.g., 288 / 100 = 2.88

    // Check height constraint (ensure it fits within 216 pixels)
    var scaled_height = orig_height * window_scale;
    if (scaled_height > gui_height) {
        window_scale = gui_height / orig_height;
    }

    // Recalculate scaled dimensions
    var scaled_width = orig_width * window_scale;
    scaled_height = orig_height * window_scale;

    // Calculate window position: centered horizontally, touching the bottom
    var window_x = (gui_width - scaled_width) / 2;
    var window_y = gui_height - scaled_height;

    // Draw the dialogue window (scaled to fill width)
    draw_sprite_ext(spr_npc_dialouge_full_window, 0, window_x, window_y, window_scale, window_scale, 0, c_white, 1);

    // Draw NPC portrait (shifted 2 units left and up, scaled)
    var portrait_x = window_x + 2 * window_scale;
    var portrait_y = window_y + 2 * window_scale;
    draw_sprite_ext(spr_npc_dialouge_full_colour_portrait, 0, portrait_x, portrait_y, window_scale, window_scale, 0, global.chat_npc.npc_color, 1);
    draw_sprite_ext(spr_npc_dialouge_full_outline_portrait, 0, portrait_x, portrait_y, window_scale, window_scale, 0, c_white, 1);

    // Set font
    draw_set_font(fnt_bonkfatty);

    // Draw dialogue text (scaled positions) with validation
    var text_x = window_x + 77 * window_scale;
    var text_y = window_y + 20 * window_scale;
    var max_text_width = (256 - 77) * window_scale;
    var separation = 20 * window_scale;

    if (dialog_data != undefined && dialog_index < array_length(dialog_data)) {
        var dialog_entry = dialog_data[dialog_index];

        if (is_struct(dialog_entry) && variable_struct_exists(dialog_entry, "text") && is_string(dialog_entry.text)) {
            // Draw the dialogue text
            draw_set_color(c_black);
            draw_text_ext(text_x, text_y, dialog_entry.text, separation, max_text_width);
        } else {
            // Log an error if the data is invalid
            show_debug_message("ERROR: Invalid dialog_data entry or missing 'text' property at index " + string(dialog_index));
        }

        // Draw dialogue choices if available
        if (is_struct(dialog_entry) && variable_struct_exists(dialog_entry, "choices") && array_length(dialog_entry.choices) > 0) {
            // Define button height before using it
            var button_height = sprite_get_height(spr_button) * window_scale;
            var choices_y = window_y - button_height - 10 * window_scale;

            // Button and chat sprite sizes
            var button_width = sprite_get_width(spr_button) * window_scale;
            var chat_width = sprite_get_width(spr_chat) * window_scale;
            var chat_height = sprite_get_height(spr_chat) * window_scale;
            var spacing = 10 * window_scale;

            var num_choices = array_length(dialog_entry.choices);
            var total_choices_width = (num_choices * button_width) + ((num_choices - 1) * spacing);
            var choices_start_x = window_x + (scaled_width - total_choices_width) / 2;

            for (var i = 0; i < num_choices; i++) {
                var button_x = choices_start_x + i * (button_width + spacing);
                // Draw spr_button as background
                draw_sprite_ext(spr_button, 0, button_x, choices_y, window_scale, window_scale, 0, c_white, 1);
                // Center spr_chat within spr_button
                var chat_x = button_x + (button_width - chat_width) / 2;
                var chat_y = choices_y + (button_height - chat_height) / 2;
                draw_sprite_ext(spr_chat, 0, chat_x, chat_y, window_scale, window_scale, 0, c_white, 1);
                // Draw choice text centered in spr_chat
                draw_set_color(i == choice_selected ? c_red : c_black);
                draw_set_halign(fa_center);
                draw_set_valign(fa_middle);
                draw_text(chat_x + chat_width / 2, chat_y + chat_height / 2, dialog_entry.choices[i]);
                draw_set_halign(fa_left);
                draw_set_valign(fa_top);
            }
        }
    } else {
        // Log an error if the index or data is invalid
        show_debug_message("ERROR: dialog_data is undefined or dialog_index out of bounds. Index: " + string(dialog_index));
    }
}