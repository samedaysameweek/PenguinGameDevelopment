/// Draw Event for obj_player

// Safety check for required global maps
if (!variable_global_exists("equipped_items") || !ds_exists(global.equipped_items, ds_type_map)) {
    show_debug_message("CRITICAL WARNING: global.equipped_items missing! Reinitializing.");
    exit;
}
if (!variable_global_exists("item_sprite_map") || !ds_exists(global.item_sprite_map, ds_type_map)) {
    show_debug_message("CRITICAL WARNING: global.item_sprite_map missing! Reinitializing.");
    exit;
}

// Common drawing variables
var draw_origin_x = x;
var draw_origin_y = y;
var frame_x, frame_y, frame_width, frame_height;
var final_draw_x, final_draw_y;
var current_sprite_body, current_sprite_color;
var draw_xscale = 1; // Default xscale for drawing

// --- State-Based Drawing Logic ---
if (action_state == "none") {
    // --- Walking/Idle State ---
    current_sprite_body = sprite_body;
    current_sprite_color = sprite_color;
    var frame_index = floor(image_index) mod 3; // 3 frames per direction

    // Validate frame data access for walking
    if (face >= 0 && face < array_length(frame_data) && is_array(frame_data[face]) && array_length(frame_data[face]) > (frame_index * 4 + 3)) {
        // Get the correct frame coordinates DIRECTLY from frame_data based on face
        // This selects the pre-drawn left or right facing frame section
        frame_x = frame_data[face][frame_index * 4];
        frame_y = frame_data[face][frame_index * 4 + 1];
        frame_width = frame_data[face][frame_index * 4 + 2];
        frame_height = frame_data[face][frame_index * 4 + 3];
    } else {
        show_debug_message("Warning: Invalid face/frame_data for walking.");
        frame_x = 0; frame_y = 0; frame_width = 24; frame_height = 24; // Fallback
    }

    // Calculate final drawing position (centering based on frame dimensions)
    // Since frame_data selects the correct L/R frame, xscale is always 1 here.
    final_draw_x = draw_origin_x - (frame_width / 2);
    final_draw_y = draw_origin_y - frame_height / 2;
    draw_xscale = 1; // Explicitly set to 1 for walking state draw calls

    // Draw Base Player (Walking) - Using draw_xscale = 1
    draw_sprite_part_ext(current_sprite_body, 0, frame_x, frame_y, frame_width, frame_height, final_draw_x, final_draw_y, draw_xscale, 1, c_white, 1);
    draw_sprite_part_ext(current_sprite_color, 0, frame_x, frame_y, frame_width, frame_height, final_draw_x, final_draw_y, draw_xscale, 1, global.player_color, 1);

    // Draw Equipped Items (Walking) - Using draw_xscale = 1
    var slots_to_draw = ["body", "face", "head", "neck", "hand", "feet"];
    for (var i = 0; i < array_length(slots_to_draw); i++) {
        var slot = slots_to_draw[i];
        var item_name = global.equipped_items[? slot];
        if (!is_undefined(item_name) && item_name != -1) {
            var item_sprite = ds_map_find_value(global.item_sprite_map, item_name);
            if (!is_undefined(item_sprite) && sprite_exists(item_sprite)) {
                var item_draw_x = final_draw_x;
                var item_draw_y = final_draw_y;
                 if (slot == "head") item_draw_y -= 0; // Adjust offsets as needed
                 if (slot == "face") item_draw_y -= 0;

                // Draw item using the SAME frame coordinates and draw_xscale=1
                draw_sprite_part_ext(item_sprite, 0, frame_x, frame_y, frame_width, frame_height, item_draw_x, item_draw_y, draw_xscale, 1, c_white, 1);
            }
        }
    }

} else {
    // --- Special Action State ---
    // Determine flipping for actions (may differ from walking)
    var action_xscale = (face == LEFT || face == UP_LEFT || face == DOWN_LEFT) ? -1 : 1;

    if (ds_map_exists(action_frame_data, action_state)) {
        var frames = ds_map_find_value(action_frame_data, action_state);
        var frame_count = array_length(frames);
        var frame_index = floor(image_index) mod frame_count;

        if (action_state == "sit") { // Static sit pose needs special frame mapping
            var sit_frame_map = [6, 4, 2, 0, 7, 5, 1, 3]; // Map RIGHT=0 to frame 6, etc.
            if (face >= 0 && face < array_length(sit_frame_map)) {
                 frame_index = clamp(sit_frame_map[face], 0, frame_count - 1);
                 // Sitting doesn't typically flip, override action_xscale
                 action_xscale = 1;
                 // Use frame_data to get sit coords, NOT action_frame_data for sit
                  if (frame_index < array_length(frames) && is_array(frames[frame_index]) && array_length(frames[frame_index]) >= 4) {
                       var frame_data_array = frames[frame_index];
                       frame_x = frame_data_array[0];
                       frame_y = frame_data_array[1];
                       frame_width = frame_data_array[2];
                       frame_height = frame_data_array[3];
                  } else { frame_x = 0; frame_y = 72; frame_width = 24; frame_height = 24; } // Fallback sit frame

            } else {
                 frame_index = 0; // Default sit frame
                 show_debug_message("Warning: Invalid face (" + string(face) + ") for sit animation.");
                 // Use default sit frame data
                 frame_x = 0; frame_y = 72; frame_width = 24; frame_height = 24;
                 action_xscale = 1;
            }
        } else { // Other animated actions
             if (frame_index < array_length(frames) && is_array(frames[frame_index]) && array_length(frames[frame_index]) >= 4) {
                 var frame_data_array = frames[frame_index];
                 frame_x = frame_data_array[0];
                 frame_y = frame_data_array[1];
                 frame_width = frame_data_array[2];
                 frame_height = frame_data_array[3];
             } else {
                  show_debug_message("Warning: Invalid frame_index/data for action '" + action_state + "'.");
                  frame_x = 0; frame_y = 0; frame_width = 24; frame_height = 24; // Fallback
             }
        }

        current_sprite_body = ds_map_find_value(action_sprite_body, action_state);
        current_sprite_color = ds_map_find_value(action_sprite_color, action_state);

        // Calculate final drawing position for action state, considering potential flipping
        final_draw_x = draw_origin_x - (frame_width / 2) * action_xscale; // Use action_xscale
        final_draw_y = draw_origin_y - frame_height / 2;
        draw_xscale = action_xscale; // Use the calculated scale for actions

        // Draw Base Player (Action)
        draw_sprite_part_ext(current_sprite_body, 0, frame_x, frame_y, frame_width, frame_height, final_draw_x, final_draw_y, draw_xscale, 1, c_white, 1);
        draw_sprite_part_ext(current_sprite_color, 0, frame_x, frame_y, frame_width, frame_height, final_draw_x, final_draw_y, draw_xscale, 1, global.player_color, 1);

        // Draw Equipped Items (Action)
        var slots_to_draw = ["body", "face", "head", "neck", "hand", "feet"];
        for (var i = 0; i < array_length(slots_to_draw); i++) {
            var slot = slots_to_draw[i];
            var item_name = global.equipped_items[? slot];
            if (!is_undefined(item_name) && item_name != -1) {
                var item_sprite = ds_map_find_value(global.item_sprite_map, item_name);
                if (!is_undefined(item_sprite) && sprite_exists(item_sprite)) {
                    var item_draw_x = final_draw_x;
                    var item_draw_y = final_draw_y;
                     if (slot == "head") item_draw_y -= 0;
                     if (slot == "face") item_draw_y -= 0;

                    // Draw item using action frame coordinates and draw_xscale
                    draw_sprite_part_ext(item_sprite, 0, frame_x, frame_y, frame_width, frame_height, item_draw_x, item_draw_y, draw_xscale, 1, c_white, 1);
                }
            }
        }
    } else {
        // Fallback if action_state is invalid
        show_debug_message("Warning: Invalid action_state '" + action_state + "' in Draw event. Reverting.");
        action_state = "none";
        // Draw default frame (using xscale = 1)
        frame_x = 0; frame_y = 0; frame_width = 24; frame_height = 24;
        final_draw_x = draw_origin_x - (frame_width / 2);
        final_draw_y = draw_origin_y - frame_height / 2;
        draw_xscale = 1;
        draw_sprite_part_ext(sprite_body, 0, frame_x, frame_y, frame_width, frame_height, final_draw_x, final_draw_y, draw_xscale, 1, c_white, 1);
        draw_sprite_part_ext(sprite_color, 0, frame_x, frame_y, frame_width, frame_height, final_draw_x, final_draw_y, draw_xscale, 1, global.player_color, 1);
    }
}

// --- Depth Sorting ---
set_depth();