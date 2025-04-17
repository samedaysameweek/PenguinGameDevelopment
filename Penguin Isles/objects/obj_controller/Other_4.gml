// --- obj_controller: Other Event: Room Start (Other_4) ---

var _current_room_name = room_get_name(room);
show_debug_message("CONTROLLER ROOM START: Entering room: " + _current_room_name);

// --- Determine if this is a UI/Special Room ---
var is_non_gameplay_room = (room == rm_init || room == rm_main_menu || room == rm_map ||
                            room == rm_pause_menu || room == rm_settings_menu || room == rm_saveload ||
                            room == rm_colorpicker_menu); // Add any other non-gameplay rooms here

// --- Exit immediately if it's a non-gameplay room ---
if (is_non_gameplay_room) {
    show_debug_message("CONTROLLER ROOM START: Non-gameplay room detected. Skipping player creation and state load.");
    if (!instance_exists(obj_ui_manager)) {
        if (!layer_exists("UI")) { layer_create(-10000, "UI"); }
        instance_create_layer(0, 0, "UI", obj_ui_manager);
        show_debug_message("CONTROLLER ROOM START: Created obj_ui_manager in UI room.");
    }
    if (variable_global_exists("is_loading_game") && global.is_loading_game) {
        show_debug_message("CONTROLLER ROOM START: Resetting global.is_loading_game flag (in UI room).");
        global.is_loading_game = false;
    }
    exit;
}

// --- Gameplay Room Logic ---

// --- 1. Determine Player Start Position & Facing ---
var start_x, start_y, start_face;
if (variable_global_exists("is_loading_game") && global.is_loading_game) {
    start_x = global.player_x;
    start_y = global.player_y;
    start_face = global.last_player_face ?? DOWN;
    show_debug_message("CONTROLLER ROOM START (Load): Using saved player pos (" + string(start_x) + "," + string(start_y) + ") Face: " + string(start_face));
} else if (variable_global_exists("warp_target_x") && !is_undefined(global.warp_target_x)) {
    start_x = global.warp_target_x;
    start_y = global.warp_target_y;
    start_face = global.warp_target_face ?? DOWN;
    global.warp_target_x = undefined; // Clear warp targets
    global.warp_target_y = undefined;
    global.warp_target_face = undefined;
    show_debug_message("CONTROLLER ROOM START (Warp): Using warp target pos (" + string(start_x) + "," + string(start_y) + ") Face: " + string(start_face));
} else {
    show_debug_message("CONTROLLER ROOM START (Default): Looking for obj_spawn_point...");
    var default_spawn = instance_find(obj_spawn_point, 0);
    if (instance_exists(default_spawn)) {
         start_x = default_spawn.x;
         start_y = default_spawn.y;
         show_debug_message("CONTROLLER ROOM START (Default): Found spawn point instance " + string(default_spawn) + " at (" + string(start_x) + "," + string(start_y) + ")");
    } else {
         show_debug_message("CONTROLLER ROOM START (Default): No instance of obj_spawn_point found. Defaulting to room center.");
         start_x = room_width / 2;
         start_y = room_height / 2;
    }
    start_face = DOWN;
    show_debug_message("CONTROLLER ROOM START (Default): Using determined default pos (" + string(start_x) + "," + string(start_y) + ") Face: " + string(start_face));
}

// --- 2. Clean Up Any Stray Player Instances ---
with(obj_player_base) {
    if (id != other.id) {
         show_debug_message("CONTROLLER ROOM START WARNING: Found unexpected player instance (" + string(id) + ", obj: " + object_get_name(object_index) + "). Destroying it.");
         instance_destroy();
    }
}
global.player_instance = noone;

// --- 3. Create or Position Player Instance ---
var player_obj = obj_player;
if (variable_global_exists("current_skin")) {
    switch (global.current_skin) {
        case "icetruck": player_obj = obj_player_icetruck; break;
        case "tube": player_obj = obj_player_tube; break;
        case "toboggan": player_obj = obj_player_toboggan; break;
        case "sled_player": player_obj = obj_sled_player; break;
        case "ninja": player_obj = obj_player_ninja; break;
        default: player_obj = obj_player; break;
    }
} else {
    show_debug_message("CONTROLLER ROOM START WARNING: global.current_skin not set! Defaulting to obj_player.");
    global.current_skin = "player";
}
if (!object_exists(player_obj)) {
     show_debug_message("CONTROLLER ROOM START FATAL ERROR: Target player object '" + object_get_name(player_obj) + "' does not exist!");
     player_obj = obj_player;
     global.current_skin = "player";
     if (!object_exists(player_obj)) {
          show_debug_message("CONTROLLER ROOM START FATAL ERROR: Fallback obj_player also does not exist!");
          exit;
     }
}
if (!layer_exists("Instances")) { layer_create(0, "Instances"); }
global.player_instance = instance_create_layer(start_x, start_y, "Instances", player_obj);
if (instance_exists(global.player_instance)) {
    global.player_instance.persistent = true;
    if (variable_instance_exists(global.player_instance, "face")) { global.player_instance.face = start_face; }
    global.player_instance.image_blend = global.player_color;
    global.player_instance.visible = true;
    show_debug_message("Created/Positioned player instance: " + string(global.player_instance) + " with skin: " + global.current_skin);
} else {
    show_debug_message("CONTROLLER ROOM START FATAL ERROR: Failed to create player instance for skin: " + global.current_skin);
    exit;
}

// --- 4. Load Room State ---
if (ds_map_exists(global.room_states, _current_room_name)) {
    show_debug_message("CONTROLLER ROOM START: Loading saved state for room: " + _current_room_name);
    load_room_state(room);
} else {
    show_debug_message("CONTROLLER ROOM START: No saved state found for room: " + _current_room_name);
}

// --- 5. Final Setup (Reset loading flag) ---
if (variable_global_exists("is_loading_game") && global.is_loading_game) {
    show_debug_message("CONTROLLER ROOM START: Resetting global.is_loading_game flag.");
    global.is_loading_game = false;
}

// --- CAMERA AND VIEW SETUP ---
// --- CAMERA AND VIEW SETUP ---
// Assign camera to view 0 *first*
view_set_camera(0, global.camera);
view_enabled = true;
view_visible[0] = true; // Ensure Viewport 0 is visible
show_debug_message("CONTROLLER ROOM START: Set view[0] to use global.camera (ID: " + string(global.camera) + ")");

// Define intended view size
var intended_view_width = 288;
var intended_view_height = 216;

// Set camera view size
var view_width = min(intended_view_width, room_width);
var view_height = min(intended_view_height, room_height);
camera_set_view_size(global.camera, view_width, view_height);
show_debug_message("Set camera view size to " + string(view_width) + "x" + string(view_height));

// Set camera border to zero
camera_set_view_border(global.camera, 0, 0);
show_debug_message("Set camera view border to (0, 0)");

// --- REMOVED Explicit Viewport Settings ---
// view_set_hborder(0, 0); // REMOVED
// view_set_vborder(0, 0); // REMOVED
// view_set_xport(0, 0);   // REMOVED (These port settings are likely fine at default anyway)
// view_set_yport(0, 0);   // REMOVED
// view_set_wport(0, display_get_gui_width()); // REMOVED
// view_set_hport(0, display_get_gui_height()); // REMOVED
// show_debug_message("Explicitly set Viewport 0 border=(0,0) and port settings."); // REMOVED
// --- END REMOVED SECTION ---

// Determine camera behavior based on room size vs. view size
if (room_width <= view_width && room_height <= view_height) {
    // Room fits entirely within view, fix camera at (0, 0)
    camera_set_view_target(global.camera, noone);
    camera_set_view_speed(global.camera, -1, -1);
    camera_set_view_pos(global.camera, 0, 0);
    show_debug_message("Camera fixed at (0, 0) for small room.");
} else {
    // Room is larger than view, follow the player
    if (instance_exists(global.player_instance)) {
        // Set Target FIRST
        camera_set_view_target(global.camera, global.player_instance);

        // Set Speed SECOND
        camera_set_view_speed(global.camera, -1, -1); // Instant follow (centered)
        show_debug_message("Camera set to follow player (ID: " + string(global.player_instance) + ") with INSTANT speed (-1, -1)");

        // Set Initial Position THIRD (Calculated based on target and view size)
        var cam_x = global.player_instance.x - (view_width / 2);
        var cam_y = global.player_instance.y - (view_height / 2);
        cam_x = clamp(cam_x, 0, max(0, room_width - view_width));
        cam_y = clamp(cam_y, 0, max(0, room_height - view_height));
        camera_set_view_pos(global.camera, cam_x, cam_y);
        show_debug_message("Camera initial position set to (" + string(cam_x) + ", " + string(cam_y) + ")");

    } else {
        // Fallback if no player
        show_debug_message("CONTROLLER ROOM START WARNING: No player instance exists to follow! Fixing camera at (0,0).");
        camera_set_view_target(global.camera, noone);
        camera_set_view_speed(global.camera, -1, -1);
        camera_set_view_pos(global.camera, 0, 0);
    }
}

// --- 7. Ensure UI Layer and Manager ---
if (!layer_exists("UI")) {
    layer_create(-10000, "UI");
    show_debug_message("CONTROLLER ROOM START: Created 'UI' Layer.");
}
if (!instance_exists(obj_ui_manager)) {
    instance_create_layer(0, 0, "UI", obj_ui_manager);
    show_debug_message("CONTROLLER ROOM START: Created obj_ui_manager in Gameplay room.");
}

show_debug_message("CONTROLLER ROOM START: Finished setup for room: " + _current_room_name);