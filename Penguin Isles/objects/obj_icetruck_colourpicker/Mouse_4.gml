// Mouse Pressed Event for obj_icetruck_colourpicker
var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

for (var i = 0; i < array_length(colour_slots[i]); i++) {
    var slot_x = x + slot_positions[i][0];
    var slot_y = y + slot_positions[i][1];
    if (point_in_rectangle(mx, my, slot_x, slot_y, slot_x + 17, slot_y + 17)) {
        if (instance_exists(obj_player_icetruck)) {
            obj_player_icetruck.icetruck_tint = color_options[i];
            show_debug_message("Ice truck color changed to: " + string(color_options[i]));
        }
        break;
    }
}