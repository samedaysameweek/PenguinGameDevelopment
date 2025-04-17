// obj_penguinstylestore: Mouse Left Pressed Event
var camera_x = camera_get_view_x(view_camera[0]);
var camera_y = camera_get_view_y(view_camera[0]);
var viewport_width = camera_get_view_width(view_camera[0]);
var viewport_height = camera_get_view_height(view_camera[0]);

var center_x = camera_x + (viewport_width / 2);
var center_y = camera_y + (viewport_height / 2);

var clicked_inside = false;

switch (current_page) {
    case 0:
        if (mouse_x >= center_x + turn_right_area[0] && mouse_x <= center_x + turn_right_area[2] &&
            mouse_y >= center_y + turn_right_area[1] && mouse_y <= center_y + turn_right_area[3]) {
            current_page = 1;
            clicked_inside = true;
        }
        break;
    case 1:
        if (mouse_x >= center_x + turn_left_area[0] && mouse_x <= center_x + turn_left_area[2] &&
            mouse_y >= center_y + turn_left_area[1] && mouse_y <= center_y + turn_left_area[3]) {
            current_page = 0;
            clicked_inside = true;
        }
        if (mouse_x >= center_x + turn_right_area[0] && mouse_x <= center_x + turn_right_area[2] &&
            mouse_y >= center_y + turn_right_area[1] && mouse_y <= center_y + turn_right_area[3]) {
            current_page = 2;
            clicked_inside = true;
        }
        // Handle color picker interaction
        if (mouse_x >= center_x + color_picker_area[0] && mouse_x <= center_x + color_picker_area[2] &&
            mouse_y >= center_y + color_picker_area[1] && mouse_y <= center_y + color_picker_area[3]) {
            instance_create_layer(mouse_x, mouse_y, "Instances", obj_color_picker_controller);
            clicked_inside = true;
        }
        break;
    case 2:
        if (mouse_x >= center_x + turn_left_area[0] && mouse_x <= center_x + turn_left_area[2] &&
            mouse_y >= center_y + turn_left_area[1] && mouse_y <= center_y + turn_left_area[3]) {
            current_page = 1;
            clicked_inside = true;
        }
        break;
}

// Close the store if clicked outside of the interactable areas
if (!clicked_inside) {
    instance_destroy();
}