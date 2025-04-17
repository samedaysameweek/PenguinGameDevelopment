// Existing logic for delay and scrolling
if (delay_timer > 0) {
    delay_timer -= 1;  // Countdown the delay timer
} else if (!animation_complete) {
    offset_y -= move_speed;  // Start scrolling after delay
    if (offset_y <= -scroll_distance) {
        offset_y = -scroll_distance;
        animation_complete = true;
    }
} else {
    if (button_alpha < 1) {
        button_alpha += fade_speed;  // Fade in buttons after animation
        if (button_alpha > 1) button_alpha = 1;
        
        for (var i = 0; i < array_length(button_ids); i++) {
            var btn_id = button_ids[i];
            if (instance_exists(btn_id)) {
                with (btn_id) {
                    image_alpha = other.button_alpha;
                }
            }
        }
    }
}

// Jetpack Guy Movement Logic
if (!animation_complete) {
    // Move `spr_menu_jetpackguy` upward as `offset_y` decreases
    jetpack_y = 80 - (offset_y * -1);
}

// Puffle Movement Logic
if (!animation_complete) {
    // Move `spr_menu_puffle` upward as `offset_y` decreases
    puffle_y = 80 - (offset_y * -1);
}

// Jetpack Guy Animation Logic
jetpack_image_index += jetpack_frame_speed;
if (jetpack_image_index >= sprite_get_number(spr_menu_jetpackguy)) {
    jetpack_image_index = 0;
}

// Puffle Animation Logic
puffle_image_index += puffle_frame_speed;
if (puffle_image_index >= sprite_get_number(spr_menu_puffle)) {
    puffle_image_index = 0;
}