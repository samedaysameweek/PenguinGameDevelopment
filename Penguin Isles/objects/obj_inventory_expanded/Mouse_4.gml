/// Mouse Left Pressed Event for obj_inventory_expanded
/// @function Mouse Left Pressed Event for obj_inventory
var item_index = get_item_index_from_mouse_position(mouse_x, mouse_y);
if (item_index != -1) {
    inventory_click_handler(item_index);
}