
// Deselect all other color icons
with (obj_color_icon) {
    image_index = 0; // Not selected
    is_selected = false;
}

// Select this icon
image_index = 1; // Selected
is_selected = true;

// Set global player color
global.player_color = icon_color;
global.last_player_color = global.player_color; // Save the choice persistently


// Ensure this icon is assigned a valid color
if (icon_color == undefined) {
    show_debug_message("ERROR: Icon color is undefined in obj_color_icon.");
    icon_color = c_white; // Default to white
}

