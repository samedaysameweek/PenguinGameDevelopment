// obj_player_base Step
global.player_x = x;
global.player_y = y;

xspd = handle_collision("x", xspd);
yspd = handle_collision("y", yspd);
x += xspd;
y += yspd;
set_depth();