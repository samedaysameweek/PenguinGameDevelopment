   // obj_warp: Create Event
   target_rm = 0;
   target_x = 0;
   target_y = 0;
   target_face = 0;
   target_instance = noone;

   persistent = true; // <<< MAKE PERSISTENT

   // Alarm 0 will reset the global cooldown
   alarm[0] = room_speed / 2; // Keep the alarm short

   show_debug_message("obj_warp initialized (Persistent: " + string(persistent) + "). Target Room: " + string(target_rm));