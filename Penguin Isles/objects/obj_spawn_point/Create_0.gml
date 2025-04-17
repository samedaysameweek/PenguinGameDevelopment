// obj_spawn_point: Create Event

// This object is just a marker for the room editor.
// It should not be visible during gameplay.
visible = false;

// You can optionally set a depth if needed, though visibility false usually suffices.
// depth = 10000; // Set very deep if needed for editor visibility layering

show_debug_message("Spawn Point marker created at (" + string(x) + ", " + string(y) + ")");