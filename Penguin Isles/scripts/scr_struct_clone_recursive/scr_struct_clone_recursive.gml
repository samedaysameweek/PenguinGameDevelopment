/// @function struct_clone_recursive(source_struct)
/// @description Recursively clones a struct, including nested structs and arrays.
/// @param {Struct} source_struct The struct to clone.
/// @returns {Struct} A deep copy of the struct.
function struct_clone_recursive(source_struct) {
    if (!is_struct(source_struct)) return source_struct; // Return non-structs as is

    var _new_struct = {};
    var _keys = variable_struct_get_names(source_struct);

    for(var i=0; i < array_length(_keys); i++) {
        var _key = _keys[i];
        var _value = source_struct[$ _key];

        if (is_struct(_value)) {
            _new_struct[$ _key] = struct_clone_recursive(_value); // Clone nested struct
        } else if (is_array(_value)) {
            _new_struct[$ _key] = array_clone_recursive(_value); // Clone nested array
        } else {
            _new_struct[$ _key] = _value; // Copy primitive
        }
    }
    return _new_struct;
}