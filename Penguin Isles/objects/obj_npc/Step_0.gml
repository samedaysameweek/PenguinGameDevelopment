// In obj_npc Step Event
if (place_meeting(x, y, global.player_instance)) {
    if (keyboard_check_pressed(ord("E"))) {
        if (!instance_exists(obj_chat_window)) {
            var chat = instance_create_layer(0, 0, "UI", obj_chat_window);
            chat.dialog_data = dialog_data;  // Assign this NPC's unique dialog_data
            global.chat_npc = id;            // Set this NPC as the chat target
            global.chat_active = true;       // Make the chat window visible
        }
    }
}