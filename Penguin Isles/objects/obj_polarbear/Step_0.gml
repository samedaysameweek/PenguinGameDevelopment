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
var _player_inst = instance_exists(global.player_instance) ? global.player_instance : noone;

// Determine player distance ONLY if player exists
dist_to_player = (_player_inst != noone) ? distance_to_object(_player_inst) : 10000;
if (_player_inst == noone && mood == "angry") { mood = "passive"; } // Calm down if player gone

// --- DEBUG: Log Start of State Logic ---
// show_debug_message("PB Step Start: Mood=" + mood + ", is_stopped=" + string(is_stopped) + ", xspd=" + string(xspd) + ", yspd=" + string(yspd));

// --- State Machine ---
switch (mood) {
    case "passive":
        image_speed = 0; // Default for passive
        xspd = 0;
        yspd = 0;

        if (is_stopped) {
            image_speed = idle_anim_speed; // Usually 0
            if (stop_timer > 0) {
                stop_timer--;
                // Face player logic...
                if (_player_inst != noone && dist_to_player < view_range / 2) {
                     var dir_to_player = point_direction(x, y, _player_inst.x, _player_inst.y);
                     var angle = round(dir_to_player / 45) % 8;
                     var face_map = [PB_RIGHT, PB_UP_RIGHT, PB_UP, PB_UP_LEFT, PB_LEFT, PB_DOWN_LEFT, PB_DOWN, PB_DOWN_RIGHT];
                     current_direction = face_map[angle];
                }
            } else {
                is_stopped = false;
                wander_timer = irandom_range(60, 180);
                current_direction = irandom(7);
                 // show_debug_message("PB Passive: Stop timer ended. Starting wander. New Dir: " + string(current_direction));
            }
        } else { // Wandering
            image_speed = walk_anim_speed; // Should be > 0
            if (wander_timer > 0) {
                wander_timer--;
                // Calculate speed based on current_direction macro
                switch (current_direction) { /* ... speed calculation ... */
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
                 // show_debug_message("PB Passive: Wander timer ended. Deciding next action.");
                if (random(1) < 0.3) { // Stop
                    is_stopped = true;
                    stop_timer = irandom_range(60, 180);
                     // show_debug_message("PB Passive: Decided to stop.");
                } else { // Change direction
                    current_direction = irandom(7);
                    wander_timer = irandom_range(60, 180);
                     // show_debug_message("PB Passive: Decided to wander again. New Dir: " + string(current_direction));
                }
                 // Reset speed here to reflect decision immediately
                xspd = 0;
                yspd = 0;
                if (!is_stopped) { image_speed = walk_anim_speed; } else { image_speed = idle_anim_speed; }
            }
        }
        break; // End passive state

    case "angry":
        image_speed = 0; // Default for angry
        xspd = 0;
        yspd = 0;

        if (_player_inst == noone) { mood = "passive"; break; }

        // Face the player
        var dir_to_player = point_direction(x, y, _player_inst.x, _player_inst.y);
        var angle = round(dir_to_player / 45) % 8;
        var face_map = [PB_RIGHT, PB_UP_RIGHT, PB_UP, PB_UP_LEFT, PB_LEFT, PB_DOWN_LEFT, PB_DOWN, PB_DOWN_RIGHT];
        current_direction = face_map[angle];

        if (throw_timer > 0) {
            // --- Currently Throwing ---
            throw_timer--;
            if (throw_sprite != noone && sprite_exists(throw_sprite)) {
                 var _num_frames = sprite_get_number(throw_sprite);
                 image_speed = (_num_frames > 0 && throw_duration > 0) ? (_num_frames / throw_duration) : 0;
                 // show_debug_message("PB Throwing: Anim Speed=" + string(image_speed));
            } else { image_speed = 0; }

            if (throw_timer <= 0) { // Throw finished
                 if (_player_inst != noone) {
                     var snowball = instance_create_layer(x, y + 5, "Instances", obj_snowball); // Adjust Y slightly
                     snowball.direction = dir_to_player;
                     snowball.speed = 5;
                      show_debug_message("Polar Bear threw snowball!");
                 }
                 image_speed = idle_anim_speed; // Transition to idle speed
                 image_index = 0;
                 throw_interval_timer = throw_interval;
                 throw_sprite = noone;
                  // show_debug_message("PB Throwing: Finished. Starting Cooldown.");
            }
        } else { // Not Throwing
            if (throw_interval_timer > 0) { // Cooldown
                throw_interval_timer--;
                image_speed = idle_anim_speed; // Idle during cooldown
                 // show_debug_message("PB Angry: Cooldown. Timer=" + string(throw_interval_timer));
            } else { // Cooldown Finished
                 // show_debug_message("PB Angry: Cooldown finished. Checking range. Dist=" + string(dist_to_player));
                if (dist_to_player <= attack_distance) { // Start Throw
                    throw_timer = throw_duration;
                    image_index = 0;
                    if (_player_inst.y > y + 10) { throw_sprite = spr_polarbear_snowballdownright_sheet; }
                    else { throw_sprite = spr_polarbear_snowballupright_sheet; }
                    if (!sprite_exists(throw_sprite)) { /* error handling */ mood = "passive"; throw_sprite = noone; throw_timer = 0; }
                    else { show_debug_message("PB Angry: Starting throw. Sprite: " + sprite_get_name(throw_sprite)); image_speed = 0; }
                } else if (dist_to_player <= view_range) { // Chase
                    var stop_distance = attack_distance - 8;
                    if (dist_to_player > stop_distance) {
                         var chase_dir = point_direction(x, y, _player_inst.x, _player_inst.y);
                         xspd = lengthdir_x(move_spd, chase_dir);
                         yspd = lengthdir_y(move_spd, chase_dir);
                         image_speed = walk_anim_speed; // Walk anim while chasing
                          // show_debug_message("PB Angry: Chasing. Speed set.");
                    } else {
                         image_speed = idle_anim_speed; // Idle when close enough
                         // show_debug_message("PB Angry: Close enough, idling.");
                    }
                } else { // Calm Down
                    mood = "passive";
                    is_stopped = true;
                    stop_timer = 60;
                    image_speed = idle_anim_speed;
                    show_debug_message("Polar Bear calmed down (out of range).");
                }
            }
        }
        break; // End angry state
} // End switch(mood)

// --- DEBUG: Log final speed and image_speed BEFORE collision ---
// show_debug_message("PB Pre-Collision: Mood=" + mood + ", xspd=" + string(xspd) + ", yspd=" + string(yspd) + ", image_speed=" + string(image_speed));

// --- Collision Handling (using script) ---
xspd = handle_collision("x", xspd);
yspd = handle_collision("y", yspd);
// x and y are updated by handle_collision

// --- DEBUG: Log position AFTER collision ---
// show_debug_message("PB Post-Collision: X=" + string(x) + ", Y=" + string(y));

set_depth();