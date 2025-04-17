// Check if player picks up the item
if (distance_to_object(global.player_instance) < 16 && keyboard_check_pressed(ord("E"))) {
    obj_inventory.add_to_inventory(item_type);
    instance_destroy();
}
