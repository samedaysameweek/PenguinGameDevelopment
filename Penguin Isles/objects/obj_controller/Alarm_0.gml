// Ensure the new player instance is created after the previous one is destroyed
if (global.skin_to_spawn != noone) {
    var player_x = global.last_player_x;
    var player_y = global.last_player_y;

    // Create the new player instance
    global.player_instance = instance_create_layer(player_x, player_y, "Instances", global.skin_to_spawn);
    global.current_skin = global.skin_name_to_spawn;

    // Reset the temporary skin variables
    global.skin_to_spawn = noone;
    global.skin_name_to_spawn = "";

    // Ensure camera follows the new player
    if (instance_exists(global.player_instance)) {
        camera_set_view_target(global.camera, global.player_instance);
        show_debug_message("Skin switched to: " + global.current_skin + ". New instance ID: " + string(global.player_instance));
    } else {
        show_debug_message("ERROR: Failed to create player instance.");
    }
}