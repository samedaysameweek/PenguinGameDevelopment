// In obj_chat_window Step Event
if (global.chat_active) {
    if (dialog_index < array_length(dialog_data)) {
        var current_dialog = dialog_data[dialog_index];
        
        // Check condition for dialogue (if it exists)
        if (variable_struct_exists(current_dialog, "condition")) {
            if (!current_dialog.condition()) {
                dialog_index++;  // Skip if condition fails
                exit;
            }
        }
        
        // Handle choices if they exist
        if (variable_struct_exists(current_dialog, "choices")) {
            if (keyboard_check_pressed(vk_up)) {
                choice_selected = max(choice_selected - 1, 0);
            }
            if (keyboard_check_pressed(vk_down)) {
                choice_selected = min(choice_selected + 1, array_length(current_dialog.choices) - 1);
            }
            if (keyboard_check_pressed(vk_space)) {
                if (choice_selected >= 0) {
                    // Handle quest actions
                    if (variable_struct_exists(current_dialog, "quest")) {
                        var quest = current_dialog.quest;
                        with (global.chat_npc) {
                            if (quest.action == "start") {
                                quest_stage = 1;  // Quest started
                            } else if (quest.action == "complete") {
                                // Add your inventory check here (e.g., player has quest_item)
                                quest_stage = 2;  // Quest completed
                                // Add reward logic here
                            }
                        }
                    }
                    dialog_index++;  // Move to next dialogue
                    choice_selected = -1;
                }
            }
        } else {
            if (keyboard_check_pressed(vk_space)) {
                dialog_index++;  // Advance to next line
            }
        }
    } else {
        // Dialogue ended
        global.chat_active = false;
        instance_destroy();
    }
}