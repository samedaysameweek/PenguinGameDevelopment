// obj_penguinstyle_icon: Mouse Left Pressed Event
if (room == rm_giftshop) {
    var camera_x = camera_get_view_x(view_camera[0]);
    var camera_y = camera_get_view_y(view_camera[0]);
    var viewport_width = camera_get_view_width(view_camera[0]);
    var viewport_height = camera_get_view_height(view_camera[0]);
    
    var icon_x = camera_x + viewport_width - 60;
    var icon_y = camera_y + viewport_height - 60;

    if (mouse_x >= icon_x && mouse_x <= icon_x + sprite_get_width(spr_penguinstyle_icon) &&
        mouse_y >= icon_y && mouse_y <= icon_y + sprite_get_height(spr_penguinstyle_icon)) {
        instance_create_layer(0, 0, "Instances", obj_penguinstylestore);
    }
}