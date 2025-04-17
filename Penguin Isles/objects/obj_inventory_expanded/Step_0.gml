// obj_inventory_expanded: Step Event
var ui_scale = 2.2;
var gui_mouse_x = device_mouse_x_to_gui(0);
var gui_mouse_y = device_mouse_y_to_gui(0);

// Positioning Calculations (Keep consistent with Draw Event)
var closed_width = sprite_get_width(spr_inventory_closed) * ui_scale;
var closed_height = sprite_get_height(spr_inventory_closed) * ui_scale;
var closed_x = (display_get_gui_width() / 2) - closed_width - 0;
var closed_y = (display_get_gui_height() - closed_height) / 2;

var open_width = sprite_get_width(spr_inventory_open) * ui_scale;
var open_height = sprite_get_height(spr_inventory_open) * ui_scale;
var open_x = closed_x + closed_width - 35;
var open_y = closed_y;

// Button Click Handling
if (global.inventory_visible && mouse_check_button_pressed(mb_left)) {

    // Open/Close Expanded Inventory Logic (Same as before)
    if (global.inventory_open_state == "closed") {
        var open_left = closed_x + 117 * ui_scale;
        var open_top = closed_y + 61 * ui_scale;
        var open_right = closed_x + 125 * ui_scale;
        var open_bottom = closed_y + 93 * ui_scale;
        if (point_in_rectangle(gui_mouse_x, gui_mouse_y, open_left, open_top, open_right, open_bottom)) {
            show_debug_message("DEBUG: Opening expanded inventory pane.");
            global.inventory_open_state = "open";
            global.click_handled = true;
            exit;
        }
    } else if (global.inventory_open_state == "open") {
        var close_left = open_x + 144 * ui_scale;
        var close_top = open_y + 47 * ui_scale;
        var close_right = open_x + 152 * ui_scale;
        var close_bottom = open_y + 79 * ui_scale;
        if (point_in_rectangle(gui_mouse_x, gui_mouse_y, close_left, close_top, close_right, close_bottom)) {
            show_debug_message("DEBUG: Closing expanded inventory pane.");
            global.inventory_open_state = "closed";
            global.click_handled = true;
            exit;
        }
    }

    // Close All Inventory Button (Same as before)
    var close_all_left = closed_x + 47 * ui_scale;
    var close_all_top = closed_y + 3 * ui_scale;
    var close_all_right = closed_x + 89 * ui_scale;
    var close_all_bottom = closed_y + 11 * ui_scale;
    if (point_in_rectangle(gui_mouse_x, gui_mouse_y, close_all_left, close_all_top, close_all_right, close_all_bottom)) {
        show_debug_message("DEBUG: Closing inventory UI completely.");
        global.inventory_visible = false;
        global.inventory_open_state = "closed";
        global.game_paused = false;
        instance_destroy();
        global.click_handled = true;
        exit;
    }

    // Equip item by clicking on inventory slot (in the OPEN pane)
    if (global.inventory_open_state == "open") {
        var grid_start_x_rel = 3;
        var grid_start_y_rel = 6;
        var slot_pixel_width = 20 * ui_scale;
        var slot_pixel_height = 20 * ui_scale;
        var grid_cols = 7;
        var grid_rows = 6;

        for (var row = 0; row < grid_rows; row++) {
            for (var col = 0; col < grid_cols; col++) {
                var slot_screen_x1 = open_x + grid_start_x_rel * ui_scale + col * slot_pixel_width;
                var slot_screen_y1 = open_y + grid_start_y_rel * ui_scale + row * slot_pixel_height;
                var slot_screen_x2 = slot_screen_x1 + slot_pixel_width;
                var slot_screen_y2 = slot_screen_y1 + slot_pixel_height;

                if (point_in_rectangle(gui_mouse_x, gui_mouse_y, slot_screen_x1, slot_screen_y1, slot_screen_x2, slot_screen_y2)) {
                    show_debug_message("Clicked grid slot (" + string(col) + ", " + string(row) + ")");
                    var inventory_index = row * grid_cols + col;

                    if (inventory_index < array_length(obj_inventory.inventory)) {
                        var item_index_val = obj_inventory.inventory[inventory_index];
                        show_debug_message("Slot " + string(inventory_index) + " contains item index value: " + string(item_index_val));

                        if (item_index_val != -1) {
                            var item_name = "";
                            var map_keys = ds_map_keys_to_array(global.item_index_map);
                            for (var k = 0; k < array_length(map_keys); k++) {
                                if (ds_map_find_value(global.item_index_map, map_keys[k]) == item_index_val) {
                                    item_name = map_keys[k];
                                    break;
                                }
                            }

                            if (item_name != "") {
                                show_debug_message("Item name found: '" + item_name + "'");
                                var item_type = ds_map_find_value(global.item_type_map, item_name);

                                if (!is_undefined(item_type)) {
                                    show_debug_message("Item type: '" + item_type + "'");
                                    if (ds_map_exists(global.equipped_items, item_type)) {
                                        show_debug_message("Attempting to equip '" + item_name + "' to slot '" + item_type + "'");

                                        // 1. Check if something is already equipped
                                        var current_equipped_name = global.equipped_items[? item_type];
                                        if (current_equipped_name != -1 && !is_undefined(current_equipped_name)) {
                                            unequip_item(item_type); // Unequip visually/logically

                                            // *** CRASH FIX HERE ***
                                            // Add the unequipped item back using the CORRECT function
                                            if (instance_exists(obj_inventory)) {
                                                var added_back = obj_inventory.inventory_add(current_equipped_name); // Use inventory_add
                                                if (added_back) {
                                                     show_debug_message("Unequipped '" + current_equipped_name + "' and returned to inventory via obj_inventory.");
                                                } else {
                                                     show_debug_message("Failed to return '" + current_equipped_name + "' to inventory (maybe full?). Equipping anyway.");
                                                }
                                            } else {
                                                show_debug_message("ERROR: obj_inventory not found during equip->unequip step!");
                                            }
                                        }

                                        // 2. Equip the new item
                                        equip_item(item_type, item_name);

                                        // 3. Remove the newly equipped item from inventory
                                        if (instance_exists(obj_inventory)) {
                                            obj_inventory.inventory[inventory_index] = -1; // Direct removal since we know the index
                                            show_debug_message("Removed '" + item_name + "' directly from inventory array slot " + string(inventory_index));
                                            // Trigger inventory update event if needed
                                            event_perform(ev_other, ev_user0); // Optional: notify systems of change
                                        } else {
                                            show_debug_message("ERROR: obj_inventory not found during equip->remove step!");
                                        }

                                        global.click_handled = true;
                                        exit;

                                    } else {
                                        show_debug_message("Cannot equip '" + item_name + "': Slot type '" + item_type + "' does not exist in equipped_items map.");
                                    }
                                } else {
                                    show_debug_message("Item '" + item_name + "' is not equippable (no type found).");
                                }
                            } else {
                                show_debug_message("Error: Could not find item name for index value: " + string(item_index_val));
                            }
                        } else {
                            show_debug_message("Clicked empty inventory slot " + string(inventory_index));
                        }
                    }
                    global.click_handled = true;
                    exit;
                }
            }
        }
    } // End of open state check for equipping

    // Unequip item by clicking on equipped slot (on the CLOSED pane)
    var clothing_slots_rel = [[9, 20], [9, 40], [9, 60], [9, 80], [9, 100], [9, 120]];
    var slot_types = ["head", "face", "neck", "body", "hand", "feet"];
    var slot_pixel_size = 18 * ui_scale;

    for (var i = 0; i < array_length(slot_types); i++) {
        var slot_screen_x = closed_x + clothing_slots_rel[i][0] * ui_scale;
        var slot_screen_y = closed_y + clothing_slots_rel[i][1] * ui_scale;

        if (point_in_rectangle(gui_mouse_x, gui_mouse_y, slot_screen_x, slot_screen_y, slot_screen_x + slot_pixel_size, slot_screen_y + slot_pixel_size)) {
            var slot_to_unequip = slot_types[i];
            var equipped_item_name = global.equipped_items[? slot_to_unequip];

            if (equipped_item_name != -1 && !is_undefined(equipped_item_name)) {
                show_debug_message("Clicked equipped slot: '" + slot_to_unequip + "', Item: '" + equipped_item_name + "'");

                unequip_item(slot_to_unequip); // Unequip visually/logically

                // *** CRASH FIX HERE ***
                // Add the unequipped item back using the CORRECT function
                if (instance_exists(obj_inventory)) {
                    var added_back = obj_inventory.inventory_add(equipped_item_name); // Use inventory_add
                    if (added_back) {
                         show_debug_message("Returned '" + equipped_item_name + "' to inventory via obj_inventory.");
                    } else {
                         show_debug_message("Inventory full! Failed to return '" + equipped_item_name + "'. Item lost.");
                    }
                } else {
                    show_debug_message("ERROR: obj_inventory not found during unequip!");
                }

                global.click_handled = true;
                exit;
            } else {
                show_debug_message("Clicked empty equipped slot: '" + slot_to_unequip + "'");
            }
            global.click_handled = true;
            exit;
        }
    }
} // End of mouse_check_button_pressed

// Close inventory with "I" key (Same as before)
if (keyboard_check_pressed(ord("I"))) {
    show_debug_message("DEBUG: Closing inventory UI with 'I' key.");
    global.inventory_visible = false;
    global.inventory_open_state = "closed";
    global.game_paused = false;
    instance_destroy();
}

// Special actions and animation logic (Unchanged)
if (keyboard_check_pressed(ord("H"))) {
    character_action = "dance";
    character_image_index = 0;
} else if (keyboard_check_pressed(ord("J"))) {
    character_action = "wave";
    character_image_index = 0;
} else if (keyboard_check_pressed(ord("K"))) {
    character_action = "none";
    character_image_index = 0;
} else if (keyboard_check_pressed(ord("B")) && instance_exists(obj_inventory) && obj_inventory.inventory_has("Jackhammer")) {
    character_action = "jackhammer";
    character_image_index = 0;
} else if (keyboard_check_pressed(ord("N")) && instance_exists(obj_inventory) && obj_inventory.inventory_has("Snow Shovel")) {
    character_action = "snowshovel";
    character_image_index = 0;
}

// Animate the character in the preview (Unchanged)
if (character_action != "none") {
    if (ds_map_exists(global.player_instance.action_anim_speed, character_action)){
        var anim_speed = ds_map_find_value(global.player_instance.action_anim_speed, character_action);
        character_image_index += anim_speed;
         if (ds_map_exists(global.player_instance.action_frame_data, character_action)){
            var frames = ds_map_find_value(global.player_instance.action_frame_data, character_action);
            if (is_array(frames) && array_length(frames) > 0 && character_image_index >= array_length(frames)) {
                character_image_index = 0;
            }
         }
    }
} else {
    character_image_index += 0.15; // Idle animation speed
    if (character_image_index >= 3) character_image_index = 0; // Assuming 3 idle frames
}