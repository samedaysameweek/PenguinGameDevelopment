// obj_inventory_expanded: Create Event
global.game_paused = true;
depth = -10000;

// Default inventory states
global.inventory_open_state = "closed"; // Inventory starts in the closed state
global.inventory_visible = true; // Both sprites are visible by default

// Character variables
character_face = DOWN; // Default direction
character_action = "none"; // Default no action
character_image_index = 0; // Default animation frame

// Inventory grid specifications
var grid_start = [3, 6];
var grid_size = [7, 6];
var slot_width = 20;
var slot_height = 20;

// Create a 2D array to hold the inventory slots
inventory_slots = array_create(grid_size[1], array_create(grid_size[0], -1));

// Populate the inventory_slots with coordinates and slot indices
for (var row = 0; row < grid_size[1]; row++) {
    for (var col = 0; col < grid_size[0]; col++) {
        var slot_index = row * grid_size[0] + col + 1; // Slot indices start from 1
        var x1 = grid_start[0] + col * slot_width;
        var y1 = grid_start[1] + row * slot_height;
        var x2 = x1 + slot_width;
        var y2 = y1 + slot_height;
        
        inventory_slots[row][col] = {
            index: slot_index,
            x1: x1,
            y1: y1,
            x2: x2,
            y2: y2
        };
        
        show_debug_message("Slot " + string(slot_index) + ": (" + string(x1) + ", " + string(y1) + ") to (" + string(x2) + ", " + string(y2) + ")");
    }
}