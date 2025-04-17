// obj_chat_window: Mouse Left Pressed Event
if (global.chat_active) {
    // Convert mouse coordinates to GUI coordinates
    var gui_mouse_x = device_mouse_x_to_gui(0);
    var gui_mouse_y = device_mouse_y_to_gui(0);

    // GUI dimensions
    var gui_width = display_get_gui_width();
    var gui_height = display_get_gui_height();
    var menu_width = 300;
    var menu_height = 150;
    var menu_x = (gui_width - menu_width) / 2;
    var menu_y = gui_height - menu_height - 50;

    // Close button logic
    var close_button_size = 20;
    var close_x = menu_x + menu_width - close_button_size - 20;
    var close_y = menu_y + 20;

    if (gui_mouse_x >= close_x && gui_mouse_x <= close_x + close_button_size &&
        gui_mouse_y >= close_y && gui_mouse_y <= close_y + close_button_size) {
        global.chat_active = false;
        global.chat_npc = noone;
        dialog_queue = [];
        show_debug_message("Close button clicked. Chat deactivated.");
        exit;
    }

    // Dialogue choice logic (example)
    if (dialog_index < array_length(dialog_data)) {
        var dialog_entry = dialog_data[dialog_index];
        if (is_struct(dialog_entry) && variable_struct_exists(dialog_entry, "choices") && array_length(dialog_entry.choices) > 0) {
            var button_width = 100;  // Adjust based on your button sprite/size
            var button_height = 30;  // Adjust based on your button sprite/size
            var spacing = 10;
            var choices_y = menu_y + menu_height - button_height - 10;  // Position below dialogue text
            var num_choices = array_length(dialog_entry.choices);
            var total_choices_width = (num_choices * button_width) + ((num_choices - 1) * spacing);
            var choices_start_x = menu_x + (menu_width - total_choices_width) / 2;

            for (var i = 0; i < num_choices; i++) {
                var button_x = choices_start_x + i * (button_width + spacing);
                if (gui_mouse_x >= button_x && gui_mouse_x <= button_x + button_width &&
                    gui_mouse_y >= choices_y && gui_mouse_y <= choices_y + button_height) {
                    choice_selected = i;
                    dialog_index++;  // Advance to next dialogue
                    show_debug_message("Choice " + string(i) + " selected: " + dialog_entry.choices[i]);
                    // Add your action logic here (e.g., start quest, update variables)
                    break;
                }
            }
        }
    }
}