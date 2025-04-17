if (global.game_started) {
    y -= move_speed; // Move upwards

    // Reset position if off-screen
    if (y < -sprite_height) {
        y = room_height + sprite_height; // Reset to below the room
        x = irandom_range(0, room_width - sprite_width); // Randomize horizontal position
    }
}