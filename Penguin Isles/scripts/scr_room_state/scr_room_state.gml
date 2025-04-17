function save_room_state(room_id) {
    var room_name = room_get_name(room_id);
    show_debug_message("Saving state for room: " + room_name);
    if (ds_map_exists(global.room_states, room_name)) {
        var old_list = ds_map_find_value(global.room_states, room_name);
        if (ds_exists(old_list, ds_type_list)) {
            ds_list_destroy(old_list);
        }
    }
    var state_list = ds_list_create();
    ds_map_replace(global.room_states, room_name, state_list);

    with (all) {
        if (variable_instance_exists(id, "is_savable") && is_savable && object_index != obj_player && object_index != obj_player_tube) {
            if (object_index == obj_puffle && variable_instance_get(id, "following_player") == true) {
                continue;
            }
            var state = {
                object_index: object_index,
                x: x,
                y: y,
                direction: variable_instance_exists(id, "face") ? variable_instance_get(id, "face") : 0
            };
            if (object_index == obj_icetruck || object_index == obj_icetruck_broken) {
                state.repair_required = variable_instance_exists(id, "repair_required") ? variable_instance_get(id, "repair_required") : false;
                state.is_driveable = variable_instance_exists(id, "is_driveable") ? variable_instance_get(id, "is_driveable") : false;
            } else if (object_index == obj_dropped_item) {
                var item_type = variable_instance_get(id, "item_type");
                state.item_type = (item_type != undefined) ? item_type : "";
            } else if (object_index == obj_puffle) {
                state.following_player = variable_instance_exists(id, "following_player") ? variable_instance_get(id, "following_player") : false;
                var color = variable_instance_get(id, "color");
                state.color = (color != undefined) ? color : "";
                var puffle_state = variable_instance_get(id, "state");
                state.state = (puffle_state != undefined) ? puffle_state : "";
            }
            ds_list_add(state_list, state);
        }
    }
    show_debug_message("Saved state for room: " + room_name + " with " + string(ds_list_size(state_list)) + " objects.");
}

function load_room_state(room_id) {
    var room_name = room_get_name(room_id);
    show_debug_message("Attempting to load state for room: " + room_name);

    // Check if saved state exists for this room
    if (ds_map_exists(global.room_states, room_name)) {
        var state_list = ds_map_find_value(global.room_states, room_name);

        if (ds_exists(state_list, ds_type_list)) {
            show_debug_message("Found state list for " + room_name + ". Size: " + string(ds_list_size(state_list)));

            // --- Destroy existing savable instances CAREFULLY ---
            show_debug_message("Destroying existing savable instances in " + room_name + "...");
            with (all) {
                // Check if instance is savable AND not the current player instance AND not a globally managed following puffle
                if (variable_instance_exists(id, "is_savable") && is_savable &&
                    id != global.player_instance && // Don't destroy the current player <<<--- THIS IS THE KEY CHECK
                    (object_index != obj_puffle || ds_list_find_index(global.following_puffles, id) == -1)) // Don't destroy globally tracked puffles
                {
                    show_debug_message("Destroying instance " + string(id) + " (" + object_get_name(object_index) + ")");
                    instance_destroy();
                }
            }
            show_debug_message("Finished destroying old instances.");

            // --- Create instances from saved state ---
            show_debug_message("Creating instances from saved state...");
            for (var i = 0; i < ds_list_size(state_list); i++) {
                var state = state_list[| i];
                var inst = noone; // Initialize inst

                // Validate object index before creating
                if (!object_exists(state.object_index)) {
                     show_debug_message("Load State WARNING: Saved object index " + string(state.object_index) + " does not exist! Skipping instance.");
                     continue; // Skip this state entry
                }

                // Special handling for puffles that should be following vs. room-specific ones
                if (state.object_index == obj_puffle) {
                    if (variable_struct_exists(state, "following_player") && state.following_player) {
                         // This state represents a puffle that *should* be following.
                         // Don't recreate it here; it should persist or be managed globally.
                         // Check if it's *already* in the global list - if not, maybe add it? (Complex case)
                         show_debug_message("Load State: Skipping creation of following puffle state - should be persistent.");
                         continue; // Skip creating this puffle from room state
                    } else {
                        // This is a puffle that was *not* following, create it normally
                        inst = instance_create_layer(state.x, state.y, "Instances", state.object_index);
                    }
                } else {
                     // Create non-puffle instances normally
                     inst = instance_create_layer(state.x, state.y, "Instances", state.object_index);
                }

                // Apply common state if instance was created
                if (instance_exists(inst)) {
                    if (variable_instance_exists(inst, "face")) {
                        inst.face = state.direction ?? DOWN; // Default to DOWN if direction missing
                    }

                    // Apply specific object states
                     if (state.object_index == obj_icetruck || state.object_index == obj_icetruck_broken) {
                         if (variable_instance_exists(inst,"repair_required")) inst.repair_required = state.repair_required ?? true; // Default to requiring repair if missing
                         if (variable_instance_exists(inst,"is_driveable")) inst.is_driveable = state.is_driveable ?? false; // Default to not driveable
                     } else if (state.object_index == obj_dropped_item) {
                         if (variable_instance_exists(inst,"item_type")) inst.item_type = state.item_type ?? "Unknown";
                     } else if (state.object_index == obj_puffle) { // This applies to non-following puffles created above
                         if (variable_instance_exists(inst,"following_player")) inst.following_player = false; // Ensure it's false
                         if (variable_instance_exists(inst,"color")) inst.color = state.color ?? "white";
                         if (variable_instance_exists(inst,"state")) inst.state = state.state ?? PuffleState.IDLE;
                         // Apply color blend based on state.color
                         switch (inst.color) {
                             case "red": inst.image_blend = make_color_rgb(255, 0, 0); break;
                             case "blue": inst.image_blend = make_color_rgb(0, 0, 255); break;
                             case "green": inst.image_blend = make_color_rgb(0, 255, 0); break;
                             case "yellow": inst.image_blend = make_color_rgb(255, 255, 0); break;
                             default: inst.image_blend = c_white;
                         }
                     }
                     show_debug_message("Loaded " + object_get_name(state.object_index) + " at (" + string(state.x) + ", " + string(state.y) + ")");
                } // end if instance_exists(inst)
            } // end for loop
            show_debug_message("Finished creating instances for " + room_name);
        } else {
            show_debug_message("Saved state list for " + room_name + " is invalid or empty.");
        }
    } else {
        show_debug_message("No saved state found for room: " + room_name);
        // Destroy existing savable items even if no save state is found, to ensure a clean room? (Optional)
        // with(all) { /* ... destroy logic ... */ }
    }
}