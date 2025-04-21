// --- obj_player: Step Event 0 ---

// --- Pause Checks ---
if (global.game_paused || global.is_pause_menu_active || global.chat_active) {
    exit;
}

// --- Inventory Check Example ---
//if (instance_exists(obj_inventory)) {
//    if (obj_inventory.inventory_has("Wrench")) {
//        // Do something if the player has a wrench
//    }
//}

// --- Action Handling ---
// Handle starting special actions (only when not driving and not already in an action)
if (!driving && action_state == "none") {
    if (keyboard_check_pressed(ord("H"))) {
        action_state = "dance";
        action_timer = 0;
        action_duration = 224;
        image_index = 0;
        show_debug_message("Player Action: Starting dance");
    } else if (keyboard_check_pressed(ord("J"))) {
        action_state = "wave";
        action_timer = 0;
        action_duration = 80;
        image_index = 0;
        show_debug_message("Player Action: Starting wave");
    } else if (keyboard_check_pressed(ord("K"))) {
         // Check if already sitting to toggle off
         if (action_state == "sit" && sit_delay <= 0) { // Allow toggle off only after short delay
            action_state = "none";
            image_speed = 0; // Resume normal animation handling potentially
            show_debug_message("Player Action: Stopped sitting");
         } else if (action_state == "none") { // Only start sitting if not already sitting
             action_state = "sit";
             action_timer = 0;
             action_duration = -1; // Infinite duration
             image_index = 0;
             image_speed = 0;      // Sit is static
             sit_delay = 5;        // Delay before toggle-off is allowed
             show_debug_message("Player Action: Starting sit");
         }
    } else if (keyboard_check_pressed(ord("B"))) {
        if (instance_exists(obj_inventory) && obj_inventory.inventory_has("Jackhammer")) { // Use corrected check
            action_state = "jackhammer";
            action_timer = 0;
            action_duration = 150;
            image_index = 0;
            show_debug_message("Player Action: Starting jackhammer");
        } else {
            show_debug_message("Player Action: Cannot start jackhammer: Item not in inventory.");
        }
    } else if (keyboard_check_pressed(ord("N"))) {
        if (instance_exists(obj_inventory) && obj_inventory.inventory_has("Snow Shovel")) { // Use corrected check
            action_state = "snowshovel";
            action_timer = 0;
            action_duration = 80;
            image_index = 0;
            show_debug_message("Player Action: Starting snow shovel");
        } else {
            show_debug_message("Player Action: Cannot start snow shovel: Item not in inventory.");
        }
    } else if (keyboard_check_pressed(ord("O"))) { // Throw Snowball
        action_state = "throw";
        action_timer = 0;
        action_duration = 24; // Adjust based on your throw animation frames
        image_index = 0;
        // image_speed = ds_map_find_value(action_anim_speed, "throw"); // Speed is handled in the block below
        show_debug_message("Player Action: Starting throw");

        // Create snowball projectile
        var snowball = instance_create_layer(x, y, "Instances", obj_snowball); // Ensure "Instances" layer exists
        switch (face) { // Set direction based on player facing
             case RIGHT: snowball.direction = 0; break;
             case LEFT: snowball.direction = 180; break;
             case UP: snowball.direction = 90; break;
             case DOWN: snowball.direction = 270; break;
             case UP_RIGHT: snowball.direction = 45; break;
             case UP_LEFT: snowball.direction = 135; break;
             case DOWN_RIGHT: snowball.direction = 315; break;
             case DOWN_LEFT: snowball.direction = 225; break;
             default: snowball.direction = 270; // Default down
        }
        snowball.speed = 5; // Example speed
    }
}

// Manage ongoing special actions
if (action_state != "none") {
    xspd = 0; // Prevent movement during actions
    yspd = 0;
    image_speed = ds_map_find_value(action_anim_speed, action_state); // Set animation speed for the current action

    action_timer++; // Increment timer for actions with duration

    // Handle sit toggle-off delay
    if (action_state == "sit") {
        image_speed = 0; // Sit is static
        if (sit_delay > 0) {
            sit_delay--;
        }
        // Allow toggling off sit with 'K'
        if (keyboard_check_pressed(ord("K")) && sit_delay <= 0) {
             action_state = "none";
             show_debug_message("Player Action: Stopped sitting");
        }
    } else {
         // For actions with a set duration
         if (action_duration > 0 && action_timer >= action_duration) {
            action_state = "none";
            show_debug_message("Player Action: Action '" + action_state + "' finished by duration.");
        }
    }

    // Animate
    image_index += image_speed;
    var frames = ds_map_find_value(action_frame_data, action_state);
    var frame_count = is_array(frames) ? array_length(frames) : 0;
    if (frame_count > 0 && image_index >= frame_count) {
         if (action_state == "throw" || action_state == "wave" || action_state == "jackhammer" || action_state == "snowshovel" ) { // End non-looping animations
             action_state = "none";
             image_index = 0;
             image_speed = 0; // Stop animation explicitly
             show_debug_message("Player Action: Action '" + action_state + "' finished by animation loop.");
         } else {
             image_index = 0; // Loop animation for actions like dance
         }
    }
} else {
    // --- Handle Movement (Simplified Collision - WHEN NOT IN ACTION) ---
    var right_key = keyboard_check(ord("D")) || keyboard_check(vk_right);
    var left_key = keyboard_check(ord("A")) || keyboard_check(vk_left);
    var up_key = keyboard_check(ord("W")) || keyboard_check(vk_up);
    var down_key = keyboard_check(ord("S")) || keyboard_check(vk_down);

    // Calculate intended movement based on input and speed
    var move_dx = (right_key - left_key) * move_spd;
    var move_dy = (down_key - up_key) * move_spd;

    // Sliding logic could modify move_dx/dy here if implemented

    // Determine facing direction based on intended movement
    var is_moving = (move_dx != 0 || move_dy != 0);
    if (is_moving) {
         if (move_dy < 0) {
             if (move_dx < 0) { face = UP_LEFT; } else if (move_dx > 0) { face = UP_RIGHT; } else { face = UP; }
         } else if (move_dy > 0) {
             if (move_dx < 0) { face = DOWN_LEFT; } else if (move_dx > 0) { face = DOWN_RIGHT; } else { face = DOWN; }
         } else {
             if (move_dx > 0) { face = RIGHT; } else if (move_dx < 0) { face = LEFT; }
         }
    }

    // --- Simple Collision Check ---
    // Check X-axis collision
    if (place_meeting(x + move_dx, y, obj_wall)) {
        // Move pixel by pixel until collision
        while (!place_meeting(x + sign(move_dx), y, obj_wall)) {
            x += sign(move_dx);
        }
        move_dx = 0; // Stop horizontal movement
    }
    // Apply horizontal movement if no collision
    x += move_dx;

    // Check Y-axis collision
    if (place_meeting(x, y + move_dy, obj_wall)) {
         // Move pixel by pixel until collision
        while (!place_meeting(x, y + sign(move_dy), obj_wall)) {
            y += sign(move_dy);
        }
        move_dy = 0; // Stop vertical movement
    }
    // Apply vertical movement if no collision
    y += move_dy;
    // --- End Simple Collision Check ---


    // --- Animate Walking ---
    if (is_moving) { // Animate only if there was input intention
        image_speed = 0.15; // << START ADJUSTING THIS VALUE (e.g., 0.1, 0.12, 0.18, 0.2)
        image_index += image_speed;
        if (image_index >= 3) {
             image_index -= 3; // Loop smoothly
        }
    } else {
        image_speed = 0;
        image_index = 0; // Idle frame
    }
} // End else (action_state == "none")

// --- Other Interactions (Only when not in an action) ---
// These should ideally check if action_state == "none" too
if (action_state == "none") {
     // Repair Ice Truck (Now requires check on obj_icetruck_broken) - This logic might be better ON the truck object
     if (keyboard_check_pressed(ord("R"))) {
        var broken_truck = instance_place(x, y, obj_icetruck_broken);
        if (broken_truck != noone) {
             // Trigger repair on the truck object itself if requirements met
             // The truck object will handle consuming items via obj_inventory.inventory_remove()
             with(broken_truck) {
                event_perform(ev_other, ev_user0); // Example: Trigger a user event for repair attempt
             }
        }
     }

     // Enter/Exit Tube/Toboggan/Truck - Keep this logic here or move to obj_controller
     if (keyboard_check_pressed(ord("T"))) {
         if (instance_exists(obj_controller)) {
             if (global.current_skin == "player" && instance_exists(obj_inventory) && obj_inventory.inventory_has("Tube")) {
                 if(obj_controller.switch_skin("tube")) {
                     // Remove tube from inventory AFTER successful switch
                     obj_inventory.inventory_remove("Tube");
                 }
             } else if (global.current_skin == "tube") {
                  if(obj_controller.switch_skin("player")) {
                      // Add tube back AFTER successful switch
                      obj_inventory.inventory_add("Tube");
                  }
             } else if (global.current_skin == "player" && instance_exists(obj_inventory) && obj_inventory.inventory_has("Toboggan")) {
                 if(obj_controller.switch_skin("toboggan")) {
                     obj_inventory.inventory_remove("Toboggan");
                 }
             } else if (global.current_skin == "toboggan") {
                  if(obj_controller.switch_skin("player")) {
                      obj_inventory.inventory_add("Toboggan");
                  }
             }
         }
     }

     if (keyboard_check_pressed(ord("E"))) {
         var truck_nearby = instance_place(x, y, obj_icetruck); // Use instance_place for better check
         if (instance_exists(obj_controller)) {
             if (truck_nearby != noone && global.current_skin == "player") {
                 obj_controller.switch_skin("icetruck");
             }
             // Exit truck logic should be in obj_player_icetruck's step event
         }
     }
      // Interact with Puffle
     if (keyboard_check_pressed(ord("E"))) {
         var puffle_nearby = instance_place(x,y, obj_puffle);
         if (puffle_nearby != noone) {
             // Let the puffle handle the interaction logic
              with(puffle_nearby){
                  event_perform(ev_other, ev_user0); // Example: Trigger a user event for interaction
              }
         }
     }
}


// --- Sled Racing Room Visibility Check ---
var is_sled_room = (room == rm_sled_racing);
// This check seems misplaced, player visibility is usually handled by obj_controller or room start events
// if (is_sled_room) {
//     visible = false;
// } else {
//     visible = true;
// }


// --- Depth Sorting ---
set_depth();