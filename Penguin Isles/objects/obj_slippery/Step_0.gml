if (place_meeting(x, y, obj_player) || place_meeting(x, y, obj_player_tube)) {
    if (!sliding) {
        sliding = true;
        
        // Get the player's last movement direction
        var player = instance_nearest(x, y, obj_player); // Get closest player
        if (!instance_exists(player)) player = instance_nearest(x, y, obj_player_tube);

        if (instance_exists(player)) {
            slide_dir_x = sign(player.xspd);
            slide_dir_y = sign(player.yspd);
            slide_speed = max(abs(player.xspd), abs(player.yspd)); // Carry over momentum
        }
    }
}

// **Sliding Deceleration Logic**
if (sliding) {
    x += slide_dir_x * slide_speed;
    y += slide_dir_y * slide_speed;

    // Reduce speed gradually
    slide_speed *= 0.95; 

    // Stop sliding when slow enough
    if (slide_speed < 0.1) {
        sliding = false;
        slide_speed = 0;
    }

    // **Collision Handling (Bounce Effect)**
    if (place_meeting(x + slide_dir_x * slide_speed, y, obj_wall)) {
        slide_dir_x = -slide_dir_x; // Reverse direction on X collision
        slide_speed *= 0.7; // Reduce speed slightly when bouncing
    }
    
    if (place_meeting(x, y + slide_dir_y * slide_speed, obj_wall)) {
        slide_dir_y = -slide_dir_y; // Reverse direction on Y collision
        slide_speed *= 0.7;
    }
}
