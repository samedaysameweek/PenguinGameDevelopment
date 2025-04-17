/// @function get_puffle_sprite_data(direction)
/// @param direction - The facing direction (e.g., DOWN, LEFT)
/// @returns Array [base_subimage, xscale]
function get_puffle_sprite_data(direction) {
    switch (direction) {
        case DOWN: return [0, 1];       // Row 1: Subimages 0-7
        case DOWN_LEFT: return [8, 1];  // Row 2: Subimages 8-15
        case LEFT: return [16, 1];      // Row 3: Subimages 16-23
        case UP_LEFT: return [24, 1];   // Row 4: Subimages 24-31
        case UP: return [32, 1];        // Row 5: Subimages 32-39
        case DOWN_RIGHT: return [8, -1]; // Use Down-Left, flipped
        case RIGHT: return [16, -1];    // Use Left, flipped
        case UP_RIGHT: return [24, -1]; // Use Up-Left, flipped
        default: return [0, 1];         // Default to Down
    }
}