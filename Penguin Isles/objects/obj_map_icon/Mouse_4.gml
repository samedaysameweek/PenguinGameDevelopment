if (room != rm_map) {
    if (instance_exists(global.player_instance)) {
        global.player_x = global.player_instance.x;
        global.player_y = global.player_instance.y;

        show_debug_message("DEBUG: Stored player position: (" + string(global.player_x) + ", " + string(global.player_y) + ")");
        
        // Hide the player instead of destroying
        global.player_instance.visible = false;
    } else {
        show_debug_message("WARNING: No player instance found before switching rooms! Using default coordinates.");
        
        // Set default safe position
        global.player_x = 170;
        global.player_y = 154;
    }

    show_debug_message("Switching to map room...");
    global.last_room = room;
    room_goto(rm_map);
}
else if (variable_global_exists("last_room") && global.last_room != noone) {
    show_debug_message("Returning to previous room: " + string(global.last_room));
    room_goto(global.last_room);

}
