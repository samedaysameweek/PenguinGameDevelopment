/// @function load_room_state(room_id, is_fresh_load)
/// @description Loads and restores the state of objects in a given room.
/// @param {Asset.GMRoom} room_id The ID of the room to load state for.
/// @param {Bool} is_fresh_load True if loading from save file, false if just entering room.
function load_room_state(room_id, is_fresh_load) {
    var room_name = room_get_name(room_id);
    show_debug_message("Attempting to load state for room: " + room_name + " (Fresh Load: " + string(is_fresh_load) + ")");

    // Ensure global map exists
    if (!ds_exists(global.room_states, ds_type_map)) {
         show_debug_message("Load State ERROR: global.room_states DS Map does not exist!");
         return; // Cannot load state
    }

    // --- Destroy existing savable instances ONLY IF LOADING FROM SAVE ---
    if (is_fresh_load) {
        show_debug_message("Destroying existing savable instances (Fresh Load)...");
        with (all) {
            if (variable_instance_exists(id, "is_savable") && is_savable &&
                 id != global.player_instance && object_index != obj_controller && object_index != obj_ui_manager)
             { instance_destroy(); /* Log if needed */ }
        }
        show_debug_message("Finished destroying old instances (Fresh Load).");
    } else {
         show_debug_message("Skipping instance destruction (Normal Room Entry).");
    }
    // --- End Conditional Destruction ---
    
    // Check if saved state exists for this room
    if (ds_map_exists(global.room_states, room_name)) {
        var state_array = ds_map_find_value(global.room_states, room_name);

        // Check if valid state array exists
        if (is_array(state_array)) {
            show_debug_message("Found state array for " + room_name + ". Size: " + string(array_length(state_array)));

             // --- Create instances from saved state ARRAY ---
             if (is_fresh_load) {
                  show_debug_message("Recreating instances from saved state array (Fresh Load)...");
                  for (var i = 0; i < array_length(state_array); i++) {
                         var state = state_array[i];
                         if (!is_struct(state)) { continue; }
                         if (!variable_struct_exists(state, "object_index_name")) { continue; }
                         var _obj_index_to_load = asset_get_index(state.object_index_name);
                         if (_obj_index_to_load == -1 || !object_exists(_obj_index_to_load)) { continue; }
                         if (object_is_ancestor(_obj_index_to_load, obj_player_base) || _obj_index_to_load == obj_controller || _obj_index_to_load == obj_ui_manager) {
                             show_debug_message("Load State: Skipping creation of reserved object (" + object_get_name(_obj_index_to_load) + ") found in save data.");
                             continue;
                         }

                 // Skip creating follower puffles from save state (they are persistent)
                var is_follower = (_obj_index_to_load == obj_puffle && variable_struct_exists(state, "following_player") && state.following_player);
                if (is_follower) { continue; }

                 // Create instance (Non-followers or other objects)
                        var inst = instance_create_layer(state.x, state.y, "Instances", _obj_index_to_load);
                        show_debug_message("Created instance from saved state: " + object_get_name(_obj_index_to_load));
                        if (instance_exists(inst)) { try {
                        inst.is_savable = true; // Mark loaded instance as savable

                        // Apply common properties if they exist in the struct AND the instance
                        if (variable_struct_exists(state, "face") && variable_instance_exists(inst, "face")) { inst.face = state.face; } else if(variable_instance_exists(inst, "face")) {inst.face = DOWN;} // default face if missing
                        if (variable_struct_exists(state, "image_xscale") && variable_instance_exists(inst, "image_xscale")) inst.image_xscale = state.image_xscale; else inst.image_xscale = 1;
                        if (variable_struct_exists(state, "image_yscale") && variable_instance_exists(inst, "image_yscale")) inst.image_yscale = state.image_yscale; else inst.image_yscale = 1;
                        if (variable_struct_exists(state, "image_blend") && variable_instance_exists(inst, "image_blend")) inst.image_blend = state.image_blend; else inst.image_blend = c_white;
                        if (variable_struct_exists(state, "image_alpha") && variable_instance_exists(inst, "image_alpha")) inst.image_alpha = state.image_alpha; else inst.image_alpha = 1;


                        // Object-specific properties
                        if (_obj_index_to_load == obj_icetruck || _obj_index_to_load == obj_icetruck_broken) {
                            if(variable_struct_exists(state, "icetruck_tint") && variable_instance_exists(inst,"icetruck_tint")) inst.icetruck_tint = state.icetruck_tint;
                            if(variable_struct_exists(state, "is_driveable") && variable_instance_exists(inst,"is_driveable")) inst.is_driveable = state.is_driveable;
                             // Ensure broken truck state aligns correctly
                            if (_obj_index_to_load == obj_icetruck_broken && variable_instance_exists(inst, "repair_required")) inst.repair_required = true;
                            if (_obj_index_to_load == obj_icetruck && variable_instance_exists(inst, "repair_required")) inst.repair_required = false;

                        } else if (object_get_parent(inst.object_index) == obj_pickup_item || inst.object_index == obj_dropped_item) { // General check for pickup items
                             if(variable_struct_exists(state, "item_name") && variable_instance_exists(inst,"item_name")) inst.item_name = state.item_name;
                        } else if (_obj_index_to_load == obj_puffle) { // Non-following puffles
                             if (variable_instance_exists(inst,"following_player")) inst.following_player = false;
                             if (variable_struct_exists(state, "puffle_color") && variable_instance_exists(inst,"color")) inst.color = state.puffle_color; // Apply color NAME
                             if (variable_struct_exists(state, "puffle_state") && variable_instance_exists(inst,"state")) inst.state = state.puffle_state;

                             // Apply blend from saved color name
                             if (variable_instance_exists(inst,"color")) {
                                switch (inst.color) {
                                    // Add color cases here to match names to colors
                                    case "red": inst.image_blend = make_color_rgb(255, 0, 0); break;
                                    // ... other colors ...
                                    default: inst.image_blend = c_white; break;
                                }
                             }
                        } else if (object_is_ancestor(_obj_index_to_load, obj_toboggan) || object_is_ancestor(_obj_index_to_load, obj_tube)) { // For Toboggan/Tube ITEMS
                             if(variable_struct_exists(state, "item_name") && variable_instance_exists(inst,"item_name")) inst.item_name = state.item_name;
                             if(variable_struct_exists(state, "face") && variable_instance_exists(inst,"face")) inst.face = state.face; // Restore item facing
                        }
                        // ... Add checks for other specific objects if needed ...

                         show_debug_message("Loaded " + state.object_index_name + " at (" + string(state.x) + ", " + string(state.y) + ")");

                     } catch (_err) {} }
                  }
                  show_debug_message("Finished creating instances for " + room_name + " (Fresh Load).");
            } else {
                 // If not a fresh load, we don't recreate everything from the save state,
                 // we just keep the instances that already exist in the room.
                                    show_debug_message("Normal Room Entry: Assuming instances persist or were recreated by GM.");
            }
} else {
             show_debug_message("Load State WARNING: Saved state for " + room_name + " is invalid (not an array).");
        }
    } else {
        show_debug_message("No state found for room: " + room_name + " in global.room_states.");
         // If fresh load, room is default empty. If normal entry, existing instances remain.
    }
}