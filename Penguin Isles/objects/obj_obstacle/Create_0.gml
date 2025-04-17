// Create Event for obj_obstacle
move_speed = 5; // Speed at which obstacles move upwards

// Step Event for obj_obstacle
y += move_speed;

// Destroy the obstacle if it goes off the top of the screen
if (y < -sprite_height) {
    instance_destroy();
}

//depth
depth = -bbox_bottom;