xspd = 0;
yspd = 0; // No vertical movement
move_spd = 5; // Adjust speed as needed
lives = 3; // Start with 3 lives
global.game_started = true; // Game starts immediately
game_timer = 10 * 60; // 10 seconds timer (assuming 60 FPS)
collision_cooldown = 0; // To prevent multiple hits quickly