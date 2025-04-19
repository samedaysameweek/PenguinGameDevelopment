/// @function array_clone_recursive(source_array)
/// @description Recursively clones an array, including nested structs and arrays.
/// @param {Array} source_array The array to clone.
/// @returns {Array} A deep copy of the array.
function array_clone_recursive(source_array) {
    if (!is_array(source_array)) return source_array; // Return non-arrays as is

    var _new_array = [];
    var _len = array_length(source_array);

    for (var i = 0; i < _len; i++) {
        var _value = source_array[i];

        if (is_struct(_value)) {
            array_push(_new_array, struct_clone_recursive(_value)); // Clone nested struct
        } else if (is_array(_value)) {
            array_push(_new_array, array_clone_recursive(_value)); // Clone nested array
        } else {
            array_push(_new_array, _value); // Copy primitive
        }
    }
    return _new_array;
}