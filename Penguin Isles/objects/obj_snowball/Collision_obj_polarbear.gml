// Collision Event with obj_snowball
show_debug_message("DEBUG: Snowball (" + string(id) + ") colliding with Polar Bear (" + string(other.id) + ")");

// Apply effect to the specific Polar Bear instance that was hit
with (other) {
    if (mood != "angry") {
        show_debug_message("Polar Bear (" + string(id) + ") hit while passive/other state. Becoming angry!");
    } else {
        show_debug_message("Polar Bear (" + string(id) + ") hit while already angry.");
    }
    mood = "angry";         // Force angry state
    throw_timer = 0;        // Stop current throw animation if any
    throw_interval_timer = 0; // Reset throw cooldown to allow immediate retaliation
    image_speed = idle_anim_speed; // Stop walking/throwing animation briefly
    image_index = 0;         // Reset animation index
    is_stopped = false;      // Ensure bear isn't stuck in a stopped state
    wander_timer = 0;       // Stop current wander path
    xspd = 0;                // Stop current movement
    yspd = 0;
}

// Destroy the snowball
instance_destroy();