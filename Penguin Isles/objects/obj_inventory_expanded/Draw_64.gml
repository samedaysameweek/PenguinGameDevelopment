// obj_inventory_expanded Draw GUI
var ui_scale = 2.2;

// GUI dimensions
var gui_width = display_get_gui_width();
var gui_height = display_get_gui_height();

// Closed inventory positioning
var closed_width = sprite_get_width(spr_inventory_closed) * ui_scale;
var closed_height = sprite_get_height(spr_inventory_closed) * ui_scale;
var closed_x = (gui_width / 2) - closed_width - 0; // Adjust X position if needed
var closed_y = (gui_height - closed_height) / 2;

// Open inventory positioning
var open_width = sprite_get_width(spr_inventory_open) * ui_scale;
var open_height = sprite_get_height(spr_inventory_open) * ui_scale;
var open_x = closed_x + closed_width - 35; // Adjust X based on sprite overlap/origin
var open_y = closed_y + 21; // Align vertically with closed part

// Draw sprites based on inventory state
if (global.inventory_visible) {
    // --- Draw Closed Panel ---
    draw_sprite_ext(spr_inventory_closed, 0, closed_x, closed_y, ui_scale, ui_scale, 0, c_white, 1);

    // --- Draw Equipped Item Icons in Clothing Slots (on Closed Panel) ---
    var clothing_slots_rel = [[9, 20], [9, 40], [9, 60], [9, 80], [9, 100], [9, 120]]; // Relative positions
    var slot_types = ["head", "face", "neck", "body", "hand", "feet"];
    var slot_pixel_size = 18 * ui_scale; // Visual size of the slot

    // Safety check for maps
    var equipped_map_exists = ds_exists(global.equipped_items, ds_type_map);
    var index_map_exists = ds_exists(global.item_index_map, ds_type_map);

    if (!equipped_map_exists) { show_debug_message("Draw GUI Error: global.equipped_items missing!"); }
    if (!index_map_exists) { show_debug_message("Draw GUI Error: global.item_index_map missing!"); }

    //show_debug_message("--- Drawing Equipped Slots ---"); // Log start of drawing equipped slots

    for (var i = 0; i < array_length(slot_types); i++) {
        var current_slot_type = slot_types[i];
        var slot_screen_x = closed_x + clothing_slots_rel[i][0] * ui_scale;
        var slot_screen_y = closed_y + clothing_slots_rel[i][1] * ui_scale;
        var item_name = -1; // Default to empty

        // Safely get item name from the map
        if (equipped_map_exists && ds_map_exists(global.equipped_items, current_slot_type)) {
             item_name = global.equipped_items[? current_slot_type];
        } else if (equipped_map_exists) {
             // This case means the slot itself doesn't exist in the map, which is an init error
             show_debug_message("Draw GUI Warning: Slot '" + current_slot_type + "' not found in global.equipped_items map!");
        }

        // ** ADDED DEBUGGING **
        //show_debug_message("Draw GUI: Checking slot '" + current_slot_type + "'. Found item name: " + string(item_name));

        if (!is_undefined(item_name) && item_name != -1) { // Check if slot has an item name
            var item_index_val = -1;
            // Safely get item index from name
            if (index_map_exists && ds_map_exists(global.item_index_map, item_name)) {
                 item_index_val = ds_map_find_value(global.item_index_map, item_name);
            } else if (index_map_exists) {
                 show_debug_message("Draw GUI Warning: Item name '" + item_name + "' not found in global.item_index_map!");
            }

             // ** ADDED DEBUGGING **
             show_debug_message("Draw GUI: Item '" + item_name + "' corresponds to index value: " + string(item_index_val));

            if (!is_undefined(item_index_val) && item_index_val != -1) {
                // Calculate sprite sheet offsets for spr_inventory_items
                var x_offset = (item_index_val < 21) ? item_index_val * 18 : (item_index_val - 21) * 18;
                var y_offset = (item_index_val < 21) ? 0 : 18; // Assuming second row starts at index 21
                var item_icon_width = 18;
                var item_icon_height = 18;

                 // ** ADDED DEBUGGING **
                 show_debug_message("Draw GUI: Drawing icon for '" + item_name + "' (Index: " + string(item_index_val) + ") at slot '" + current_slot_type + "'");

                // Draw the item icon using sprite part
                draw_sprite_part_ext(spr_inventory_items, 0,
                                     x_offset, y_offset, item_icon_width, item_icon_height,
                                     slot_screen_x, slot_screen_y,
                                     ui_scale, ui_scale, // Apply scale to the drawn part
                                     c_white, 1);
            } else {
                // This else block was previously inside the item_name != -1 check, moved out
                // show_debug_message("Draw GUI: No valid item index for name '" + string(item_name) + "' in slot: " + current_slot_type);
            }
        } else {
             // ** ADDED DEBUGGING ** (This message confirms the slot is seen as empty by Draw GUI)
             // show_debug_message("Draw GUI: No item equipped or name is invalid (-1 or undefined) in slot: " + current_slot_type);
        }
    }
     //show_debug_message("--- Finished Drawing Equipped Slots ---"); // Log end

    // --- Draw Character Viewer (Keep as is) ---
    var viewer_left = closed_x + 31 * ui_scale;
    var viewer_top = closed_y + 21 * ui_scale;
    var viewer_width = (105 - 31) * ui_scale;
    var viewer_height = (135 - 21) * ui_scale;
    var char_scale = 3; // Adjusted scale for better visibility in viewer
    var frame_width = 24;
    var frame_height = 24;
    var scaled_width = frame_width * char_scale;
    var scaled_height = frame_height * char_scale;
    var draw_char_x = viewer_left + (viewer_width - scaled_width) / 2;
    var draw_char_y = viewer_top + (viewer_height - scaled_height) / 2;
    var frame_x = 0; // Default DOWN frame for preview
    var frame_y = 0;

    // Simplified preview drawing logic
     if (global.current_skin == "player" || global.current_skin == "tube" || global.current_skin == "toboggan") {
         var body_spr = spr_player_body;
         var color_spr = spr_player_colour;
         if (global.current_skin == "tube" || global.current_skin == "toboggan") {
             frame_y = 72; // Sitting pose Y offset
             var vehicle_spr = (global.current_skin == "tube") ? spr_tube_sheet : spr_toboggan_sheet;
             var vehicle_frame_x = (global.current_skin == "tube") ? 24 : 48; // Example frame for tube/toboggan facing down
             draw_sprite_part_ext(vehicle_spr, 0, vehicle_frame_x, 0, frame_width, frame_height, draw_char_x, draw_char_y, char_scale, char_scale, c_white, 1);
         }
         draw_sprite_part_ext(body_spr, 0, frame_x, frame_y, frame_width, frame_height, draw_char_x, draw_char_y, char_scale, char_scale, c_white, 1);
         draw_sprite_part_ext(color_spr, 0, frame_x, frame_y, frame_width, frame_height, draw_char_x, draw_char_y, char_scale, char_scale, global.player_color, 1);
     } else if (global.current_skin == "icetruck" && instance_exists(obj_player_icetruck)) {
         frame_width = 48; frame_height = 48; // Icetruck sprite size
         scaled_width = frame_width * char_scale; scaled_height = frame_height * char_scale;
         draw_char_x = viewer_left + (viewer_width - scaled_width) / 2;
         draw_char_y = viewer_top + (viewer_height - scaled_height) / 2;
         draw_sprite_part_ext(spr_icetruck_base, 0, frame_x, frame_y, frame_width, frame_height, draw_char_x, draw_char_y, char_scale, char_scale, c_white, 1);
         draw_sprite_part_ext(spr_icetruck_colour, 0, frame_x, frame_y, frame_width, frame_height, draw_char_x, draw_char_y, char_scale, char_scale, obj_player_icetruck.icetruck_tint, 1);
         draw_sprite_part_ext(spr_icetruck_penguin_colour, 0, frame_x, frame_y, frame_width, frame_height, draw_char_x, draw_char_y, char_scale, char_scale, global.player_color, 1);
         draw_sprite_part_ext(spr_icetruck_window, 0, frame_x, frame_y, frame_width, frame_height, draw_char_x, draw_char_y, char_scale, char_scale, c_white, 1);
     }
     // --- Add Drawing for Equipped Items on Preview Character ---
     // Similar logic to obj_player Draw event, but drawing relative to draw_char_x, draw_char_y and using char_scale
     if (ds_exists(global.item_sprite_map, ds_type_map)) {
        var preview_slots = ["body", "face", "head"]; // Slots to show on preview
        for (var j = 0; j < array_length(preview_slots); j++) {
            var slot = preview_slots[j];
            var item_name = global.equipped_items[? slot];
             if (!is_undefined(item_name) && item_name != -1) {
                var item_sprite = ds_map_find_value(global.item_sprite_map, item_name);
                 if (!is_undefined(item_sprite) && sprite_exists(item_sprite)) {
                     // Use simplified drawing for preview - assuming item sprites match player frame structure for DOWN pose
                     var item_frame_x = 0; // Down pose X
                     var item_frame_y = 0; // Down pose Y
                     var item_frame_width = 24; // Assuming 24x24 base
                     var item_frame_height = 24;
                     var item_draw_x = draw_char_x; // Adjust offsets as needed
                     var item_draw_y = draw_char_y;
                      if (slot == "head") item_draw_y -= 0 * char_scale; // Example offset
                      if (slot == "face") item_draw_y -= 0 * char_scale; // Example offset

                     draw_sprite_part_ext(item_sprite, 0, item_frame_x, item_frame_y, item_frame_width, item_frame_height, item_draw_x, item_draw_y, char_scale, char_scale, c_white, 1);
                 }
             }
        }
     }


    // --- Draw Open Panel and Inventory Grid ---
    if (global.inventory_open_state == "open") {
        draw_sprite_ext(spr_inventory_open, 0, open_x, open_y, ui_scale, ui_scale, 0, c_white, 1);

        // Inventory grid parameters
        var grid_start_x_rel = 3;
        var grid_start_y_rel = 6;
        var slot_pixel_width = 20 * ui_scale;
        var slot_pixel_height = 20 * ui_scale;
        var grid_cols = 7;
        var grid_rows = 6;
        var item_icon_width = 18; // Original size in spr_inventory_items
        var item_icon_height = 18;
        var item_scale = ui_scale; // Scale item icons same as UI

        // Draw inventory grid items
        for (var row = 0; row < grid_rows; row++) {
            for (var col = 0; col < grid_cols; col++) {
                var inventory_index = row * grid_cols + col;
                if (inventory_index < array_length(obj_inventory.inventory)) { // Ensure index is within bounds
                    var item_index_val = obj_inventory.inventory[inventory_index]; // Get item numerical index

                    if (item_index_val != -1) { // Check if slot is not empty
                        // Calculate sprite sheet offsets for spr_inventory_items
                        var x_offset = (item_index_val < 21) ? item_index_val * item_icon_width : (item_index_val - 21) * item_icon_width;
                        var y_offset = (item_index_val < 21) ? 0 : item_icon_height; // Assuming second row starts at index 21

                        // Calculate draw position for the item icon
                        var item_draw_x = open_x + grid_start_x_rel * ui_scale + col * slot_pixel_width + (slot_pixel_width - item_icon_width * item_scale) / 2; // Center icon in slot
                        var item_draw_y = open_y + grid_start_y_rel * ui_scale + row * slot_pixel_height + (slot_pixel_height - item_icon_height * item_scale) / 2; // Center icon in slot

                        // Draw the item icon sprite part
                        draw_sprite_part_ext(
                            spr_inventory_items, 0,
                            x_offset, y_offset, item_icon_width, item_icon_height,
                            item_draw_x, item_draw_y,
                            item_scale, item_scale, // Apply scale
                            c_white, 1
                        );
                    }
                }
            }
        }
    }
}