// obj_penguinstyle_icon: Draw Event

    var camera_x = camera_get_view_x(view_camera[0]);
    var camera_y = camera_get_view_y(view_camera[0]);
    var viewport_width = camera_get_view_width(view_camera[0]);
    var viewport_height = camera_get_view_height(view_camera[0]);

    var icon_x = camera_x + viewport_width - 60; // Adjust position
    var icon_y = camera_y + viewport_height - 60;

    draw_sprite(spr_penguinstyle_icon, 0, icon_x, icon_y);
    show_debug_message("Drawing obj_penguinstyle_icon at (" + string(icon_x) + ", " + string(icon_y) + ")");
