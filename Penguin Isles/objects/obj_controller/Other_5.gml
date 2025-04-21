// obj_controller -> Other Event: Room End (Other_5.gml) - UPDATED FOR NEW SYSTEM

var _leaving_room_name = room_get_name(room);
show_debug_message("obj_controller Room End: Transitioning from room: " + _leaving_room_name);

// Check for non-gameplay room
var is_non_gameplay_room = (room == rm_init || room == rm_main_menu || room == rm_map ||
                           room == rm_pause_menu || room == rm_settings_menu || room == rm_saveload ||
                           room == rm_colorpicker_menu);
var _is_currently_loading = variable_global_exists("is_loading_game") && global.is_loading_game;

// Skip save for special conditions
if (_is_currently_loading) {
    show_debug_message("Skipping room state save: Currently loading game.");
    exit;
}

if (is_non_gameplay_room) {
    show_debug_message("Skipping room state save: Non-gameplay room (" + _leaving_room_name + ").");
    exit;
}

// Save room state using the appropriate method
if (script_exists(asset_get_index("RoomStateManager_SaveState"))) {
    // Use new system
    show_debug_message("Using RoomStateManager_SaveState for room: " + _leaving_room_name);
    RoomStateManager_SaveState(room);
} 
else if (script_exists(asset_get_index("save_room_state"))) {
    // Use backward compatibility function
    show_debug_message("Using save_room_state for room: " + _leaving_room_name);
    save_room_state(room);
}
else {
    show_debug_message("WARNING: No room state save function available!");
    
    // Fallback - ensure room_states exists
    if (!variable_global_exists("room_states")) {
        global.room_states = ds_map_create();
        show_debug_message("Created missing global.room_states map");
    }
    
    // Direct fallback implementation - just add empty array as placeholder
    if (ds_exists(global.room_states, ds_type_map) && !ds_map_exists(global.room_states, _leaving_room_name)) {
        ds_map_add(global.room_states, _leaving_room_name, []);
        show_debug_message("Added empty placeholder state for room: " + _leaving_room_name);
    }
}