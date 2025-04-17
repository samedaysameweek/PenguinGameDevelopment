if (global.menu_state == "puffle_menu") {
    // Menu options
    var options = ["Adopt", "Cancel"];
    var choice = -1;
    
    // Simple keyboard navigation (expand for mouse if needed)
    if (keyboard_check_pressed(vk_down)) global.menu_index = min(global.menu_index + 1, 1);
    if (keyboard_check_pressed(vk_up)) global.menu_index = max(global.menu_index - 1, 0);
    if (keyboard_check_pressed(vk_enter)) choice = global.menu_index;
    
    // Handle choice
    if (choice == 0) { // Adopt
        global.menu_state = "name_puffle";
        global.menu_index = 0; // Reset for next menu
    } else if (choice == 1) { // Cancel
        global.menu_state = "none";
        global.selected_puffle = noone;
    }
}

if (global.menu_state == "name_puffle") {
    if (keyboard_check_pressed(vk_enter)) {
        var puffle_name = get_string("Enter a name for your puffle:", "Puffle");
        if (puffle_name != "") {
            with (global.selected_puffle) {
                name = puffle_name;
                owner = obj_player; // Mark as adopted
            }
            obj_player.puffle_os -= 1; // Consume one Puffle-O
            global.menu_state = "none";
            global.selected_puffle = noone;
        }
    }
}