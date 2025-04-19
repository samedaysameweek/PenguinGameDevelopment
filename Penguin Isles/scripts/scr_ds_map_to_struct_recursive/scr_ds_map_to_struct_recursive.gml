/// @function ds_map_to_struct_recursive(map_id)
/// @description Recursively converts a DS Map (including nested maps/lists) into a struct.
/// @param {Id.DsMap} map_id The ID of the DS Map to convert.
/// @returns {Struct} A struct representation of the map, or undefined if input is invalid.
function ds_map_to_struct_recursive(map_id) {
    if (!ds_exists(map_id, ds_type_map)) {
        // It's possible this function might be (incorrectly) called with a struct already
        if (is_struct(map_id)) {
            show_debug_message("WARNING: ds_map_to_struct_recursive called with a STRUCT - cloning instead: " + string(map_id));
            return struct_clone_recursive(map_id); // Clone if it's already a struct
        }
        show_debug_message("WARNING: ds_map_to_struct_recursive called with invalid map ID or non-struct: " + string(map_id));
        return undefined;
    }

    var _struct = {};
    var _key = ds_map_find_first(map_id);

    while (!is_undefined(_key)) {
        var _value = ds_map_find_value(map_id, _key);

        // --- REVISED LOGIC ---
        if (is_real(_value)) { // Check if it *could* be a DS ID
            if (ds_exists(_value, ds_type_map)) {
                 // Value IS a nested DS Map ID -> Convert recursively
                 _struct[$ _key] = ds_map_to_struct_recursive(_value);
            } else if (ds_exists(_value, ds_type_list)) {
                 // Value IS a nested DS List ID -> Convert recursively to ARRAY
                 _struct[$ _key] = ds_list_to_array_recursive(_value); // Correct helper
            } else {
                 // Value is a real number, but not a known DS ID -> Copy directly
                 _struct[$ _key] = _value;
            }
        }
        // *** Check for actual GML array BEFORE checking for struct ***
        else if (is_array(_value)) {
             // Value is an ARRAY -> Recursively check its contents for DS types using array_to_array_recursive
             // We assume the goal is to have a final structure of nested structs and arrays,
             // so we recursively ensure any DS types within the array are converted.
              _struct[$ _key] = array_to_array_recursive(_value); // <<<< Ensure THIS helper function exists and is correct
        }
        else if (is_struct(_value)) {
            // Value is already a struct -> Deep clone it recursively
             _struct[$ _key] = struct_clone_recursive(_value);
        }
        else {
            // Value is a primitive (string, bool, undefined, etc.) -> Copy directly
             if(is_undefined(_value)) { show_debug_message("DEBUG (ds_map->struct): Skipping undefined for key: " + _key); }
             else { _struct[$ _key] = _value; }
        }
        // --- END REVISED LOGIC ---

        _key = ds_map_find_next(map_id, _key);
    }
    return _struct;
}