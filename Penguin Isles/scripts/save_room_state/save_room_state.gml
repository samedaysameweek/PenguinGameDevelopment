/// @function save_room_state(room_id)
/// @description Saves room state (Backward compatibility function)
/// @param {Real} room_id Room ID to save state for
function save_room_state(room_id) {
    var room_name = room_get_name(room_id);
    show_debug_message("[LEGACY] save_room_state: Calling RoomStateManager_SaveState for " + room_name);
    
    // Call our new function if it exists
    if (script_exists(asset_get_index("RoomStateManager_SaveState"))) {
        RoomStateManager_SaveState(room_id);
    } 
    // Otherwise, use the existing room_states logic
    else {
        show_debug_message("[LEGACY] save_room_state: Using fallback implementation");
        
        // Ensure global room_states map exists
        if (!variable_global_exists("room_states") || !ds_exists(global.room_states, ds_type_map)) {
            global.room_states = ds_map_create();
        }
        
        var state_array = [];
        
        with (all) {
            // Skip controller and UI objects
            if (object_index == obj_controller || object_index == obj_ui_manager) continue;
            
            // Determine if instance is savable
            var is_savable = false;
            var parent_index = object_get_parent(object_index);
            
            if (parent_index == obj_pickup_item) {
                is_savable = true;
            } else if (
                object_index == obj_pickup_item || 
                object_index == obj_toboggan || 
                object_index == obj_tube ||
                object_index == obj_icetruck || 
                object_index == obj_icetruck_broken || 
                object_index == obj_puffle
            ) {
                is_savable = true;
            }
            
            // Exclude following puffles
            if (is_savable && object_index == obj_puffle) {
                if (variable_global_exists("following_puffles") && 
                    ds_exists(global.following_puffles, ds_type_list) && 
                    ds_list_find_index(global.following_puffles, id) != -1) {
                    is_savable = false;
                }
            }
            
            // Save state data
            if (is_savable) {
                try {
                    var state_data = {
                        object_index_name: object_get_name(object_index),
                        x: x, y: y,
                        image_xscale: image_xscale ?? 1,
                        image_yscale: image_yscale ?? 1,
                        image_blend: image_blend ?? c_white,
                        image_alpha: image_alpha ?? 1
                    };
                    
                    // Add common object properties
                    if (variable_instance_exists(id, "face")) {
                        state_data.face = face;
                    }
                    
                    // Add object-specific properties
                    if (object_index == obj_icetruck || object_index == obj_icetruck_broken) {
                        if (variable_instance_exists(id, "icetruck_tint")) {
                            state_data.icetruck_tint = icetruck_tint;
                        }
                        if (variable_instance_exists(id, "is_driveable")) {
                            state_data.is_driveable = is_driveable;
                        }
                    }
                    else if (object_get_parent(object_index) == obj_pickup_item || 
                            object_index == obj_dropped_item) {
                        if (variable_instance_exists(id, "item_name")) {
                            state_data.item_name = item_name;
                        }
                    }
                    else if (object_index == obj_puffle) {
                        if (variable_instance_exists(id, "following_player")) {
                            state_data.following_player = following_player;
                        }
                        if (variable_instance_exists(id, "color")) {
                            state_data.puffle_color = color;
                        }
                        if (variable_instance_exists(id, "state")) {
                            state_data.puffle_state = state;
                        }
                    }
                    
                    array_push(state_array, state_data);
                }
                catch (err) {
                    show_debug_message("[ERROR] Error saving state for object: " + 
                                   object_get_name(object_index) + " - " + string(err));
                }
            }
        }
        
        // Update room states
        if (ds_map_exists(global.room_states, room_name)) {
            ds_map_replace(global.room_states, room_name, state_array);
        } else {
            ds_map_add(global.room_states, room_name, state_array);
        }
        
        show_debug_message("[LEGACY] save_room_state: Saved " + string(array_length(state_array)) + 
                         " objects for room " + room_name);
    }
} 