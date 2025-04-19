// obj_controller -> Other Event: Room End (Other_5.gml)

var _leaving_room_name = room_get_name(room);
show_debug_message("obj_controller Room End: Transitioning from room: " + _leaving_room_name);

if (ds_exists(global.room_states, ds_type_map)) {
    if (ds_map_exists(global.room_states, _leaving_room_name)) {
        var _old_data = ds_map_find_value(global.room_states, _leaving_room_name);

        if (is_array(_old_data)) {
            // Arrays do not need explicit destruction
            show_debug_message("Replacing existing room state array for: " + _leaving_room_name);
        } else {
            // Remove old data if not an array
            ds_map_replace(global.room_states, _leaving_room_name, []);
        }
    } else {
        ds_map_add(global.room_states, _leaving_room_name, []);
    }
}

// --- NEW: Save state of the room being left ---
if (!global.is_loading_game) { // Don't save state when we are in the middle of loading
    show_debug_message("Saving runtime state for leaving room: " + _leaving_room_name);

    var _state_array = []; // Temporary array for this room's state

    with (all) { // Collect state from savable instances in the leaving room
        var _inst_id = id;
         // Same skip conditions as save_game
        if (_inst_id == global.player_instance || object_index == obj_controller || object_index == obj_ui_manager ||
            (object_index == obj_puffle && ds_list_find_index(global.following_puffles, _inst_id) != -1)) {
            continue;
        }
        var _is_savable = (variable_instance_exists(_inst_id, "is_savable") && is_savable);
        if (_is_savable) {
           var _state_data = {
                 object_index_name: object_get_name(object_index),
                 x: x, y: y,
                 image_xscale: image_xscale ?? 1, image_yscale: image_yscale ?? 1,
                 image_blend: image_blend ?? c_white, image_alpha: image_alpha ?? 1,
                 face: variable_instance_exists(_inst_id, "face") ? face : undefined,
                 icetruck_tint: variable_instance_exists(_inst_id, "icetruck_tint") ? icetruck_tint : undefined,
                 is_driveable: variable_instance_exists(_inst_id, "is_driveable") ? is_driveable : undefined,
                 item_name: variable_instance_exists(_inst_id, "item_name") ? item_name : undefined,
                 following_player: false,
                 puffle_color: variable_instance_exists(_inst_id, "color") ? color : undefined,
                 puffle_state: variable_instance_exists(_inst_id, "state") ? state : undefined,
            };
            array_push(_state_array, _state_data);
       }
    }
}