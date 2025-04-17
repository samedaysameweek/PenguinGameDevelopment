// Draw Event for obj_sled_player

draw_self(); // Draw the player sprite

if (global.game_started) {
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_black);
    draw_text(10, 10, "Lives: " + string(lives));
    draw_text(10, 30, "Time: " + string(ceil(game_timer / 60))); // Display in seconds
}