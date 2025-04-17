// Define custom colors
var c_notblack = make_color_rgb(51, 51, 51);
var c_bluer = make_color_rgb(46, 71, 170);
var c_brown = make_color_rgb(153, 102, 0);
var c_cyan = make_color_rgb(7, 167, 163);
var c_emerald = make_color_rgb(7, 106, 68);
var c_greener = make_color_rgb(6, 155, 77);
var c_lavender = make_color_rgb(176, 126, 194);
var c_lightblue = make_color_rgb(8, 153, 211);
var c_mint = make_color_rgb(189, 252, 201);
var c_oranger = make_color_rgb(255, 102, 0);
var c_pink = make_color_rgb(255, 51, 153);
var c_purpler = make_color_rgb(102, 49, 158);
var c_reder = make_color_rgb(204, 0, 0);
var c_salmon = make_color_rgb(255, 67, 63);
var c_yellower = make_color_rgb(255, 204, 0);

// Colors array
var colors = [
    c_notblack, c_bluer, c_brown, c_cyan, c_emerald,
    c_greener, c_lavender, c_lightblue, c_mint, c_oranger,
    c_pink, c_purpler, c_reder, c_salmon, c_yellower
];

// Sprites for color icons
var sprites = [
    spr_colouricon_black, spr_colouricon_blue, spr_colouricon_brown, spr_colouricon_cyan, spr_colouricon_emerald,
    spr_colouricon_green, spr_colouricon_lavendar, spr_colouricon_lightblue, spr_colouricon_mint, spr_colouricon_orange,
    spr_colouricon_pink, spr_colouricon_purple, spr_colouricon_red, spr_colouricon_salmon, spr_colouricon_yellow
];

// Grid dimensions
var cols = 5;
var rows = 3;
var spacing = 70; // Distance between grid items
var start_x = room_width / 2.2 - ((cols - 1) * spacing) / 2;
var start_y = room_height / 2.2 - ((rows - 1) * spacing) / 2;

// Create the grid
for (var i = 0; i < array_length(colors); i++) { // Use array_length explicitly
    var x_pos = start_x + (i mod cols) * spacing;
    var y_pos = start_y + (i div cols) * spacing;

    // Create color icon instance
    var color_icon = instance_create_layer(x_pos, y_pos, "Instances", obj_color_icon);
    color_icon.icon_color = colors[i];       // Assign color
    color_icon.sprite_index = sprites[i];    // Assign corresponding sprite
}
