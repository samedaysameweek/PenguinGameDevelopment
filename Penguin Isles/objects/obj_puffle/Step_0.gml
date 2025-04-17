// --- obj_puffle: Step Event ---

// Exit if paused
if (global.is_pause_menu_active) exit;

// Ensure player_instance is valid
if (!instance_exists(global.player_instance)) {
    // Try finding any player object if global ref is lost
    global.player_instance = instance_find(obj_player_base, 0); // Find any parent player object
    if (!instance_exists(global.player_instance)) {
        show_debug_message("Puffle Warning: No player instance found!");
        exit;
    }
}

// --- Player Interaction (Check for 'E' press) ---
// This section now *only* handles the 'E' key press detection.
// The actual feeding logic is moved to User Event 0 triggered below.
if (distance_to_object(global.player_instance) < 24 && keyboard_check_pressed(ord("E"))) {
     // Trigger User Event 0 on the puffle itself to handle the interaction attempt
     event_perform(ev_other, ev_user0);
}

// Debugging state
//show_debug_message("Puffle state: " + string(state) + ", Position: (" + string(x) + ", " + string(y) + ")");

// New variable for player inactivity timer (initialized in Create event if not present)
if (!variable_instance_exists(id, "player_idle_timer")) player_idle_timer = 0;

// State-specific logic
switch (state) {
    case PuffleState.IDLE:
        xspd = 0;
        yspd = 0;
        idle_timer += 1;
        if (idle_timer >= 120) {
            var idle_behavior = choose("bounce", "roll", "look_around");
            if (idle_behavior == "bounce") {
                y -= 2;
                alarm[0] = 5;
            }
            if (idle_behavior == "roll") {
                image_angle += choose(-5, 5);
            }
            if (idle_behavior == "look_around") {
                face = choose(RIGHT, LEFT, UP, DOWN);
            }
            idle_timer = 0;
        }
        // Check if player starts moving again
        if (following_player && point_distance(0, 0, global.player_instance.xspd, global.player_instance.yspd) > 0.5) {
            state = PuffleState.FOLLOWING;
            player_idle_timer = 0;
            show_debug_message("Puffle resumes following player.");
        }
        break;

    case PuffleState.PLAYING:
        if (direction_timer <= 0 || place_meeting(x + xspd, y, obj_wall) || place_meeting(x, y + yspd, obj_wall)) {
            direction = choose(0, 45, 90, 135, 180, 225, 270, 315);
            direction_timer = 120;
        }
        xspd = lengthdir_x(move_spd, direction);
        yspd = lengthdir_y(move_spd, direction);
        direction_timer -= 1;
        break;

    case PuffleState.FOLLOWING:
        if (instance_exists(global.player_instance)) {
            // Target a position behind the player with some randomness
            var base_dist = 24; // Increased distance for looser following
            var offset_dir = (global.player_instance.face + 180) % 360; // Opposite of player's facing
            var random_offset = irandom_range(-8, 8); // Add natural variation
            var target_x = global.player_instance.x + lengthdir_x(base_dist, offset_dir) + random_offset;
            var target_y = global.player_instance.y + lengthdir_y(base_dist, offset_dir) + random_offset;
            var dist = point_distance(x, y, target_x, target_y);

            if (dist > 12) { // Minimum distance to start moving
                var dir = point_direction(x, y, target_x, target_y);
                var move_x = lengthdir_x(move_spd, dir);
                var move_y = lengthdir_y(move_spd, dir);
                xspd = lerp(xspd, move_x, 0.15); // Slightly higher acceleration for responsiveness
                yspd = lerp(yspd, move_y, 0.15);
            } else {
                xspd = lerp(xspd, 0, 0.3); // Faster deceleration when close
                yspd = lerp(yspd, 0, 0.3);
            }

            // Check if player is stationary
            if (point_distance(0, 0, global.player_instance.xspd, global.player_instance.yspd) < 0.1) {
                player_idle_timer += 1;
                if (player_idle_timer >= 180) { // 3 seconds at 60 FPS
                    state = PuffleState.IDLE;
                    player_idle_timer = 0;
                    show_debug_message("Puffle switched to idle state.");
                }
            } else {
                player_idle_timer = 0; // Reset timer if player moves
            }
        } else {
            xspd = 0;
            yspd = 0;
        }
        break;

    case PuffleState.EATING:
        xspd = 0;
        yspd = 0;
        if (eating_timer > 0) {
            eating_timer -= 1;
        } else {
            state = PuffleState.FOLLOWING;
            following_player = true;
            persistent = true;
            ds_list_add(global.following_puffles, id);
            show_debug_message("Puffle finished eating and is now following player.");
        }
        break;
}

// Collision Handling with Obstacle Avoidance
var old_x = x;
var old_y = y;
x += xspd;
if (place_meeting(x, y, obj_wall)) {
    x = old_x; // Revert x movement
    y += yspd;
    if (place_meeting(x, y, obj_wall)) {
        y = old_y; // Revert y movement
        // Try sliding around obstacle
        var slide_dir = point_direction(x, y, global.player_instance.x, global.player_instance.y) + choose(-90, 90);
        xspd = lengthdir_x(move_spd * 0.5, slide_dir);
        yspd = lengthdir_y(move_spd * 0.5, slide_dir);
    } else {
        // y movement succeeded, adjust xspd to avoid sticking
        xspd = lerp(xspd, 0, 0.2);
    }
} else {
    y += yspd;
    if (place_meeting(x, y, obj_wall)) {
        y = old_y; // Revert y if stuck
        xspd = lerp(xspd, 0, 0.2); // Slow down to prevent sticking
    }
}

// Animation Handling
if (xspd != 0 || yspd != 0) {
    var angle = point_direction(0, 0, xspd, yspd);
    var dir_index = round(angle / 45) % 8;
    var face_map = [RIGHT, UP_RIGHT, UP, UP_LEFT, LEFT, DOWN_LEFT, DOWN, DOWN_RIGHT];
    var new_face = face_map[dir_index];
    if (new_face != prev_face) {
        image_index = 0;  // Reset animation when direction changes
        prev_face = new_face;
    }
    face = new_face;
    image_speed = 0.15;
} else {
    image_speed = 0;
}
image_index += image_speed;