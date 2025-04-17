if (global.chat_active) {
    show_debug_message("Map interaction blocked: Chat is active.");
    exit; // Prevent interaction when the chat window is open
}

// obj_map Mouse Left Pressed Event
var click_x = device_mouse_x_to_gui(0);
var click_y = device_mouse_y_to_gui(0);

show_debug_message("Mouse clicked at: " + string(click_x) + ", " + string(click_y));

// Define clickable regions for different rooms (halved size)
if (click_x > 87 - 25 && click_x < 87 + 25 && click_y > 283 - 25 && click_y < 283 + 25) {
    // Move to Beach
    show_debug_message("Beach region clicked");
    room_goto(rm_beach);
} else if (click_x > 185 - 25 && click_x < 185 + 25 && click_y > 228 - 25 && click_y < 228 + 25) {
    // Move to town
    show_debug_message("Town region clicked");
    room_goto(rm_town);
} else if (click_x > 55 - 25 && click_x < 55 + 25 && click_y > 190 - 25 && click_y < 190 + 25) {
    // Move to beach
    show_debug_message("Beach region clicked");
    room_goto(rm_beach);
} else if (click_x > 155 - 25 && click_x < 155 + 25 && click_y > 128 - 25 && click_y < 128 + 25) {
    // Move to ski village
    show_debug_message("Ski village region clicked");
    room_goto(rm_ski_village);
} else if (click_x > 280 - 25 && click_x < 280 + 25 && click_y > 250 - 25 && click_y < 250 + 25) {
    // Move to snow fort
    show_debug_message("Snow fort region clicked");
    room_goto(rm_snow_fort);
} else if (click_x > 410 - 25 && click_x < 410 + 25 && click_y > 277 - 25 && click_y < 277 + 25) {
    // Move to welcome room
    show_debug_message("Welcome room region clicked");
    room_goto(rm_welcome_room);
} else if (click_x > 380 - 25 && click_x < 380 + 25 && click_y > 230 - 25 && click_y < 230 + 25) {
    // Move to plaza
    show_debug_message("Plaza region clicked");
    room_goto(rm_plaza);
} else if (click_x > 395 - 25 && click_x < 395 + 25 && click_y > 170 - 25 && click_y < 170 + 25) {
    // Move to forest
    show_debug_message("Forest region clicked");
    room_goto(rm_forest);
} else if (click_x > 400 - 25 && click_x < 400 + 25 && click_y > 130 - 25 && click_y < 130 + 25) {
    // Move to cove
    show_debug_message("Cove region clicked");
    room_goto(rm_cove);
} else if (click_x > 135 - 25 && click_x < 135 + 25 && click_y > 60 - 25 && click_y < 60 + 25) {
    // Move to mountain top
    show_debug_message("Mountain top region clicked");
    room_goto(rm_ski_mountaintop);
} else {
    show_debug_message("No region matched. Click ignored.");
}

function create_warp_instance(target_room) {
    // Create a warp instance at the correct position
    var inst = instance_create_depth(0, 0, -9999, obj_warp);

    // Ensure the player warps to a valid position
    if (instance_exists(global.player_instance)) {
        inst.target_x = global.player_instance.x;
        inst.target_y = global.player_instance.y;
    } else {
        inst.target_x = 320; // Default center of the room (fallback)
        inst.target_y = 240;
    }

    inst.target_rm = target_room;
    inst.target_face = 0; // Set default direction
    inst.target_instance = global.player_instance;

    show_debug_message("DEBUG: Creating warp to " + string(target_room) + 
        " at (" + string(inst.target_x) + ", " + string(inst.target_y) + ")");
}