/// @function array_to_ds_list_recursive(array_data)
/// @description Recursively converts an Array (including nested structs/arrays) into a DS List.
/// @param {Array} array_data The Array to convert.
/// @returns {Id.DsList} A DS List representation of the array, or undefined if input is invalid.
function array_to_ds_list_recursive(array_data) {
    if (!is_array(array_data)) {
        show_debug_message("WARNING: array_to_ds_list_recursive called with non-array data: " + string(array_data));
        return undefined;
    }

    var _list = ds_list_create();
    var _len = array_length(array_data);

    for (var i = 0; i < _len; i++) {
        var _value = array_data[i];

        if (is_struct(_value)) {
            // Convert nested struct
            ds_list_add(_list, struct_to_ds_map_recursive(_value));
        } else if (is_array(_value)) {
            // Recursively convert nested array
            ds_list_add(_list, array_to_ds_list_recursive(_value));
        } else {
            // Copy primitive value or simple struct/array
             // Handle potential 'undefined' from JSON parsing
             if (is_undefined(_value)) {
                 show_debug_message("DEBUG (array_to_ds_list): Skipping undefined value at index: " + string(i));
             } else {
                ds_list_add(_list, _value);
             }
        }
    }
    return _list;
}