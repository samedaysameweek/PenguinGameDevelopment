// Prevent player movement and interactions when paused
if (global.is_pause_menu_active) {
    exit; // This prevents the player from updating while paused
}

// Exit the tube
if (keyboard_check_pressed(ord("T"))) {
    if (global.current_skin == "tube" && !global.skin_switching) {
        obj_inventory.add_to_inventory("Tube");
        show_debug_message("Exiting tube, switching back to player...");
        var old_instance = id; // Store old instance ID
        if (instance_exists(obj_controller)) {
            obj_controller.switch_skin("player"); // Prefixed call
        }
        // Destroy old instance only after switching
        if (instance_exists(old_instance)) {
            instance_destroy(old_instance);
        }
    }
}


// Handle movement input
var right_key = keyboard_check(ord("D")) || keyboard_check(vk_right);
var left_key = keyboard_check(ord("A")) || keyboard_check(vk_left);
var up_key = keyboard_check(ord("W")) || keyboard_check(vk_up);
var down_key = keyboard_check(ord("S")) || keyboard_check(vk_down);

xspd = (right_key - left_key) * move_spd;
yspd = (down_key - up_key) * move_spd;

// Disable movement if the game is paused
if (instance_exists(obj_pauser)) {
    xspd = 0;
    yspd = 0;
}

// Update tube direction and sprite only if moving
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

// Ensure proper depth sorting
set_depth();

var is_sled_room = (room == rm_sled_racing);
if (is_sled_room) {
    if (instance_exists(obj_player_tube)) {
        with (obj_player_tube) {
            visible = false; // Hide the inventory
        }
        show_debug_message("DEBUG: Player Tube hidden in Sled Racing room.");
    }
} else {
    if (instance_exists(obj_player_tube)) {
        with (obj_player_tube) {
            visible = true; // Show the inventory
        }
    }
}
