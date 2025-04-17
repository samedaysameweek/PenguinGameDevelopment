// Create Event in obj_menu_button
btn_action = "";             // Action to perform (set via creation code)
btn_text = "";               // Text to display (set via creation code)
btn_font = fnt_bonkfatty;    // Font for button text
text_color = c_black;        // Text color
image_speed = 0;             // Prevent automatic frame switching
image_index = 0;             // Start on frame 0 (normal state)

// Set initial alpha based on room
if (room == rm_main_menu) {
    image_alpha = 0;         // Start invisible for fade-in
} else {
    image_alpha = 1;         // Visible in other rooms
}

// Show "Continue" button only if save file exists
if (btn_action == "continue") {
    visible = file_exists("savegame.sav");
} else {
    visible = true;          // Other buttons are visible by default
}