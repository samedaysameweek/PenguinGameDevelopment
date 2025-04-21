/// @function load_room_state(room_id, is_fresh_load)
/// @description Loads room state (Backward compatibility function)
/// @param {Real} room_id Room ID to load state for
/// @param {Bool} is_fresh_load Whether this is a fresh game load
function load_room_state(room_id, is_fresh_load) {
    var room_name = room_get_name(room_id);
    show_debug_message("[LEGACY] load_room_state: Calling for room " + room_name);
    
    // Call our new function if it exists
    if (script_exists(asset_get_index("RoomStateManager_LoadState"))) {
        show_debug_message("[LEGACY] load_room_state: Using RoomStateManager_LoadState");
        RoomStateManager_LoadState(room_name, is_fresh_load);
    } 
    // Otherwise, use the existing room_states logic
    else {
        show_debug_message("[LEGACY] load_room_state: Using fallback implementation");
        
        // Ensure room_states exists
        if (!variable_global_exists("room_states")) {
            global.room_states = ds_map_create();
            show_debug_message("[LEGACY] load_room_state: Created missing global.room_states map");
        }
        
        // Check if saved state exists for this room
        if (ds_exists(global.room_states, ds_type_map) && ds_map_exists(global.room_states, room_name)) {
            var state_array = global.room_states[? room_name];
            
            // Only recreate instances during fresh load
            if (is_fresh_load && is_array(state_array)) {
                show_debug_message("[LEGACY] load_room_state: Loading " + string(array_length(state_array)) + 
                                 " instances for room " + room_name);
                
                for (var i = 0; i < array_length(state_array); i++) {
                    var state = state_array[i];
                    if (!is_struct(state)) continue;
                    
                    // Skip if object name or required properties missing
                    if (!variable_struct_exists(state, "object_index_name")) continue;
                    
                    var obj_index = asset_get_index(state.object_index_name);
                    if (obj_index == -1 || !object_exists(obj_index)) continue;
                    
                    // Skip player, controller, or UI manager
                    if (object_is_ancestor(obj_index, obj_player_base) || 
                        obj_index == obj_controller || 
                        obj_index == obj_ui_manager) {
                        continue;
                    }
                    
                    // Skip follower puffles
                    var is_follower = (obj_index == obj_puffle && 
                                      variable_struct_exists(state, "following_player") && 
                                      state.following_player);
                    if (is_follower) continue;
                    
                    // Create instance and apply properties
                    var inst = instance_create_layer(state.x, state.y, "Instances", obj_index);
                    
                    if (instance_exists(inst)) {
                        inst.is_savable = true;
                        
                        // Apply standard properties if they exist
                        if (variable_struct_exists(state, "image_xscale")) 
                            inst.image_xscale = state.image_xscale;
                        else 
                            inst.image_xscale = 1;
                            
                        if (variable_struct_exists(state, "image_yscale")) 
                            inst.image_yscale = state.image_yscale;
                        else 
                            inst.image_yscale = 1;
                            
                        if (variable_struct_exists(state, "image_blend")) 
                            inst.image_blend = state.image_blend;
                        else
                            inst.image_blend = c_white;
                            
                        if (variable_struct_exists(state, "image_alpha")) 
                            inst.image_alpha = state.image_alpha;
                        else
                            inst.image_alpha = 1;
                            
                        // Apply object-specific properties
                        if (variable_struct_exists(state, "face") && variable_instance_exists(inst, "face"))
                            inst.face = state.face;
                        
                        if (obj_index == obj_icetruck || obj_index == obj_icetruck_broken) {
                            if (variable_struct_exists(state, "icetruck_tint") && 
                                variable_instance_exists(inst, "icetruck_tint"))
                                inst.icetruck_tint = state.icetruck_tint;
                                
                            if (variable_struct_exists(state, "is_driveable") && 
                                variable_instance_exists(inst, "is_driveable"))
                                inst.is_driveable = state.is_driveable;
                        }
                        else if (object_get_parent(inst.object_index) == obj_pickup_item || 
                                inst.object_index == obj_dropped_item) {
                            if (variable_struct_exists(state, "item_name") && 
                                variable_instance_exists(inst, "item_name"))
                                inst.item_name = state.item_name;
                        }
                        else if (obj_index == obj_puffle) {
                            if (variable_struct_exists(state, "puffle_color") && 
                                variable_instance_exists(inst, "color"))
                                inst.color = state.puffle_color;
                                
                            if (variable_struct_exists(state, "puffle_state") && 
                                variable_instance_exists(inst, "state"))
                                inst.state = state.puffle_state;
                        }
                        
                        show_debug_message("[LEGACY] load_room_state: Created " + state.object_index_name + 
                                        " at (" + string(state.x) + "," + string(state.y) + ")");
                    }
                }
                
                show_debug_message("[LEGACY] load_room_state: Finished loading instances for " + room_name);
            } else {
                show_debug_message("[LEGACY] load_room_state: Not recreating instances (normal room entry)");
            }
        } else {
            show_debug_message("[LEGACY] load_room_state: No saved state found for " + room_name);
        }
    }
} 