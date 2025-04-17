button_ids = [];
var num_buttons = instance_number(obj_menu_button);
for (var i = 0; i < num_buttons; i++) {
    var btn = instance_find(obj_menu_button, i);
    if (btn != noone) {
        button_ids[i] = btn;
    }
}
show_debug_message("Number of buttons found: " + string(array_length(button_ids)));