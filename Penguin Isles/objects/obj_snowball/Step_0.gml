x += lengthdir_x(speed, direction);
y += lengthdir_y(speed, direction);

// Check for collision with walls or out of bounds
if (place_meeting(x, y, obj_wall) || x < 0 || x > room_width || y < 0 || y > room_height) {
    instance_destroy();
}