// Only draw when the pause menu is active
if (!global.is_pause_menu_active) {
    exit;
}

draw_set_font(fnt_bumbastika_sml);

// Ensure menu_level is valid
// Ensure menu_level is valid
if (menu_level < 0 || menu_level >= array_length(option)) return;

// Dynamically calculate menu width
var _new_w = 0;
for (var i = 0; i < op_length; i++) {
    if (i < array_length(option[menu_level])) {
        _new_w = max(_new_w, string_width(option[menu_level][i]));
    }
}
width = _new_w + op_border * 2;
height = op_border * 4 + string_height(option[menu_level][0]) * op_length;

// Center menu
x = camera_get_view_x(view_camera[0]) + (camera_get_view_width(view_camera[0]) - width) / 2;
y = camera_get_view_y(view_camera[0]) + (camera_get_view_height(view_camera[0]) - height) / 2;

// Draw the menu background
draw_sprite_ext(
    spr_pause_menu, 
    floor(image_index), // Use image_index for animation
    x, 
    y, 
    width / sprite_get_width(spr_pause_menu), 
    height / sprite_get_height(spr_pause_menu), 
    0, 
    c_white, 
    1
);

// Draw menu options
draw_set_valign(fa_top);
draw_set_halign(fa_center);
for (var i = 0; i < op_length; i++) {
    if (i < array_length(option[menu_level])) {
        var color = (pos == i) ? c_yellow : c_white; // Highlight selection
        draw_text_color(x + width / 2, y + op_border + op_space * i, option[menu_level][i], color, color, color, color, 1);
    }
}
