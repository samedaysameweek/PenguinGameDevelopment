// obj_ui_leftpressed.txt
// Get mouse position
var mouse_x_pos = device_mouse_x_to_gui(0);
var mouse_y_pos = device_mouse_y_to_gui(0);

// Check if any UI element is clicked
for (var i = 0; i < array_length(ui_elements); i++) {
    var elem = ui_elements[i];
    if (mouse_x_pos > elem.x && mouse_x_pos < elem.x + elem.width && mouse_y_pos > elem.y && mouse_y_pos < elem.y + elem.height) {
        // Execute the action associated with the UI element
        elem.action();
    }
}