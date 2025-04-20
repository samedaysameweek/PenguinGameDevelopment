// obj_controller -> Other Event: Room End (Other_5.gml) - REVISED v8 (Correct Array Push Scope)

var _leaving_room_name = room_get_name(room);
show_debug_message("obj_controller Room End: Transitioning from room: " + _leaving_room_name);

// --- Ensure global room_states map exists ---
if (!ds_exists(global.room_states, ds_type_map)) {
    show_debug_message("Room End WARN: global.room_states map missing! Creating it.");
    global.room_states = ds_map_create();
}

// --- Room State Saving Logic ---
var is_non_gameplay_room = (room == rm_init || room == rm_main_menu || room == rm_map ||
                            room == rm_pause_menu || room == rm_settings_menu || room == rm_saveload ||
                            room == rm_colorpicker_menu);
var _is_currently_loading = variable_global_exists("is_loading_game") && global.is_loading_game;

if (!_is_currently_loading && !is_non_gameplay_room) {
    show_debug_message("Saving runtime state for leaving room: " + _leaving_room_name);
    var _state_array = []; // <<< Declare the array in the main event scope

    show_debug_message("Room End WITH DEBUG: --- Start Instance Check ---");

    // --- Iterate using with(all) ---
    with (all) {
        // `self` now refers to the instance being iterated over
        var _inst_id = self.id;
        var _obj_index = object_index;
        var _dbg_obj_name = object_get_name(_obj_index);

        // --- Skip non-savable instances ---
        if (_inst_id == other.id) continue; // Skip controller
        if (variable_global_exists("player_instance") && instance_exists(global.player_instance) && _inst_id == global.player_instance) continue;
        if (variable_global_exists("ui_manager") && instance_exists(global.ui_manager) && _inst_id == global.ui_manager) continue;

        // --- SAVABLE CHECK ---
        var _is_instance_savable = false;
        var _parent_index = object_get_parent(_obj_index);
        if (_parent_index == obj_pickup_item) { // Check parent first
            _is_instance_savable = true;
        } else if ( // Check specific types if parent doesn't match
            _obj_index == obj_pickup_item || _obj_index == obj_toboggan || _obj_index == obj_tube ||
            _obj_index == obj_icetruck || _obj_index == obj_icetruck_broken || _obj_index == obj_puffle)
        {
             _is_instance_savable = true;
        }

        // Further exclusion (Puffles)
        if (_is_instance_savable && _obj_index == obj_puffle) {
            if (variable_global_exists("following_puffles") && ds_exists(global.following_puffles, ds_type_list) && ds_list_find_index(global.following_puffles, _inst_id) != -1) {
                _is_instance_savable = false;
            }
        }

        // --- If deemed savable, process it ---
        if (_is_instance_savable) {
            show_debug_message("Room End WITH DEBUG: >>> Preparing to save state for: " + string(_inst_id) + " (" + _dbg_obj_name + ")"); // Log BEFORE push
            try {
                 var _state_data = {
                     object_index_name: _dbg_obj_name,
                     x: x, y: y,
                     image_xscale: image_xscale ?? 1,
                     image_yscale: image_yscale ?? 1,
                     image_blend: image_blend ?? c_white,
                     image_alpha: image_alpha ?? 1,
                     face: variable_instance_exists(id, "face") ? face : undefined,
                     icetruck_tint: variable_instance_exists(id, "icetruck_tint") ? icetruck_tint : undefined,
                     is_driveable: variable_instance_exists(id, "is_driveable") ? is_driveable : undefined,
                     item_name: variable_instance_exists(id, "item_name") ? item_name : undefined,
                     following_player: variable_instance_exists(id, "following_player") ? following_player : undefined,
                     puffle_color: (_obj_index == obj_puffle && variable_instance_exists(id, "color")) ? color : undefined,
                     puffle_state: (_obj_index == obj_puffle && variable_instance_exists(id, "state")) ? state : undefined,
                 };
                 // *** THE FIX: Push directly to _state_array (NO `other`) ***
                 array_push(_state_array, _state_data);
                 show_debug_message("Room End WITH DEBUG: +++ Successfully pushed state for " + string(_inst_id)); // Log AFTER successful push
            } catch (_ex) {
                show_debug_message("Room End Save State ERROR: Failed during struct creation/push for " + string(_inst_id) + " (" + _dbg_obj_name + ") - " + string(_ex));
            }
        } else {
             // Log skipped instance (optional)
             // if (_obj_index != obj_controller && ...) { show_debug_message(...) }
        }
    } // --- End with(all) ---

    show_debug_message("Room End WITH DEBUG: --- End Instance Check ---");
    show_debug_message("Room End DEBUG: Finished checking instances. Collected " + string(array_length(_state_array)) + " savable states."); // Use the length of the array

    // --- Store the collected state array ---
    if (ds_map_exists(global.room_states, _leaving_room_name)) {
        show_debug_message("Replacing existing room state array for: " + _leaving_room_name + " with new array size: " + string(array_length(_state_array)));
        ds_map_replace(global.room_states, _leaving_room_name, _state_array);
    } else {
        show_debug_message("Adding new room state array for: " + _leaving_room_name + " with size: " + string(array_length(_state_array)));
        ds_map_add(global.room_states, _leaving_room_name, _state_array);
    }
     show_debug_message("Finished saving runtime state for room: " + _leaving_room_name);

} else {
    // Log reason for skipping save
    if (_is_currently_loading) show_debug_message("Skipping room state save: Currently loading game.");
    if (is_non_gameplay_room) show_debug_message("Skipping room state save: Non-gameplay room (" + _leaving_room_name + ").");
    // Ensure empty array is stored if room was visited but had no savable objects
    if (!_is_currently_loading && !is_non_gameplay_room && !ds_map_exists(global.room_states, _leaving_room_name)) {
         show_debug_message("Adding empty room state array for: " + _leaving_room_name + " (No savable objects found).");
         ds_map_add(global.room_states, _leaving_room_name, []);
    }
}