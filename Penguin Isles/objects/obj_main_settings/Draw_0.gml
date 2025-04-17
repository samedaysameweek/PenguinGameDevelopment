draw_set_font(fnt_bumbastika_sml);

// Ensure menu_level is valid
if (menu_level < 0 || menu_level >= array_length(option)) {
    show_debug_message("ERROR: Invalid menu_level " + string(menu_level));
    return; // Exit the Draw Event
}

// Dynamically get width and height of menu
var _new_w = 0;
for (var i = 0; i < op_length; i++) {
    if (i < array_length(option[menu_level])) { // Check that index is within bounds
        var _op_w = string_width(option[menu_level][i]);
        _new_w = max(_new_w, _op_w);
    }
}
width = _new_w + op_border * 2;
height = op_border * 4.5 + string_height(option[menu_level][0]) * op_length;

// Center menu
x = camera_get_view_x(view_camera[0]) + (camera_get_view_width(view_camera[0]) - width) / 2;
y = camera_get_view_y(view_camera[0]) + (camera_get_view_height(view_camera[0]) - height) / 2;

// Draw the menu background
draw_sprite_ext(
    spr_pause_menu, 
    0, 
    x, 
    y, 
    width / sprite_get_width(spr_pause_menu), 
    height / sprite_get_height(spr_pause_menu), 
    0, 
    c_white, 
    1
);

// Draw the options
draw_set_valign(fa_top);
draw_set_halign(fa_center);
for (var i = 0; i < op_length; i++) {
    if (i < array_length(option[menu_level])) { // Check bounds again
        var _c = c_white;
        if (pos == i) { 
            _c = c_yellow; // Highlight the option being hovered over
        }
        draw_text_color(
            x + width / 2, 
            y + op_border + op_space * i, 
            option[menu_level][i], // Access using nested arrays
            _c, 
            _c, 
            _c, 
            _c, 
            1
        );
    } else {
        show_debug_message("ERROR: Invalid option index " + string(i) + " for menu_level " + string(menu_level));
    }
}
