// --- obj_puffle: User Event 0 (Interaction Attempt) ---

show_debug_message("Puffle User Event 0: Interaction triggered.");

// Check if player is nearby (redundant check, but safe)
if (distance_to_object(global.player_instance) >= 24) exit;

// Handle feeding/befriending ONLY if not already following
if (!following_player) {
    // Check inventory using the CORRECT method
    if (instance_exists(obj_inventory) && (obj_inventory.inventory_has("Puffle O") || obj_inventory.inventory_has("Box Puffle O"))) {
        state = PuffleState.EATING;
        // Turn to face player
        var dir_to_player = point_direction(x, y, global.player_instance.x, global.player_instance.y);
        var angle = round(dir_to_player / 45) % 8;
        var face_map = [RIGHT, UP_RIGHT, UP, UP_LEFT, LEFT, DOWN_LEFT, DOWN, DOWN_RIGHT];
        face = face_map[angle];
        // Stop animation during eating
        image_speed = 0;
        image_index = 0; // Or specific eating frame if you have one

        eating_timer = 120; // Eat for 2 seconds

        // Consume item using the CORRECT method
        if (obj_inventory.inventory_has("Puffle O")) {
            obj_inventory.inventory_remove("Puffle O");
        } else {
            obj_inventory.inventory_remove("Box Puffle O");
        }
        show_debug_message("Puffle is eating.");
    } else {
        show_debug_message("Player needs a Puffle O or Box Puffle O to befriend the puffle.");
        // Optional: Display a thought bubble above the puffle?
    }
} else {
    show_debug_message("Puffle is already following player.");
    // Optional: Add other interactions for already-following puffles (e.g., petting)
}