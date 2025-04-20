   // obj_polarbear Collision Event with obj_snowball
   show_debug_message("DEBUG: Snowball (" + string(id) + ") colliding with Polar Bear (" + string(other.id) + ")");

   // Check if the polar bear instance still exists before trying to modify it
   if (instance_exists(other))
   {
       show_debug_message("Polar Bear instance exists. Setting mood to angry.");
       with (other) { // Use 'with' to ensure context is the polar bear
           mood = "angry";
           throw_interval_timer = 0;
           throw_timer = 0;
           is_stopped = false;
           throw_sprite = noone;

           // Correctly access the bear's idle_anim_speed
           if (variable_instance_exists(id, "idle_anim_speed")) { // 'id' inside 'with' refers to the bear
               image_speed = idle_anim_speed;
           } else {
               image_speed = 0;
               show_debug_message("WARNING: idle_anim_speed missing on Polar Bear!");
           }
           image_index = 0;
       }
   } else { show_debug_message("WARNING: Polar Bear instance was already destroyed."); }

   instance_destroy(); // Destroy the snowball (self)