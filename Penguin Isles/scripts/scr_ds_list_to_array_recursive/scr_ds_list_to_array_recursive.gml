/// @function ds_list_to_array_recursive(list_id)
/// @description Recursively converts a DS List (including nested maps/lists) into an array.
/// @param {Id.DsList} list_id The ID of the DS List to convert.
/// @returns {Array} An array representation of the list, or undefined if input is invalid.
function ds_list_to_array_recursive(list_id) {
    if (!ds_exists(list_id, ds_type_list)) {
         // It's possible this function might be (incorrectly) called with an array already
        if (is_array(list_id)) {
            show_debug_message("WARNING: ds_list_to_array_recursive called with an ARRAY - checking contents instead: " + string(list_id));
            return array_to_array_recursive(list_id); // Process if it's already an array
        }
        show_debug_message("WARNING: ds_list_to_array_recursive called with invalid list ID or non-array: " + string(list_id));
        return undefined;
    }

    var _array = [];
    var _list_size = ds_list_size(list_id);

    for (var i = 0; i < _list_size; i++) {
        var _value = ds_list_find_value(list_id, i);

        // --- REVISED LOGIC ---
        if (is_real(_value)) { // Check if it might be a DS ID
            if (ds_exists(_value, ds_type_map)) {
                 // Value IS a nested DS Map ID -> Convert recursively to STRUCT
                 array_push(_array, ds_map_to_struct_recursive(_value));
            } else if (ds_exists(_value, ds_type_list)) {
                 // Value IS a nested DS List ID -> Convert recursively to ARRAY
                 array_push(_array, ds_list_to_array_recursive(_value));
            } else {
                 // Value is a real number, but not a known DS ID -> Copy directly
                 array_push(_array, _value);
            }
        }
        // *** Check for actual GML struct BEFORE checking for array ***
        else if (is_struct(_value)) {
            // Value is already a struct -> Deep clone it recursively
            array_push(_array, struct_clone_recursive(_value)); // <<< Correct handling
        }
        else if (is_array(_value)) {
             // Value is an array -> Check its contents recursively
             array_push(_array, array_to_array_recursive(_value)); // <<< Ensure THIS helper exists and is correct
        }
        else {
            // Value is a primitive (string, bool, undefined) -> Copy directly
            if(is_undefined(_value)) { show_debug_message("DEBUG (ds_list->array): Skipping undefined at index: " + string(i)); }
            else { array_push(_array, _value); }
        }
         // --- END REVISED LOGIC ---

    }
    return _array;
}