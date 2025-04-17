// Step Event for obj_player_icetruck
// Prevent movement when paused or colour picker is open
if (global.is_pause_menu_active || instance_exists(obj_icetruck_colourpicker) || instance_exists(obj_inventory_expanded)) {
    show_debug_message("Paused or Colour Picker Open: " + string(instance_exists(obj_icetruck_colourpicker) + instance_exists(obj_inventory_expanded)));
    exit;
}

// Handle exiting the truck
if (keyboard_check_pressed(ord("E"))) {
    if (!place_meeting(x, y, obj_icetruck)) {
        var exit_x = x;
        var exit_y = y + 16;
        instance_destroy(id);
        global.player_instance = instance_create_layer(exit_x, exit_y, "Instances", obj_player);
        instance_create_layer(x, y, "Instances", obj_icetruck);
        if (instance_exists(obj_controller)) {
            obj_controller.switch_skin("player"); // Prefixed call
        }
        show_debug_message("Exited ice truck. Current skin: " + global.current_skin);
    } else {
        show_debug_message("No space to exit!");
    }
}

// Handle movement input
var right_key = keyboard_check(ord("D")) || keyboard_check(vk_right);
var left_key = keyboard_check(ord("A")) || keyboard_check(vk_left);
var up_key = keyboard_check(ord("W")) || keyboard_check(vk_up);
var down_key = keyboard_check(ord("S")) || keyboard_check(vk_down);

xspd = (right_key - left_key) * move_spd;
yspd = (down_key - up_key) * move_spd;

// Update direction and animation
if (xspd != 0 || yspd != 0) {
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
    image_speed = 0.1;
    image_index += image_speed;
    if (image_index >= 2) image_index = 0;
} else {
    image_speed = 0;
    image_index = 0;
}

// Apply collision handling
// Apply collision handling
if (place_meeting(x + xspd, y, obj_wall)) xspd = 0;
if (place_meeting(x, y + yspd, obj_wall)) yspd = 0;
x += handle_collision("x", xspd);
y += handle_collision("y", yspd);

set_depth();