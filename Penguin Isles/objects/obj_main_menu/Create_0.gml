if (!instance_exists(obj_new_game_button)) {
    instance_create_layer(room_width / 2, room_height / 2, "Instances", obj_new_game_button);
}
if (!instance_exists(obj_continue_button) && file_exists("savegame.sav")) {
    instance_create_layer(room_width / 2, room_height / 2 + 40, "Instances", obj_continue_button);
}