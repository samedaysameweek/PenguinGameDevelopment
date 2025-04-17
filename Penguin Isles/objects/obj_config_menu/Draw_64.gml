//obj_config_menu Draw GUI event
// Draw background
draw_sprite(spr_blue_square_panel, 0, panel_x, panel_y);

// Skin buttons
var title = "Skins";
var title_width = string_width(title);
draw_text(panel_x + 20 + (100 - title_width) / 2, panel_y + 20, title);
var button_y = panel_y + 40;
for (var i = 0; i < array_length(global.skins); i++) {
    draw_set_color(c_white);
    draw_rectangle(panel_x + 20, button_y, panel_x + 120, button_y + 30, false); // 100x30 rectangle
    draw_set_color(c_black);
    var text = "Switch to " + global.skins[i].name;
    var text_width = string_width(text);
    var text_height = string_height(text);
    var text_x = panel_x + 20 + (100 - text_width) / 2; // Center horizontally
    var text_y = button_y + (30 - text_height) / 2; // Center vertically
    draw_text(text_x, text_y, text);
    button_y += 40;
}

// Item buttons with sprites
draw_set_color(c_black);
draw_text(panel_x + 170, panel_y + 20, "Items");
var items = ["Beta Hat", "Party Hat", "Wrench", "Tube", "Toboggan", "Battery", "Spy Phone", "Broken Spy Phone", "EPF Phone", "Fishing Rod", "Jackhammer", "Snow Shovel", "Pizza Slice", "Puffle O", "Box Puffle O", "Fish", "Mullet", "Wood", "Snow"];
var item_display_count = 5;
button_y = panel_y + 40;
for (var i = item_scroll; i < item_scroll + item_display_count && i < array_length(items); i++) {
    var square_x = panel_x + 150;
    var square_y = button_y;
    draw_set_color(c_white);
    draw_rectangle(square_x, square_y, square_x + 30, square_y + 30, false); // 30x30 square
    var item_index = ds_map_find_value(global.item_index_map, items[i]);
    if (!is_undefined(item_index)) {
        draw_sprite_part(spr_inventory_items, 0, item_index * 18, 0, 18, 18, square_x + 6, square_y + 6); // Centered sprite
    }
    button_y += 40;
}

// Scroll buttons
draw_set_color(c_white);
draw_rectangle(panel_x + 190, panel_y + 40, panel_x + 210, panel_y + 60, false); // Up button
draw_rectangle(panel_x + 190, panel_y + 60, panel_x + 210, panel_y + 80, false); // Down button
draw_set_color(c_black);
draw_text(panel_x + 200, panel_y + 45, "^");
draw_text(panel_x + 200, panel_y + 65, "v");

// Color picker buttons
draw_set_color(c_black);
draw_text(panel_x + 220, panel_y + 20, "Colors");
draw_set_color(c_white);
draw_rectangle(panel_x + 220, panel_y + 40, panel_x + 320, panel_y + 70, false);  // Player Color button
draw_set_color(c_black);
draw_set_halign(fa_center);
draw_text(panel_x + 270, panel_y + 55, "Player Color");
draw_set_color(c_white);
draw_rectangle(panel_x + 220, panel_y + 80, panel_x + 320, panel_y + 110, false); // Icetruck Color button
draw_set_color(c_black);
draw_text(panel_x + 270, panel_y + 95, "Icetruck Color");
draw_set_halign(fa_left);

// Close button
draw_set_color(c_red);
draw_rectangle(panel_x + panel_width - 30, panel_y + 10, panel_x + panel_width - 10, panel_y + 30, false);
draw_set_color(c_white);
draw_set_halign(fa_center);
draw_text(panel_x + panel_width - 20, panel_y + 12, "X"); // Center of 20x20 button
draw_set_halign(fa_left); // Reset to default


//npc dialouge code!!
if (global.chat_active && array_length(dialog_data) > 0 && variable_struct_exists(current_dialog, "choices") && array_length(current_dialog.choices) > 0) {
    var gui_width = display_get_gui_width();
    var gui_height = display_get_gui_height();
    
    // Determine inventory height based on HUD state
    var inventory_height;
    if (instance_exists(obj_hud_expanded) && global.is_expanded) {
        inventory_height = sprite_get_height(spr_hud_expanded) * 3; // Assuming ui_scale = 3
    } else {
        inventory_height = 50; // Default height for regular inventory
    }
    
    // Position choices above inventory
    var choices_y = gui_height - inventory_height - 20; // 20px buffer
    var num_choices = array_length(current_dialog.choices);
    var choice_width = 100; // Fixed width per choice
    var spacing = 10; // Space between choices
    var total_width = choice_width * num_choices + spacing * (num_choices - 1);
    var start_x = (gui_width - total_width) / 2; // Center horizontally

    // Draw each choice
    for (var i = 0; i < num_choices; i++) {
        var choice_x = start_x + i * (choice_width + spacing);
        draw_set_color(i == choice_selected ? c_red : c_black);
        draw_text(choice_x, choices_y, current_dialog.choices[i]);
    }
}