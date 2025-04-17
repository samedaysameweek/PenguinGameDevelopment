// obj_controller Alarm[1] Event
if (!global.is_pause_menu_active) { // Avoid saving during pause
    save_room_state(room);
    show_debug_message("Periodic save triggered for room: " + room_get_name(room));
}
alarm[1] = room_speed * 5; // Reset alarm