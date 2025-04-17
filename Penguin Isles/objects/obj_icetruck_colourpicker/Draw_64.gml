// Draw GUI Event
draw_sprite_ext(spr_colourpicker_panel, 0, x, y, scale, scale, 0, c_white, 1);

// Viewer
var viewer_x = x + 9 * scale;
var viewer_y = y + 35 * scale;
var viewer_width = (83 - 9) * scale;
var viewer_height = (150 - 35) * scale;
var scale_preview = min(viewer_width / 48, viewer_height / 48) * scale;
var tint = instance_exists(obj_player_icetruck) ? obj_player_icetruck.icetruck_tint : c_white;
draw_sprite_part_ext(spr_icetruck_base, 0, 48, 48, 48, 48, viewer_x + viewer_width / 2 - 24 * scale_preview, viewer_y + viewer_height / 2 - 24 * scale_preview, scale_preview, scale_preview, c_white, 1);
draw_sprite_part_ext(spr_icetruck_colour, 0, 48, 48, 48, 48, viewer_x + viewer_width / 2 - 24 * scale_preview, viewer_y + viewer_height / 2 - 24 * scale_preview, scale_preview, scale_preview, tint, 1);

// Color previews
var scale_icon = (20 * scale) / 48;
for (var i = 0; i < 15; i++) {
    var col = i mod 5;
    var row = i div 5;
    var icon_x = start_x + col * 25 * scale;
    var icon_y = start_y + row * 25 * scale;
    draw_sprite_part_ext(spr_icetruck_base, 0, 48, 48, 48, 48, icon_x, icon_y, scale_icon, scale_icon, c_white, 1);
    draw_sprite_part_ext(spr_icetruck_colour, 0, 48, 48, 48, 48, icon_x, icon_y, scale_icon, scale_icon, colors[i], 1);
}