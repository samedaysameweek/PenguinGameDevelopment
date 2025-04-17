// obj_map Draw Event
draw_self(); // Draw the full map sprite

// Draw markers or labels for clickable regions (halved size)
draw_set_color(c_red);
draw_rectangle(185 - 25, 228 - 25, 185 + 25, 228 + 25, false); // Town
draw_rectangle(55 - 25, 190 - 25, 55 + 25, 190 + 25, false); // Beach
draw_rectangle(155 - 25, 128 - 25, 155 + 25, 128 + 25, false); // Ski village
draw_rectangle(280 - 25, 250 - 25, 280 + 25, 250 + 25, false); // Snow fort
draw_rectangle(410 - 25, 277 - 25, 410 + 25, 277 + 25, false); // Welcome room
draw_rectangle(380 - 25, 230 - 25, 380 + 25, 230 + 25, false); // Plaza
draw_rectangle(395 - 25, 170 - 25, 395 + 25, 170 + 25, false); // Forest
draw_rectangle(400 - 25, 130 - 25, 400 + 25, 130 + 25, false); // Cove
draw_rectangle(135 - 25, 60 - 25, 135 + 25, 60 + 25, false); // Mountain top
