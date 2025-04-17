// Step Event for obj_sled_player

if (global.game_started) {
    game_timer -= 1; // Decrement timer each frame

    // Horizontal movement
    if (keyboard_check(vk_left) || keyboard_check(ord("A"))) {
        x -= move_spd; // Move left
    } 
    if (keyboard_check(vk_right) || keyboard_check(ord("D"))) {
        x += move_spd; // Move right
    }

    // Prevent movement outside room boundaries
    x = clamp(x, 0, room_width - sprite_width);
}
    // Check for collision with obstacles
if (global.game_started) {
    // Collision detection with cooldown
    if (collision_cooldown <= 0 && place_meeting(x, y, obj_obstacle)) {
        show_debug_message("Collision with obstacle!");
        lives -= 1; // Deduct one life
        collision_cooldown = 30; // Set cooldown (0.5 seconds at 60 FPS)
        // Optional: Add sound effect or visual feedback here
    } else {
        collision_cooldown -= 1; // Decrement cooldown
    }

    // Win condition: Survive 10 seconds with lives remaining
    if (game_timer <= 0 && lives > 0) {
        global.last_player_x = 55; // Set position for rm_ski_village
        global.last_player_y = 235;
        switch_skin("player"); // Switch back to obj_player
        room_goto(rm_ski_village); // Transition to rm_ski_village
    }

    // Lose condition: No lives remaining
    if (lives <= 0) {
        global.last_player_x = 245; // Set position for rm_ski_mountaintop
        global.last_player_y = 120;
        switch_skin("player"); // Switch back to obj_player
        room_goto(rm_ski_mountaintop); // Transition to rm_ski_mountaintop
    }
}

