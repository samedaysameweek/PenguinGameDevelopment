/// scr_convert_gui_to_world()
/// Converts GUI mouse coordinates to world coordinates
var world_x = camera_get_view_x(view_camera[0]) + (mouse_x / display_get_gui_width()) * camera_get_view_width(view_camera[0]);
var world_y = camera_get_view_y(view_camera[0]) + (mouse_y / display_get_gui_height()) * camera_get_view_height(view_camera[0]);

return [world_x, world_y];
