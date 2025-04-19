/// @function struct_to_ds_map_recursive(struct_data)
/// @description Recursively converts a Struct (including nested structs/arrays) into a DS Map.
/// @param {Struct} struct_data The Struct to convert.
/// @returns {Id.DsMap} A DS Map representation of the struct, or undefined if input is invalid.
function struct_to_ds_map_recursive(struct_data) {
    if (!is_struct(struct_data)) {
        show_debug_message("WARNING: struct_to_ds_map_recursive called with non-struct data: " + string(struct_data));
        return undefined;
    }

    var _map = ds_map_create();
    var _keys = variable_struct_get_names(struct_data);

    for (var i = 0; i < array_length(_keys); i++) {
        var _key = _keys[i];
        var _value = struct_data[$ _key];

        if (is_struct(_value)) {
            // Recursively convert nested struct
            ds_map_add(_map, _key, struct_to_ds_map_recursive(_value));
        } else if (is_array(_value)) {
            // Convert nested array
            ds_map_add(_map, _key, array_to_ds_list_recursive(_value)); // Call list conversion helper
        } else {
            // Copy primitive value or simple struct/array (no deep copy needed for primitives)
             // Handle potential 'undefined' from JSON parsing if a key existed with null value
             if (is_undefined(_value)) {
                  // Decide how to handle undefined - often skip, add as -1, or add as "undefined" string
                  // Skipping is often safest if the receiving code expects optional values.
                   show_debug_message("DEBUG (struct_to_ds_map): Skipping undefined value for key: " + _key);
             } else {
                 ds_map_add(_map, _key, _value);
             }
        }
    }
    return _map;
}