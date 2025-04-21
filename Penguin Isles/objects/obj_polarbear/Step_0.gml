// obj_polarbear Step Event - COMPLETE
if (global.is_pause_menu_active) exit;

// Handle warp block interaction
if (place_meeting(x, y, obj_warp_block) && !instance_exists(obj_warp)) {
     var warp = instance_nearest(x, y, obj_warp_block);
     var inst = instance_create_depth(0, 0, -9999, obj_warp);
     inst.target_x = warp.target_x;
     inst.target_y = warp.target_y;
     inst.target_rm = warp.target_rm;
     inst.target_face = current_direction; // Keep current direction
     inst.target_instance = id;
     // Note: Cooldown is handled by obj_warp_block now
}

// Get player instance safely
var _player_inst = noone;
if (instance_exists(global.player_instance)) {
    _player_inst = global.player_instance;
}

// Determine player distance ONLY if player exists
if (_player_inst != noone) {
     dist_to_player = distance_to_object(_player_inst);
     // Check if player is close enough to potentially anger the bear
     if (dist_to_player <= view_range && mood == "passive") {
         // Optional: Add a chance to become angry just by player being near?
         // if (random(100) < 1) { mood = "angry"; }
     }
} else {
     dist_to_player = 10000; // Effectively infinite distance if player doesn't exist
     if (mood == "angry") { mood = "passive"; } // Calm down if player disappears
}


// --- State Machine ---
switch (mood) {
    case "passive":
        image_speed = 0; // Default for passive, overridden below
        xspd = 0;        // Reset speed at start of passive logic
        yspd = 0;

        if (is_stopped) {
            image_speed = idle_anim_speed; // Use idle animation speed (currently 0)
            if (stop_timer > 0) {
                stop_timer--;
                // Optionally face player if nearby and stopped
                if (_player_inst != noone && dist_to_player < view_range / 2) {
                     var dir_to_player = point_direction(x, y, _player_inst.x, _player_inst.y);
                     var angle = round(dir_to_player / 45) % 8;
                     // Map angle to PB_XXX macros (0=Right, 1=UR, 2=Up, ..., 7=DR)
                     var face_map = [PB_RIGHT, PB_UP_RIGHT, PB_UP, PB_UP_LEFT, PB_LEFT, PB_DOWN_LEFT, PB_DOWN, PB_DOWN_RIGHT];
                     current_direction = face_map[angle];
                }
            } else {
                is_stopped = false;
                wander_timer = irandom_range(60, 180); // Wander for 1-3 seconds
                current_direction = irandom(7); // Pick new random direction using 0-7 range matching macros
            }
        } else { // Wandering
            image_speed = walk_anim_speed; // Use walk animation speed
            if (wander_timer > 0) {
                wander_timer--;
                // Calculate speed based on current_direction macro
                switch (current_direction) {
                    case PB_DOWN:      yspd = move_spd; break;
                    case PB_DOWN_LEFT: xspd = -move_spd; yspd = move_spd; break;
                    case PB_LEFT:      xspd = -move_spd; break;
                    case PB_UP_LEFT:   xspd = -move_spd; yspd = -move_spd; break;
                    case PB_UP:        yspd = -move_spd; break;
                    case PB_UP_RIGHT:  xspd = move_spd; yspd = -move_spd; break;
                    case PB_RIGHT:     xspd = move_spd; break;
                    case PB_DOWN_RIGHT:xspd = move_spd; yspd = move_spd; break;
                }
            } else {
                // Decide to stop or change direction
                if (random(1) < 0.3) { // 30% chance to stop
                    is_stopped = true;
                    stop_timer = irandom_range(60, 180); // Stop for 1-3 seconds
                } else { // 70% chance to change direction
                    current_direction = irandom(7); // Pick random 0-7
                    wander_timer = irandom_range(60, 180); // Wander for 1-3 seconds
                }
            }
        }
        // Animate walking/idle - GMS handles index increment based on image_speed
        break; // End passive state

    case "angry":
        image_speed = 0; // Default for angry, overridden below
        xspd = 0;        // Reset speed at start of angry logic
        yspd = 0;

        if (_player_inst == noone) { // If player doesn't exist, calm down
            mood = "passive";
            break;
        }

        // Face the player
        var dir_to_player = point_direction(x, y, _player_inst.x, _player_inst.y);
        var angle = round(dir_to_player / 45) % 8;
        var face_map = [PB_RIGHT, PB_UP_RIGHT, PB_UP, PB_UP_LEFT, PB_LEFT, PB_DOWN_LEFT, PB_DOWN, PB_DOWN_RIGHT];
        current_direction = face_map[angle];

        if (throw_timer > 0) {
            // --- Currently Throwing ---
            throw_timer--;

            // Animate throw based on duration (Ensuring throw_sprite is valid)
            if (throw_sprite != noone && sprite_exists(throw_sprite)) {
                 var _num_frames = sprite_get_number(throw_sprite);
                 image_speed = (_num_frames > 0 && throw_duration > 0) ? (_num_frames / throw_duration) : 0;
            } else {
                 image_speed = 0; // Don't animate if sprite is invalid
            }

            // Check if throw animation finished
            if (throw_timer <= 0) {
                 // Throw finished - Start cooldown AND CREATE SNOWBALL NOW
                 if (_player_inst != noone) { // Check if player still exists
                     var snowball = instance_create_layer(x, y, "Instances", obj_snowball);
                     snowball.direction = dir_to_player; // Use direction calculated at start of state
                     snowball.speed = 5;
                     show_debug_message("Polar Bear threw snowball!");
                 }
                 image_speed = idle_anim_speed; // Transition to idle speed after throw
                 image_index = 0; // Reset frame index
                 throw_interval_timer = throw_interval;
                 throw_sprite = noone; // Clear the selected throw sprite
            }
        } else {
            // --- Not Throwing - Decide Action ---
            if (throw_interval_timer > 0) {
                // --- Cooldown Active ---
                throw_interval_timer--;
                xspd = 0; // Stay still during cooldown
                yspd = 0;
                image_speed = idle_anim_speed; // Idle animation during cooldown

            } else {
                // --- Cooldown Finished - Check Range & Act ---
                if (dist_to_player <= attack_distance) {
                    // --- In Attack Range: Start Throw ---
                    throw_timer = throw_duration; // Start animation timer
                    image_index = 0; // Reset animation index

                    // Determine which throw sprite to use based on player Y relative position
                    if (_player_inst.y > y) { // Player is lower or level
                        throw_sprite = spr_polarbear_snowballdownright_sheet;
                    } else { // Player is higher
                        throw_sprite = spr_polarbear_snowballupright_sheet;
                    }
                    // Safety check if sprite exists
                    if (!sprite_exists(throw_sprite)) {
                         show_debug_message("ERROR: Selected throw sprite does not exist! Reverting to passive.");
                         mood = "passive";
                         throw_sprite = noone;
                         throw_timer = 0; // Cancel throw
                    } else {
                         show_debug_message("Polar Bear starting throw. Sprite: " + sprite_get_name(throw_sprite));
                         image_speed = 0; // Ensure speed is 0 until throw anim logic calculates it next step
                    }

                } else if (dist_to_player <= view_range) {
                    // --- In View Range (but not attack): Move Closer ---
                    var stop_distance = attack_distance - 8; // Stop slightly before exact attack range
                    if (dist_to_player > stop_distance) {
                         var chase_dir = point_direction(x, y, _player_inst.x, _player_inst.y);
                         xspd = lengthdir_x(move_spd, chase_dir);
                         yspd = lengthdir_y(move_spd, chase_dir);
                         image_speed = walk_anim_speed; // Play walk animation while chasing
                    } else {
                         xspd = 0;
                         yspd = 0;
                         image_speed = idle_anim_speed; // Idle while waiting to attack
                    }
                } else {
                    // --- Out of View Range: Calm Down ---
                    mood = "passive";
                    is_stopped = true; // Start passive state by stopping
                    stop_timer = 60; // Stop briefly before wandering
                    image_speed = idle_anim_speed; // Set idle speed for passive transition
                    show_debug_message("Polar Bear calmed down.");
                }
            }
        }
        break; // End angry state
} // End switch(mood)

// --- Collision Handling (using script) ---
xspd = handle_collision("x", xspd);
yspd = handle_collision("y", yspd);
// x and y are updated by handle_collision

// GMS handles image_index increment when image_speed is set > 0
// So, no need for manual image_index += image_speed here

set_depth(); // Set depth based on final y