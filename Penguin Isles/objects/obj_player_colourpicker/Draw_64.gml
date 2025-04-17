// Draw GUI Event
if (is_destroying) return;

draw_sprite_ext(spr_colourpicker_panel, 0, x, y, scale, scale, 0, c_white, 1);

// Define and visualize the viewer area
var viewer_x = x + 9 * scale;
var viewer_y = y + 35 * scale;
var viewer_width = (83 - 9) * scale;
var viewer_height = (150 - 35) * scale;
draw_rectangle(viewer_x, viewer_y, viewer_x + viewer_width, viewer_y + viewer_height, true); // Outline the viewer area

// Draw player sprite with debugging
if (instance_exists(global.player_instance)) {
    var player_sprite = global.player_instance.sprite_index;
    show_debug_message("Player instance exists, sprite_index: " + string(player_sprite));
    if (player_sprite != -1) {
        var sprite_scale = min(viewer_width / sprite_get_width(player_sprite), viewer_height / sprite_get_height(player_sprite));
        var x_pos = viewer_x + viewer_width / 2 - sprite_get_xoffset(player_sprite) * sprite_scale;
        var y_pos = viewer_y + viewer_height / 2 - sprite_get_yoffset(player_sprite) * sprite_scale;
        
        // Debug output
        show_debug_message("viewer_x: " + string(viewer_x) + ", viewer_y: " + string(viewer_y));
        show_debug_message("viewer_width: " + string(viewer_width) + ", viewer_height: " + string(viewer_height));
        show_debug_message("sprite_scale: " + string(sprite_scale));
        show_debug_message("x_pos: " + string(x_pos) + ", y_pos: " + string(y_pos));
        show_debug_message("sprite origin: (" + string(sprite_get_xoffset(player_sprite)) + ", " + string(sprite_get_yoffset(player_sprite)) + ")");
        
        // Draw with test parameters
        draw_sprite_ext(player_sprite, 0, x_pos, y_pos, sprite_scale, sprite_scale, 0, c_white, 1);
    } else {
        show_debug_message("Player has no sprite assigned.");
    }
} else {
    show_debug_message("Player instance does not exist.");
}

// Draw color icons with adjusted scale
for (var i = 0; i < 15; i++) {
    var col = i mod 5;
    var row = i div 5;
    var icon_x = start_x + col * (icon_size + spacing);
    var icon_y = start_y + row * (icon_size + spacing);
    draw_sprite_ext(sprites[i], 0, icon_x, icon_y, icon_scale, icon_scale, 0, c_white, 1);
}