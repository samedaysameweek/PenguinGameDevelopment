/// @function RoomStateManager_Initialize()
/// @description Initializes the room state management system
function RoomStateManager_Initialize() {
    // Make sure we use the existing room_states data structure
    if (!variable_global_exists("room_states") || !ds_exists(global.room_states, ds_type_map)) {
        global.room_states = ds_map_create();
    }
    
    show_debug_message("[INFO] RoomStateManager initialized");
}

/// @function RoomStateManager_SaveState(roomId)
/// @param {Real} roomId The room ID to save state for
function RoomStateManager_SaveState(_roomId) {
    var _roomName = room_get_name(_roomId);
    
    show_debug_message("[INFO] RoomStateManager: Saving state for room: " + _roomName);
    
    if (!ds_exists(global.room_states, ds_type_map)) {
        show_debug_message("[ERROR] RoomStateManager: global.room_states map does not exist");
        global.room_states = ds_map_create();
    }
    
    var _stateArray = [];
    
    with (all) {
        // Skip controller and UI objects
        if (object_index == obj_controller || object_index == obj_ui_manager) continue;
        
        if (variable_instance_exists(id, "is_savable") && is_savable) {
            var _stateData = {
                object_index_name: object_get_name(object_index),
                x: x,
                y: y,
                image_xscale: image_xscale ?? 1,
                image_yscale: image_yscale ?? 1,
                image_blend: image_blend ?? c_white,
                image_alpha: image_alpha ?? 1
            };
            
            // Store common variables if they exist
            if (variable_instance_exists(id, "face")) {
                _stateData.face = face;
            }
            
            // Store object-specific properties
            if (object_index == obj_icetruck || object_index == obj_icetruck_broken) {
                if (variable_instance_exists(id, "icetruck_tint")) {
                    _stateData.icetruck_tint = icetruck_tint;
                }
                
                if (variable_instance_exists(id, "is_driveable")) {
                    _stateData.is_driveable = is_driveable;
                }
            }
            else if (object_get_parent(object_index) == obj_pickup_item || 
                     object_index == obj_dropped_item) {
                if (variable_instance_exists(id, "item_name")) {
                    _stateData.item_name = item_name;
                }
            }
            else if (object_index == obj_puffle) {
                if (variable_instance_exists(id, "following_player")) {
                    _stateData.following_player = following_player;
                }
                
                if (variable_instance_exists(id, "color")) {
                    _stateData.puffle_color = color;
                }
                
                if (variable_instance_exists(id, "state")) {
                    _stateData.puffle_state = state;
                }
            }
            
            array_push(_stateArray, _stateData);
        }
    }
    
    // Add or replace the state
    if (ds_map_exists(global.room_states, _roomName)) {
        ds_map_replace(global.room_states, _roomName, _stateArray);
    } else {
        ds_map_add(global.room_states, _roomName, _stateArray);
    }
    
    show_debug_message("[INFO] RoomStateManager: Saved state for room: " + _roomName + 
                     " with " + string(array_length(_stateArray)) + " objects");
                     
    return true;
}

/// @function RoomStateManager_LoadState(roomName, isFreshLoad)
/// @param {String} roomName The name of the room to load state for
/// @param {Bool} isFreshLoad Whether this is a fresh game load
function RoomStateManager_LoadState(_roomName, _isFreshLoad) {
    show_debug_message("[INFO] RoomStateManager_LoadState called for: " + _roomName);
    
    if (!ds_exists(global.room_states, ds_type_map)) {
        show_debug_message("[ERROR] RoomStateManager: global.room_states map does not exist");
        return false;
    }
    
    if (!ds_map_exists(global.room_states, _roomName)) {
        show_debug_message("[INFO] RoomStateManager: No saved state found for room: " + _roomName);
        return false;
    }
    
    var _stateArray = global.room_states[? _roomName];
    if (!is_array(_stateArray)) {
        show_debug_message("[ERROR] RoomStateManager: Invalid room state format for: " + _roomName);
        return false;
    }
    
    show_debug_message("[INFO] RoomStateManager: Found state for room: " + _roomName + 
                      " with " + string(array_length(_stateArray)) + " objects");
    
    if (_isFreshLoad) {
        show_debug_message("[INFO] RoomStateManager: Fresh load - recreating instances");
        
        for (var i = 0; i < array_length(_stateArray); i++) {
            var _state = _stateArray[i];
            
            if (!is_struct(_state)) {
                show_debug_message("[WARNING] RoomStateManager: State entry " + string(i) + " is not a struct");
                continue;
            }
            
            if (!variable_struct_exists(_state, "object_index_name")) {
                show_debug_message("[WARNING] RoomStateManager: State entry " + string(i) + " missing object_index_name");
                continue;
            }
            
            var _objIndex = asset_get_index(_state.object_index_name);
            if (_objIndex == -1 || !object_exists(_objIndex)) {
                show_debug_message("[WARNING] RoomStateManager: Object does not exist: " + _state.object_index_name);
                continue;
            }
            
            // Skip certain objects
            if (object_is_ancestor(_objIndex, obj_player_base) || 
                _objIndex == obj_controller || 
                _objIndex == obj_ui_manager) {
                show_debug_message("[INFO] RoomStateManager: Skipping reserved object: " + _state.object_index_name);
                continue;
            }
            
            // Skip follower puffles
            var _isFollower = (_objIndex == obj_puffle && 
                              variable_struct_exists(_state, "following_player") && 
                              _state.following_player);
            if (_isFollower) {
                show_debug_message("[INFO] RoomStateManager: Skipping follower puffle");
                continue;
            }
            
            // Create instance
            var _inst = instance_create_layer(_state.x, _state.y, "Instances", _objIndex);
            
            if (instance_exists(_inst)) {
                _inst.is_savable = true;
                
                // Apply common properties
                if (variable_struct_exists(_state, "face") && variable_instance_exists(_inst, "face")) {
                    _inst.face = _state.face;
                } else if (variable_instance_exists(_inst, "face")) {
                    _inst.face = DOWN;
                }
                
                if (variable_struct_exists(_state, "image_xscale")) _inst.image_xscale = _state.image_xscale;
                else _inst.image_xscale = 1;
                
                if (variable_struct_exists(_state, "image_yscale")) _inst.image_yscale = _state.image_yscale;
                else _inst.image_yscale = 1;
                
                if (variable_struct_exists(_state, "image_blend")) _inst.image_blend = _state.image_blend;
                else _inst.image_blend = c_white;
                
                if (variable_struct_exists(_state, "image_alpha")) _inst.image_alpha = _state.image_alpha;
                else _inst.image_alpha = 1;
                
                // Apply object-specific properties
                if (_objIndex == obj_icetruck || _objIndex == obj_icetruck_broken) {
                    if (variable_struct_exists(_state, "icetruck_tint") && 
                        variable_instance_exists(_inst,"icetruck_tint")) {
                        _inst.icetruck_tint = _state.icetruck_tint;
                    }
                    
                    if (variable_struct_exists(_state, "is_driveable") && 
                        variable_instance_exists(_inst,"is_driveable")) {
                        _inst.is_driveable = _state.is_driveable;
                    }
                    
                    if (_objIndex == obj_icetruck_broken && 
                        variable_instance_exists(_inst, "repair_required")) {
                        _inst.repair_required = true;
                    }
                    
                    if (_objIndex == obj_icetruck && 
                        variable_instance_exists(_inst, "repair_required")) {
                        _inst.repair_required = false;
                    }
                }
                else if (object_get_parent(_inst.object_index) == obj_pickup_item || 
                         _inst.object_index == obj_dropped_item) {
                    if (variable_struct_exists(_state, "item_name") && 
                        variable_instance_exists(_inst,"item_name")) {
                        _inst.item_name = _state.item_name;
                    }
                }
                else if (_objIndex == obj_puffle) {
                    if (variable_instance_exists(_inst,"following_player")) {
                        _inst.following_player = false;
                    }
                    
                    if (variable_struct_exists(_state, "puffle_color") && 
                        variable_instance_exists(_inst,"color")) {
                        _inst.color = _state.puffle_color;
                    }
                    
                    if (variable_struct_exists(_state, "puffle_state") && 
                        variable_instance_exists(_inst,"state")) {
                        _inst.state = _state.puffle_state;
                    }
                }
                
                show_debug_message("[INFO] RoomStateManager: Created " + _state.object_index_name + 
                                 " at (" + string(_state.x) + "," + string(_state.y) + ")");
            }
        }
        
        show_debug_message("[INFO] RoomStateManager: Finished creating instances for " + _roomName);
    } else {
        show_debug_message("[INFO] RoomStateManager: Normal room entry - not creating instances");
    }
    
    return true;
} 