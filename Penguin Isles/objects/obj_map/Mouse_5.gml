if (global.chat_active) {
    show_debug_message("Map interaction blocked: Chat is active.");
    exit;
}

if (variable_global_exists("last_room") && global.last_room != noone) {
    show_debug_message("Returning to previous room: " + string(global.last_room));
    var target_room = global.last_room;
    global.last_room = noone; // Reset after use
	room_goto(target_room);
} else {
    show_debug_message("No previous room recorded. Returning to default.");
    room_goto(rm_welcome_room);
}
