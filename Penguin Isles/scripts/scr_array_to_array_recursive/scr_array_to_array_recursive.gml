/// @function array_to_array_recursive(source_array)
/// @description Recursively checks an array for nested DS maps/lists and converts them.
///              Clones nested structs and arrays found within.
/// @param {Array} source_array The source array to process.
/// @returns {Array} A new array with DS structures converted, or a deep clone if none found.
function array_to_array_recursive(source_array) {
	if (!is_array(source_array)) return source_array; // Return non-arrays as is

	var _new_array = [];
	var _len = array_length(source_array);

	for (var i = 0; i < _len; i++) {
		var _value = source_array[i];

        // --- REVISED LOGIC for array_to_array_recursive ---
        if (is_struct(_value)) {
            // Found a struct -> Deep Clone it
            array_push(_new_array, struct_clone_recursive(_value)); // << Clone structs
        }
		else if (is_array(_value)) {
			// Found a nested array -> Recursively process it
			array_push(_new_array, array_to_array_recursive(_value));
		}
        else if (is_real(_value)) { // Check if it *could* be a DS ID
             // Only convert if it's CONFIRMED to be a DS map/list ID
            if (ds_exists(_value, ds_type_map)) {
                 array_push(_new_array, ds_map_to_struct_recursive(_value)); // Convert map ID -> struct
            } else if (ds_exists(_value, ds_type_list)) {
                 array_push(_new_array, ds_list_to_array_recursive(_value)); // Convert list ID -> array
            } else {
                 // Just a number -> Copy it
                 array_push(_new_array, _value);
            }
        }
		else {
             // Primitive (string, bool, etc.) -> Copy it directly
			 if(is_undefined(_value)) { show_debug_message("DEBUG (array->array): Skipping undefined value at index: " + string(i)); }
             else { array_push(_new_array, _value); }
		}
        // --- END REVISED LOGIC ---
	}
	return _new_array;
}