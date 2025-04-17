// obj_config_menu: Create Event
depth = -10000; // Draw on top of other UI
item_scroll = 0; // Starting position for item list scrolling

// Center the panel
panel_width = sprite_get_width(spr_blue_square_panel);
panel_height = sprite_get_height(spr_blue_square_panel);
panel_x = (display_get_gui_width() - panel_width) / 2;
panel_y = (display_get_gui_height() - panel_height) / 2;