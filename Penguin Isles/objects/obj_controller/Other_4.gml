// --- obj_controller: Other Event: Room Start (Other_4) --- SAFER CLEANUP

   var _current_room_name = room_get_name(room);
   show_debug_message("CONTROLLER ROOM START: Entering room: " + _current_room_name);

   // --- Determine if this is a UI/Special Room ---
   var is_non_gameplay_room = (room == rm_init || room == rm_main_menu || room == rm_map ||
                               room == rm_pause_menu || room == rm_settings_menu || room == rm_saveload ||
                               room == rm_colorpicker_menu);
   var _is_fresh_load = (variable_global_exists("is_loading_game") && global.is_loading_game == true);
   if (is_non_gameplay_room) {
    // [...] (Non-gameplay room logic remains the same)
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

// --- 1. Determine Player Start Position & Facing ---
   var start_x, start_y, start_face;
   var _used_warp_coords = false;
   if (_is_fresh_load) { /* ... Load logic ... */
     start_x = global.player_x; start_y = global.player_y; start_face = global.last_player_face ?? DOWN;
     show_debug_message("CONTROLLER ROOM START (Load): Using saved player pos (" + string(start_x) + "," + string(start_y) + ").");
}    else if (variable_global_exists("warp_target_x") && !is_undefined(global.warp_target_x)) { /* ... Player Warp logic ... */
     start_x = global.warp_target_x; start_y = global.warp_target_y; start_face = global.warp_target_face ?? DOWN;
     _used_warp_coords = true;
     show_debug_message("CONTROLLER ROOM START (Warp): Using PLAYER warp target pos (" + string(start_x) + "," + string(start_y) + ").");
}	 else { /* ... Default/Spawn Point logic ... */
      show_debug_message("CONTROLLER ROOM START (Default): Not loading and warp_target_x is undefined. Setting defaults first...");
      start_x = room_width / 2; start_y = room_height / 2; start_face = DOWN;
      var default_spawn = instance_find(obj_spawn_point, 0);
      if (instance_exists(default_spawn)) { start_x = default_spawn.x; start_y = default_spawn.y; }
      show_debug_message("CONTROLLER ROOM START (Default): Final default/spawn pos (" + string(start_x) + "," + string(start_y) + ") Face: " + string(start_face));
 }

// --- Clear warp coordinates AFTER deciding start pos ---
if (variable_global_exists("warp_target_x")) { /* ... Clear warp vars ... */
     if (is_undefined(global.warp_target_x)) { show_debug_message("CONTROLLER ROOM START: Global warp targets were already undefined (Likely NPC warp)."); }
     else { show_debug_message("CONTROLLER ROOM START: Clearing player warp target variables."); }
     global.warp_target_x = undefined; global.warp_target_y = undefined; global.warp_target_face = undefined; global.warp_target_inst_id = noone;
}

global.player_instance = noone;
show_debug_message("CONTROLLER ROOM START: Explicitly set global.player_instance = noone before creation.");

// --- 3. Create Player Instance ---
 var player_obj = obj_player; // Default
if (variable_global_exists("current_skin")) { /* ... code to find player_obj based on skin ... */
    var found_skin = false;
     for (var i = 0; i < array_length(global.skins); i++) { if (global.skins[i].name == global.current_skin) { if (object_exists(global.skins[i].object)) { player_obj = global.skins[i].object; found_skin = true; } else { /*Log Error*/ } break; } }
     if (!found_skin) { /* Log Warning & Default */ global.current_skin = "player"; player_obj = obj_player; }
} else { /* Log Warning & Default */ global.current_skin = "player"; player_obj = obj_player; }
if (!object_exists(player_obj)) { /* ... error handling ... */ if (object_exists(obj_player)) { player_obj = obj_player; global.current_skin = "player"; } else { exit; } }
if (!layer_exists("Instances")) { layer_create(0, "Instances"); }

var _new_player = instance_create_layer(start_x, start_y, "Instances", player_obj);

// --- SAFETY CHECK: Destroy duplicate player instances ---
if (instance_exists(_new_player)) {
    with(obj_player_base) { // Check parent type
        // Destroy any instance that IS a player type but NOT the newly created one, and NOT the controller itself
        if (id != _new_player && id != other.id && object_index != obj_controller) {
            show_debug_message("CONTROLLER ROOM START (Safety): Destroying potentially duplicate player instance: ID " + string(id) + " (" + object_get_name(object_index) + ")");
            instance_destroy(id);
        }
    }
}

// --- 4. Assign and Verify Global Player Instance ---
// Ensure global.player_instance *definitely* points to the new instance or noone.
if (instance_exists(_new_player)) {
     global.player_instance = _new_player; // Assign the new ID
     global.player_instance.persistent = true;
    if (variable_instance_exists(global.player_instance, "face")) { global.player_instance.face = start_face; }
    global.player_instance.image_blend = global.player_color;
    global.player_instance.visible = true;
     show_debug_message("Created player instance: " + string(global.player_instance) + " skin: " + global.current_skin + " at ("+string(start_x)+","+string(start_y)+")");
     // [...] Apply skin-specific state
} else {
     show_debug_message("CONTROLLER ROOM START FATAL ERROR: Failed to create player instance for skin: " + global.current_skin);
     global.player_instance = noone; // Ensure it's noone if creation failed
     exit;
}


// --- 5. Load Room State ---
show_debug_message("CONTROLLER ROOM START: Calling load_room_state for: " + _current_room_name + " (Is Fresh Load: " + string(_is_fresh_load) + ")");
load_room_state(room, _is_fresh_load);

// --- 6. Final Setup ---
if (_is_fresh_load) { /* ... Reset loading flag ... */
     show_debug_message("CONTROLLER ROOM START: Resetting global.is_loading_game flag.");
     global.is_loading_game = false;
}

// --- 7. CAMERA AND VIEW SETUP ---
 // [...] (Camera setup code remains the same)
 view_set_camera(0, global.camera); view_enabled = true; view_visible[0] = true;
 var intended_view_width = 288; var intended_view_height = 216; var view_width = min(intended_view_width, room_width); var view_height = min(intended_view_height, room_height); camera_set_view_size(global.camera, view_width, view_height); camera_set_view_border(global.camera, 0, 0); show_debug_message("Set camera view size to " + string(view_width) + "x" + string(view_height) + ", border (0,0)");
  if (room_width <= view_width && room_height <= view_height) { /* Fix camera */ camera_set_view_target(global.camera, noone); camera_set_view_speed(global.camera, -1, -1); camera_set_view_pos(global.camera, 0, 0); show_debug_message("Camera fixed at (0, 0)."); }
  else { /* Follow player */ if (instance_exists(global.player_instance)) { camera_set_view_target(global.camera, global.player_instance); camera_set_view_speed(global.camera, -1, -1); var cam_x = global.player_instance.x - (view_width / 2); var cam_y = global.player_instance.y - (view_height / 2); cam_x = clamp(cam_x, 0, max(0, room_width - view_width)); cam_y = clamp(cam_y, 0, max(0, room_height - view_height)); camera_set_view_pos(global.camera, cam_x, cam_y); show_debug_message("Camera follow player " + string(global.player_instance) + " INSTANT."); } else { /* Fallback fix camera */ camera_set_view_target(global.camera, noone); camera_set_view_speed(global.camera, -1, -1); camera_set_view_pos(global.camera, 0, 0); show_debug_message("WARNING: Player missing, Camera fixed."); } }

// --- 8. Ensure UI Layer and Manager ---
// [...] (UI layer/manager check remains the same)
if (!layer_exists("UI")) { layer_create(-10000, "UI"); }
if (!instance_exists(obj_ui_manager)) { instance_create_layer(0, 0, "UI", obj_ui_manager); }

show_debug_message("CONTROLLER ROOM START: Finished setup for room: " + _current_room_name);