// Step Event for obj_player
// Prevent player movement and interactions when paused
if (global.is_pause_menu_active) {
    exit; // This prevents the player from updating while paused
}

// Handle interaction with NPC
if (keyboard_check_pressed(ord("E"))) {
    var target_npc = instance_nearest(x, y, obj_npc_old); // Find the nearest NPC
    if (target_npc != noone && distance_to_object(target_npc) < 48) { // Check proximity
        target_npc.current_phrase = target_npc.phrases[irandom_range(0, array_length(target_npc.phrases) - 1)]; // Pick a random phrase
        target_npc.talk_timer = fps * 3; // Show the phrase for 3 seconds
        target_npc.interact_pause = fps * 3; // Pause NPC movement for 3 seconds
        show_debug_message("Player interacted with NPC. NPC says: " + target_npc.current_phrase);
    }
}

// Handle skin switching
if (keyboard_check_pressed(ord("E"))) {
    if (distance_to_object(obj_icetruck) < 32) {
        show_debug_message("E key pressed");
        obj_controller.switch_skin(global.current_skin == "player" ? "icetruck" : "player");
    } else if (distance_to_object(obj_tube) < 32) {
        show_debug_message("E key pressed");
        obj_controller.switch_skin(global.current_skin == "player" ? "tube" : "player");
    }
}

// Handle movement input
var right_key = keyboard_check(ord("D")) || keyboard_check(vk_right);
var left_key = keyboard_check(ord("A")) || keyboard_check(vk_left);
var up_key = keyboard_check(ord("W")) || keyboard_check(vk_up);
var down_key = keyboard_check(ord("S")) || keyboard_check(vk_down);

// Get xspd & yspd
if (!sliding) {
    xspd = (right_key - left_key) * move_spd;
    yspd = (down_key - up_key) * move_spd;
} else {
    // Continue sliding
    xspd = slide_dir_x * slide_speed;
    yspd = slide_dir_y * slide_speed;

    // Decelerate slide over time
    slide_speed *= 0.98; // Adjust this value to control sliding deceleration

    // Stop sliding if speed is low enough
    if (abs(slide_speed) < 0.1) {
        sliding = false;
        xspd = 0;
        yspd = 0;
    }
}

// Pause
if (instance_exists(obj_pauser)) {
    xspd = 0;
    yspd = 0;
}

// Set sprite
mask_index = sprite[DOWN];
if (yspd < 0) {
    if (xspd < 0) { face = UP_LEFT; }
    else if (xspd > 0) { face = UP_RIGHT; }
    else { face = UP; }
} else if (yspd > 0) {
    if (xspd < 0) { face = DOWN_LEFT; }
    else if (xspd > 0) { face = DOWN_RIGHT; }
    else { face = DOWN; }
} else {
    if (xspd > 0) { face = RIGHT; }
    else if (xspd < 0) { face = LEFT; }
}

sprite_index = sprite[face];

// Collisions
xspd = handle_collision("x", xspd);
yspd = handle_collision("y", yspd);

// Move the player
x += xspd;
y += yspd;

// Animate
if (xspd == 0 && yspd == 0) {
    image_index = 0;
}

// Depth
set_depth();