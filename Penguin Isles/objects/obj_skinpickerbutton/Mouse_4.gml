if (skin_object != noone) {
    obj_controller.switch_skin(skin_name);
}

// Destroy the skin picker menu if a valid skin was selected
if (skin_object != noone) {
    with (obj_skinpicker) {
        instance_destroy();
    }
}
