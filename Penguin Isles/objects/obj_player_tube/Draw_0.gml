// --- obj_player_tube: Draw Event (Draw_0.gml) ---

// Define sprite frame width/height (assuming 24x24 base)
var frame_w = 24;
var frame_h = 24;
// Calculate centered draw coordinates
var draw_cx = floor(x - frame_w/2);
var draw_cy = floor(y - frame_h/2);

// --- 1. Tube Sprite ---
// Get the tube's sprite frame based on face direction
var tube_frame_x = tube_sprites[face][0];
var tube_frame_y = tube_sprites[face][1];
draw_sprite_part(spr_tube_sheet, 0, tube_frame_x, tube_frame_y, frame_w, frame_h, draw_cx, draw_cy);

// --- 2. Sitting Player Sprite (Using Coordinate Lookup) ---
// Explicitly define the coordinates for each sitting pose direction from spr_player_body sheet
var sitting_sprites = array_create(8);
sitting_sprites[DOWN]       = [0,   72];
sitting_sprites[DOWN_LEFT]  = [24,  72];
sitting_sprites[LEFT]       = [48,  72];
sitting_sprites[UP_LEFT]    = [72,  72];
sitting_sprites[UP]         = [96,  72];
sitting_sprites[UP_RIGHT]   = [120, 72];
sitting_sprites[RIGHT]      = [144, 72];
sitting_sprites[DOWN_RIGHT] = [168, 72];

// Get the specific X, Y from the player sprite sheet for the current face direction
var sit_frame_x = sitting_sprites[face][0];
var sit_frame_y = sitting_sprites[face][1];

// Draw player body & color overlay using the looked-up sitting frame
draw_sprite_part_ext(spr_player_body, 0, sit_frame_x, sit_frame_y, frame_w, frame_h, draw_cx, draw_cy, 1, 1, c_white, 1);
draw_sprite_part_ext(spr_player_colour, 0, sit_frame_x, sit_frame_y, frame_w, frame_h, draw_cx, draw_cy, 1, 1, global.player_color, 1);

// --- 3. Draw Equipped Items (using Player Sitting Frame) ---
// Check required global maps exist
if (ds_exists(global.equipped_items, ds_type_map) && ds_exists(global.item_sprite_map, ds_type_map)) {
    // Define which slots to draw & their draw order (body first, head last)
    var slots_to_draw = ["body", "neck", "face", "head"]; // Render order matters!
    for (var i = 0; i < array_length(slots_to_draw); i++) {
        var slot = slots_to_draw[i];
        var item_name = global.equipped_items[? slot]; // Get item name for the slot

        // Check if an item is actually equipped in this slot
        if (!is_undefined(item_name) && item_name != -1) {
            var item_sprite = ds_map_find_value(global.item_sprite_map, item_name); // Get the item's equipped sprite

            // Check if the sprite resource exists
            if (!is_undefined(item_sprite) && sprite_exists(item_sprite)) {
                // Draw the item sprite using the *looked-up player sitting frame* coordinates
                // This ensures the item aligns correctly with the sitting player pose
                draw_sprite_part_ext(item_sprite, 0, sit_frame_x, sit_frame_y, frame_w, frame_h, draw_cx, draw_cy, 1, 1, c_white, 1);
            }
        }
    }
} else {
    // Log error if critical maps are missing - this shouldn't happen if init is correct
    show_debug_message("Draw Tube ERROR: Missing global maps (equipped_items or item_sprite_map)");
}

// --- 4. Depth Sorting ---
set_depth(); // Apply depth sorting based on Y coordinate