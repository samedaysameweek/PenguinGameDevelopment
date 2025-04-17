// scripts/scr_handle_collision/scr_handle_collision.gml
function handle_collision(axis, speed) {
    var sign_speed = sign(speed);
    var abs_speed = abs(speed);
    var move_dist = 0;
    var step = abs_speed; // Start step size based on absolute speed

    if (abs_speed == 0) return 0; // No speed, no movement needed

    // Iteratively check smaller steps for precision
    while (step > 0.5) {  // Precision threshold (adjust if needed)
        var check_x = x;
        var check_y = y;
        if (axis == "x") {
            check_x += (move_dist + step) * sign_speed;
        } else { // axis == "y"
            check_y += (move_dist + step) * sign_speed;
        }

        if (!place_meeting(check_x, check_y, obj_wall)) {
            // If this step is clear, add it to the distance we can move
            move_dist += step;
        }
        // Halve the step size for the next iteration
        step /= 2;
    }

    // Apply the final calculated movement directly to the instance's coordinates
    if (axis == "x") {
        x += move_dist * sign_speed;
    } else { // axis == "y"
        y += move_dist * sign_speed;
    }

    // Return the actual distance moved (can be useful, but we won't use it for direct position update)
    return move_dist * sign_speed;
}