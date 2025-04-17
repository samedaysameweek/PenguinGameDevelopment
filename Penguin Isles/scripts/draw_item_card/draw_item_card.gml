/// @function draw_item_card(item, x, y)
/// @description Draws an item card with sprite, name, price,
/// @param {struct} item The item data to draw
/// @param {real} x The x position to draw at
/// @param {real} y The y position to draw at

function draw_item_card(item, card_x, card_y) {
    // Draw card background
    draw_set_color(c_dkgray);
    draw_rectangle(card_x, card_y, card_x + item_width, card_y + item_height, false);

    // Draw item sprite
    var sprite_scale = min((item_width - 20) / sprite_get_width(item.sprite),
                           (item_height * 0.6) / sprite_get_height(item.sprite));
    var sprite_x = card_x + item_width/2;
    var sprite_y = card_y + (item_height * 0.3);
    draw_sprite_ext(item.sprite, 0,
                    sprite_x, sprite_y,
                    sprite_scale, sprite_scale,
                    0, c_white, 1);

    // Draw item name
    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_font(fnt_shop_item);
    draw_text(card_x + item_width/2, card_y + item_height * 0.65, item.name);

    // Draw price
    var price_color = global.player_coins >= item.price ? c_lime : c_red;
    draw_set_color(price_color);
    draw_text(card_x + item_width/2, card_y + item_height * 0.8,
              string(item.price) + " coins");

    // Draw stock info if limited
    if (variable_struct_exists(item, "stock") && item.stock >= 0) {
        draw_set_color(c_yellow);
        draw_text(card_x + item_width/2, card_y + item_height * 0.9,
                  "Stock: " + string(item.stock));
    }

    // Draw seasonal tag if applicable
    if (variable_struct_exists(item, "seasonal") && item.seasonal) {
        draw_set_color(c_aqua);
        draw_text(card_x + item_width/2, card_y + 10, "Seasonal!");
    }
}