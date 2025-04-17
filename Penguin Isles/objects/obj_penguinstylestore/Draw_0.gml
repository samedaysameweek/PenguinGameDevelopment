// obj_penguinstylestore: Draw Event
var camera_x = camera_get_view_x(view_camera[0]);
var camera_y = camera_get_view_y(view_camera[0]);
var viewport_width = camera_get_view_width(view_camera[0]);
var viewport_height = camera_get_view_height(view_camera[0]);

var center_x = camera_x + (viewport_width / 2);
var center_y = camera_y + (viewport_height / 2);

switch (current_page) {
    case 0:
        draw_sprite(spr_penguinstyle_cover, 0, center_x - sprite_get_width(spr_penguinstyle_cover) / 2, center_y - sprite_get_height(spr_penguinstyle_cover) / 2);
        break;
    case 1:
        draw_sprite(spr_penguinstyle_page1, 0, center_x - sprite_get_width(spr_penguinstyle_page1) / 2, center_y - sprite_get_height(spr_penguinstyle_page1) / 2);
        draw_sprite(spr_penguinstyle_page1_colour, 0, center_x + color_picker_area[0], center_y + color_picker_area[1]);
        break;
    case 2:
        draw_sprite(spr_penguinstyle_page2, 0, center_x - sprite_get_width(spr_penguinstyle_page2) / 2, center_y - sprite_get_height(spr_penguinstyle_page2) / 2);
        break;
}