var _camx = camera_get_view_x(global.camera);  // Use global.camera explicitly
var _camy = camera_get_view_y(global.camera);

var _p = 0.5;  // Parallax factor (adjust as needed)

if (sprite_exists(bg_sky)) {
    draw_sprite(bg_sky, 0, _camx * _p, _camy * _p);
} else {
    show_debug_message("ERROR: bg_sky sprite does not exist!");
}
