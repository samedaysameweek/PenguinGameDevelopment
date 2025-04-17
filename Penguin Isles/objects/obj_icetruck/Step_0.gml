// Ensure the truck is repaired before allowing entry
if (!repair_required) { 
    if (keyboard_check_pressed(ord("E")) && distance_to_object(global.player_instance) < 32) {
        if (global.current_skin == "player") {
            // Enter the ice truck
            var player_x = global.player_instance.x;
            var player_y = global.player_instance.y;

            instance_destroy(global.player_instance); // Remove player
            instance_destroy(id); // Remove icetruck

            global.player_instance = instance_create_layer(player_x, player_y, "Instances", obj_player_icetruck);
            global.current_skin = "icetruck";

            show_debug_message("Entered ice truck. Current skin: " + global.current_skin);
        }
    }
} else {
    show_debug_message("The truck is still broken! Repair it first.");
}

// Ensure correct depth
set_depth();