depth = -1000; // Ensuring the skin picker is in front of everything

// Menu dimensions
menu_width = 109;
menu_height = 72;

// Position the skin picker around the current player instance or center it in the view
if (instance_exists(global.player_instance)) {
    x = global.player_instance.x - menu_width / 2;
    y = global.player_instance.y - menu_height / 2;
} else {
    x = view_xview[0] + (view_wview[0] - menu_width) / 2;
    y = view_yview[0] + (view_hview[0] - menu_height) / 2;
}

// Ensure the global skins array exists
if (!variable_global_exists("skins")) {
    global.skins = [
        {object: obj_player_icetruck, name: "Ice Truck"},
        {object: obj_player, name: "Penguin"},
        {object: obj_player_tube, name: "Tube"}
    ];
}

// Button properties
var button_width = 37.5; 
var button_height = 10; 
var button_padding = 2.5; 
var button_x = x + (menu_width - button_width) / 2; 
var button_y = y + button_padding; 

// Create buttons for each skin
for (var i = 0; i < array_length(global.skins); i++) {
    var skin = global.skins[i];
    var btn_skin = instance_create_layer(button_x, button_y, "Instances", obj_skinpickerbutton); // Reference obj_skinpickerbutton
    btn_skin.skin_object = skin.object; // Set the object to switch to
    btn_skin.skin_name = skin.name;    // Set the button label

    // Scale buttons
    btn_skin.image_xscale = button_width / sprite_get_width(spr_button);
    btn_skin.image_yscale = button_height / sprite_get_height(spr_button);

    button_y += button_height + button_padding; // Position the next button
}

// Create a Close button
var btn_close = instance_create_layer(button_x, button_y, "Instances", obj_skinpickerbutton);
btn_close.skin_object = noone; // No skin switch, just close
btn_close.skin_name = "Close"; 
btn_close.sprite_index = spr_button;

// Scale the Close button
btn_close.image_xscale = button_width / sprite_get_width(spr_button);
btn_close.image_yscale = button_height / sprite_get_height(spr_button);


