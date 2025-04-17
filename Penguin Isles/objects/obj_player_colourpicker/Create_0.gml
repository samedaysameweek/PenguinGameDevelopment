// Create Event
scale = 2; // General scale factor
panel_width = sprite_get_width(spr_colourpicker_panel) * scale;
panel_height = sprite_get_height(spr_colourpicker_panel) * scale;
x = (display_get_gui_width() - panel_width) / 2; // Center horizontally
y = (display_get_gui_height() - panel_height) / 2; // Center vertically
start_x = 100;   // Starting x position (overridden later)
depth = -10000;  // Ensure it’s drawn on top
is_destroying = false; // Flag to prevent drawing after destruction



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

sprites = [
    spr_colouricon_black, spr_colouricon_blue, spr_colouricon_brown, spr_colouricon_cyan, spr_colouricon_emerald,
    spr_colouricon_green, spr_colouricon_lavendar, spr_colouricon_lightblue, spr_colouricon_mint, spr_colouricon_orange,
    spr_colouricon_pink, spr_colouricon_purple, spr_colouricon_red, spr_colouricon_salmon, spr_colouricon_yellow
];

// Grid positioning for color icons
icon_size = 20 * scale;  // Intended size of icons in pixels (e.g., 30 with scale 1.5)
spacing = 5 * scale;     // Spacing between icons
var cols = 5;
var rows = 3;
var grid_width = (cols * icon_size) + ((cols - 1) * spacing);
var grid_height = (rows * icon_size) + ((rows - 1) * spacing);
start_x = x + 108 * scale + (135 * scale - grid_width) / 2;
start_y = y + 35 * scale + (115 * scale - grid_height) / 2;

// Calculate icon_scale for proper sizing
var original_icon_width = sprite_get_width(sprites[0]); // Assuming all icons have the same size
icon_scale = icon_size / original_icon_width; // Scale to fit icon_size