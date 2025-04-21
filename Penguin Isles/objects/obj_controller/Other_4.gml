// --- obj_controller: Other Event: Room Start (Other_4) --- UPDATED FOR NEW SYSTEM

var _current_room_name = room_get_name(room);
show_debug_message("CONTROLLER ROOM START: Entering room: " + _current_room_name);

// --- Determine if this is a UI/Special Room ---
var is_non_gameplay_room = (room == rm_init || room == rm_main_menu || room == rm_map ||
                           room == rm_pause_menu || room == rm_settings_menu || room == rm_saveload ||
                           room == rm_colorpicker_menu);
var _is_fresh_load = (variable_global_exists("is_loading_game") && global.is_loading_game == true);

if (is_non_gameplay_room) {
    show_debug_message("CONTROLLER ROOM START: Non-gameplay room detected...");
    if (!instance_exists(obj_ui_manager)) {
        instance_create_layer(0, 0, "UI", obj_ui_manager);
        show_debug_message("CONTROLLER ROOM START: Created obj_ui_manager in Non-Gameplay room.");
    }
    if (_is_fresh_load) {
        global.is_loading_game = false;
        show_debug_message("CONTROLLER ROOM START: Reset global.is_loading_game (in UI room).");
    }
    exit;
}

// --- Gameplay Room Logic ---
show_debug_message("CONTROLLER ROOM START: Loading state for room: " + _current_room_name);

// Load room state using appropriate method
if (script_exists(asset_get_index("RoomStateManager_LoadState"))) {
    // Use new system
    show_debug_message("CONTROLLER ROOM START: Using RoomStateManager_LoadState");
    RoomStateManager_LoadState(_current_room_name, _is_fresh_load);
} 
else if (script_exists(asset_get_index("load_room_state"))) {
    // Use backward compatibility function
    show_debug_message("CONTROLLER ROOM START: Using load_room_state");
    load_room_state(room, _is_fresh_load);
}
else {
    show_debug_message("CONTROLLER ROOM START: WARNING - No room state load function available!");
}

// --- Handle Player Spawning ---
var start_x, start_y, start_face;

if (_is_fresh_load) {
    start_x = global.player_x;
    start_y = global.player_y;
    start_face = global.last_player_face ?? DOWN; // Use saved face if available
    show_debug_message("CONTROLLER ROOM START (Load): Using saved player pos (" + string(start_x) + "," + string(start_y) + ")");
} else {
    // Check for warp target coordinates
    if (variable_global_exists("warp_target_x") && !is_undefined(global.warp_target_x)) {
        start_x = global.warp_target_x;
        start_y = global.warp_target_y;
        start_face = global.warp_target_face ?? DOWN; // Use warp face if available
        show_debug_message("CONTROLLER ROOM START: Using warp target pos (" + string(start_x) + "," + string(start_y) + ")");
        
        // Clear warp targets after use
        global.warp_target_x = undefined;
        global.warp_target_y = undefined;
        global.warp_target_face = undefined;
    } else {
        // Use spawn point or default position
        var spawn = instance_find(obj_spawn_point, 0);
        if (spawn != noone) {
            start_x = spawn.x;
            start_y = spawn.y;
            // Check if 'face' variable exists before reading it
            if (variable_instance_exists(spawn, "face")) {
                start_face = spawn.face;
            } else {
                start_face = DOWN; // Default if 'face' doesn't exist
                show_debug_message("CONTROLLER ROOM START: Spawn point found, but missing 'face' variable. Defaulting to DOWN.");
            }
            show_debug_message("CONTROLLER ROOM START: Using spawn point pos (" + string(start_x) + "," + string(start_y) + ") Face: " + string(start_face));
        } else {
            // Default position if no spawn point found
            start_x = room_width / 2;
            start_y = room_height / 2;
            start_face = DOWN;
            show_debug_message("CONTROLLER ROOM START: Using default center pos (" + string(start_x) + "," + string(start_y) + ")");
        }
    }
}

// Create player if needed
if (!instance_exists(global.player_instance)) {
    global.player_instance = noone; // Explicitly clear before creating new
    
    // *** ADDED CHECK AND DEFAULT FOR global.current_skin ***
    if (!variable_global_exists("current_skin") || is_undefined(global.current_skin)) {
        show_debug_message("CONTROLLER ROOM START: global.current_skin was not set. Defaulting to 'player'.");
        global.current_skin = "player";
    }
    // *** END ADDED CHECK ***
    
    var player_obj = asset_get_index("obj_" + global.current_skin);
    if (!object_exists(player_obj)) {
        show_debug_message("CONTROLLER ROOM START: Warning - Object for skin '" + global.current_skin + "' not found. Defaulting to obj_player.");
        player_obj = obj_player; // Fallback to default player
        global.current_skin = "player"; // Ensure current_skin reflects the actual object used
    }
    
    global.player_instance = instance_create_layer(start_x, start_y, "Instances", player_obj);
    if (variable_instance_exists(global.player_instance, "face")) {
        global.player_instance.face = start_face;
    }
    
    show_debug_message("Created player instance: " + string(global.player_instance) + 
                      " skin: " + global.current_skin + 
                      " at (" + string(start_x) + "," + string(start_y) + ")");
}

// Ensure camera follows player
if (instance_exists(global.player_instance)) {
    camera_set_view_target(global.camera, global.player_instance);
} 