// Create Event
scale = 2; // Adjust as needed
panel_width = sprite_get_width(spr_colourpicker_panel) * scale;
panel_height = sprite_get_height(spr_colourpicker_panel) * scale;
x = (display_get_gui_width() - panel_width) / 2;
y = (display_get_gui_height() - panel_height) / 2;
depth = -10000;

// Define colors (unchanged)
var c_notblack = make_color_rgb(51, 59, 70);
var c_bluer = make_color_rgb(41, 82, 172);
var c_brown = make_color_rgb(150, 102, 36);
var c_cyan = make_color_rgb(7, 167, 163);
var c_emerald = make_color_rgb(7, 106, 68);
var c_greener = make_color_rgb(6, 155, 77);
var c_lavender = make_color_rgb(176, 126, 194);
var c_lightblue = make_color_rgb(8, 153, 211);
var c_mint = make_color_rgb(189, 252, 201);
var c_oranger = make_color_rgb(232, 94, 28);
var c_pink = make_color_rgb(234, 20, 160);
var c_purpler = make_color_rgb(102, 49, 158);
var c_reder = make_color_rgb(210, 13, 48);
var c_salmon = make_color_rgb(233, 98, 110);
var c_yellower = make_color_rgb(234, 194, 25);

colors = [
    c_notblack, c_bluer, c_brown, c_cyan, c_emerald,
    c_greener, c_lavender, c_lightblue, c_mint, c_oranger,
    c_pink, c_purpler, c_reder, c_salmon, c_yellower
];

// Grid positioning
var grid_width = (5 * 20 + 4 * 5) * scale;
var grid_height = (3 * 20 + 2 * 5) * scale;
start_x = x + 108 * scale + (135 * scale - grid_width) / 2;
start_y = y + 35 * scale + (115 * scale - grid_height) / 2;