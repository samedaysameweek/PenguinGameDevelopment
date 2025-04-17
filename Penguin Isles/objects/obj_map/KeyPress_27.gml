if (global.chat_active) {
    show_debug_message("Map interaction blocked: Chat is active.");
    exit; // Prevent interaction when the chat window is open
}

camera_set_view_size(global.camera, global.camera_width, global.camera_height); // Restore original camera view size
instance_destroy(id);
show_debug_message("Map closed.");