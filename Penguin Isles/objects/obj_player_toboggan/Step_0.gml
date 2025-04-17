// --- obj_player_toboggan: Step Event ---
if (global.is_pause_menu_active) exit;

// Exit toboggan
if (keyboard_check_pressed(ord("T"))) {
    // Check skin and that a switch isn't already happening
    if (global.current_skin == "toboggan" && !global.skin_switching) {
        // Ensure inventory exists and add item back
        if (instance_exists(obj_inventory)) {
            obj_inventory.inventory_add("Toboggan");
        } else {
             show_debug_message("WARNING: obj_inventory not found when exiting toboggan!");
        }
        show_debug_message("Exiting toboggan, switching back to player...");
        // *** CALL obj_controller's method ***
        if (instance_exists(obj_controller)) {
            obj_controller.switch_skin("player"); // Correct way to call
        } else {
            show_debug_message("ERROR: obj_controller not found for skin switch!");
            // Fallback: might need to manually destroy/recreate player if controller lost
        }
        // NOTE: switch_skin handles destroying the old instance (the toboggan)
    }
}

// Movement input
var right_key = keyboard_check(ord("D")) || keyboard_check(vk_right);
var left_key = keyboard_check(ord("A")) || keyboard_check(vk_left);
var up_key = keyboard_check(ord("W")) || keyboard_check(vk_up);
var down_key = keyboard_check(ord("S")) || keyboard_check(vk_down);
xspd = (right_key - left_key) * move_spd;
yspd = (down_key - up_key) * move_spd;

// Pause check
if (instance_exists(obj_pauser)) {
    xspd = 0;
    yspd = 0;
}

// Update direction
if (xspd != 0 || yspd != 0) {
    if (xspd > 0 && yspd == 0) face = RIGHT;
    else if (xspd < 0 && yspd == 0) face = LEFT;
    else if (yspd > 0 && xspd == 0) face = DOWN;
    else if (yspd < 0 && xspd == 0) face = UP;
    else if (xspd > 0 && yspd > 0) face = DOWN_RIGHT;
    else if (xspd > 0 && yspd < 0) face = UP_RIGHT;
    else if (xspd < 0 && yspd > 0) face = DOWN_LEFT;
    else if (xspd < 0 && yspd < 0) face = UP_LEFT;
}

// Collision handling
if (place_meeting(x + xspd, y, obj_wall)) xspd = 0;
if (place_meeting(x, y + yspd, obj_wall)) yspd = 0;

// Apply movement
if (irandom(1) == 0) {
    x += handle_collision("x", xspd * move_spd);
    y += handle_collision("y", yspd * move_spd);
} else {
    y += handle_collision("y", yspd * move_spd);
    x += handle_collision("x", xspd * move_spd);
}

// Depth sorting
set_depth();