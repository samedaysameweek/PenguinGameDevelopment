/// Alarm[0] Event
global.warp_cooldown = false;
show_debug_message("DEBUG: Warp cooldown finished. Warping allowed again.");
instance_destroy(); // Destroy the warp object itself after cooldown