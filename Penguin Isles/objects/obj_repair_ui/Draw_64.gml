// Draw GUI Event for obj_repair_ui
if (visible) {
    var ui_x = camera_get_view_x(view_camera[0]) + 20;
    var ui_y = camera_get_view_y(view_camera[0]) + 20;

    draw_set_color(c_white);
    draw_rectangle(ui_x, ui_y, ui_x + 150, ui_y + 50, false);
    draw_set_color(c_black);
    draw_text(ui_x + 10, ui_y + 10, "Press 'E' to Repair");

    // Draw required materials
    for (var i = 0; i < 3; i++) {
        draw_sprite(spr_inventory_items, 7 + i, ui_x + 10 + (i * 20), ui_y + 30);
    }
}
