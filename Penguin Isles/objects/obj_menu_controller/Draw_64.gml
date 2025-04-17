if (global.menu_state == "puffle_menu") {
    draw_set_color(c_black);
    draw_rectangle(100, 100, 300, 200, false); // Menu background
    draw_set_color(c_white);
    draw_text(150, 120, "Adopt");
    draw_text(150, 140, "Cancel");
    draw_text(130, 120 + global.menu_index * 20, ">"); // Cursor
}

if (global.menu_state == "name_puffle") {
    draw_set_color(c_black);
    draw_rectangle(100, 100, 300, 200, false);
    draw_set_color(c_white);
    draw_text(150, 140, "Press Enter to name your puffle");
}