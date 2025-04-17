// obj_ui_draw.txt
// Set font and alignment for UI text
draw_set_font(fnt_bumbastika_sml);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// Draw UI elements
for (var i = 0; i < array_length(ui_elements); i++) {
    var elem = ui_elements[i];
    draw_rectangle(elem.x, elem.y, elem.x + elem.width, elem.y + elem.height, false);
    draw_text(elem.x + elem.width / 2, elem.y + elem.height / 2, elem.text);
}