// Destroy all button instances when the skin picker menu is destroyed
with (obj_skinpickerbutton) {
    instance_destroy(); // Destroy all buttons linked to this menu
}
shader_reset(); // Reset the shader to remove the blur effect
