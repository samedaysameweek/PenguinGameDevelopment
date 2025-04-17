
if (!global.is_loading_game) {
    save_room_state(room);
show_debug_message("Saved state for room: " + room_get_name(room));
}