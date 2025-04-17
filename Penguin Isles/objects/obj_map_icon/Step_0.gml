//Step event
if (global.chat_active) exit;
depth = -1000;

// Position map icon in the corner of the screen
x = camera_get_view_x(global.camera);
y = camera_get_view_y(global.camera) + camera_get_view_height(global.camera) - sprite_height;

// Check if the mouse is hovering over the icon
if (position_meeting(mouse_x, mouse_y, id)) {
    image_index = 1; // Change to highlighted sprite
} else {
    image_index = 0; // Revert to normal sprite
}

// Hide player instead of destroying in UI rooms
var is_ui_room = (room == rm_init || room == rm_main_menu || room == rm_map || room == rm_sled_racing || room == rm_pause_menu || room == rm_settings_menu);

if (is_ui_room) {
    if (instance_exists(obj_map_icon)) {
        obj_map_icon.visible = false;
        show_debug_message("DEBUG: UI Room detected. Player instance hidden.");
    }
} else {
    if (instance_exists(obj_map_icon)) {
       obj_map_icon.visible = true;
    }
}
