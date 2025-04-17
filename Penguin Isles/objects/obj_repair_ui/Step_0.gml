// Step Event for obj_repair_ui
var b = instance_nearest(global.player_instance.x, global.player_instance.y, obj_building);

if (b != noone && distance_to_object(b) < 32 && b.repair_stage == 0) {
    visible = true;
} else {
    visible = false;
}
