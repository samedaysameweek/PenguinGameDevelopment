// Room Start Event for obj_puffle
if (following_player && variable_global_exists("player_instance") && instance_exists(global.player_instance)) {
    // Position puffle 16 pixels offset from player based on player's facing direction
    var offset_dist = 16;
    var offset_dir;
    switch (global.player_instance.face) {
        case RIGHT: offset_dir = 0; break;
        case LEFT: offset_dir = 180; break;
        case UP: offset_dir = 90; break;
        case DOWN: offset_dir = 270; break;
        default: offset_dir = 270; // Default to below player
    }
    x = global.player_instance.x + lengthdir_x(offset_dist, offset_dir);
    y = global.player_instance.y + lengthdir_y(offset_dist, offset_dir);

    // Prevent overlap with walls
    if (place_meeting(x, y, obj_wall)) {
        x = global.player_instance.x;
        y = global.player_instance.y;
    }
}