// Step Event for obj_npc
if (!sliding) {
    // Normal movement logic
    var move_x = lengthdir_x(move_spd, direction);
    var move_y = lengthdir_y(move_spd, direction);

    // Handle collisions with walls
    if (place_meeting(x + move_x, y, obj_wall)) {
        direction = 360 - direction; // Reverse direction on x-axis
    }
    if (place_meeting(x, y + move_y, obj_wall)) {
        direction = 180 - direction; // Reverse direction on y-axis
    }

    // Check for collision with obj_slippery to start sliding
    if (place_meeting(x + move_x, y, obj_slippery) || place_meeting(x, y + move_y, obj_slippery)) {
        sliding = true;
        slide_dir_x = sign(move_x);
        slide_dir_y = sign(move_y);
        slide_speed = move_spd * 1.5; // Initial slide speed, adjust as necessary
    } else {
        // Move the NPC normally
        x += move_x;
        y += move_y;
    }

    // Decrease the timer for changing direction
    change_direction_timer--;
    if (change_direction_timer <= 0) {
        direction = choose(0, 45, 90, 135, 180, 225, 270, 315);
        change_direction_timer = fps * 2; // Reset the timer
    }
} else {
    // Sliding logic
    var slide_move_x = slide_dir_x * slide_speed;
    var slide_move_y = slide_dir_y * slide_speed;

    // Decelerate slide over time
    slide_speed *= 0.98; // Adjust this value to control sliding deceleration

    // Stop sliding if speed is low enough
    if (abs(slide_speed) < 0.1) {
        sliding = false;
        slide_move_x = 0;
        slide_move_y = 0;
    }

    // Move the NPC while sliding
    x += slide_move_x;
    y += slide_move_y;
}

// Update the sprite based on direction
if (slide_speed > 0) {
    if (slide_dir_y < 0) {
        if (slide_dir_x < 0) { face = UP_LEFT; }
        if (slide_dir_x > 0) { face = UP_RIGHT; }
        if (slide_dir_x == 0) { face = UP; }
    }
    if (slide_dir_y > 0) {
        if (slide_dir_x < 0) { face = DOWN_LEFT; }
        if (slide_dir_x > 0) { face = DOWN_RIGHT; }
        if (slide_dir_x == 0) { face = DOWN; }
    }
    if (slide_dir_y == 0) {
        if (slide_dir_x > 0) { face = RIGHT; }
        if (slide_dir_x < 0) { face = LEFT; }
    }
} else {
    if (direction == 0) face = RIGHT;
    else if (direction == 45) face = UP_RIGHT;
    else if (direction == 90) face = UP;
    else if (direction == 135) face = UP_LEFT;
    else if (direction == 180) face = LEFT;
    else if (direction == 225) face = DOWN_LEFT;
    else if (direction == 270) face = DOWN;
    else if (direction == 315) face = DOWN_RIGHT;
}
sprite_index = sprite[face];

// Depth
depth = -bbox_bottom;

// Debugging logs

show_debug_message("NPC Direction: " + string(direction));
show_debug_message("NPC Face: " + string(face));
show_debug_message("NPC Position: " + string(x) + ", " + string(y));