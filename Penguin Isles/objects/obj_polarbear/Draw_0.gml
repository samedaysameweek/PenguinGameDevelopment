   // obj_polarbear Draw Event - REVISED WALK FRAME CALC + DEBUG
   var _frame_w = 48;
   var _frame_h = 48;
   var _draw_x = x;
   var _draw_y = y;
   var _sprite_to_draw = spr_polarbear_face_sheet; // Default fallback
   var _frame_index_to_draw = current_direction;   // Default to face direction index
   var _xscale = 1;                                // Default horizontal scale
   var _final_draw_x = _draw_x - (_frame_w / 2);   // Default centered X
   var _final_draw_y = _draw_y - (_frame_h / 2);   // Default centered Y
   var _cols_per_sheet = 8;                        // Default for face/throw sheets
   var _left = 0;
   var _top = 0;
   var _total_frames_in_sprite = 1; // Default

   // --- DEBUG START ---
   var _debug_draw_state = "Mood: " + mood + ", ThrT: " + string(throw_timer) + ", Stop: " + string(is_stopped) + ", ImgIdx: " + string(image_index) + ", ImgSpd: " + string(image_speed) + ", CurDir: " + string(current_direction);
   // --- DEBUG END ---


   if (mood == "passive" || (mood == "angry" && throw_timer <= 0)) {
       // --- Walking or Idle (or Angry but NOT currently throwing) ---
       var _is_currently_idle = (xspd == 0 && yspd == 0);

       if (_is_currently_idle || is_stopped) {
           _sprite_to_draw = spr_polarbear_face_sheet;
           _total_frames_in_sprite = 8; // Face sheet has 8 frames
           _frame_index_to_draw = current_direction % _total_frames_in_sprite;
           _xscale = 1;
           _cols_per_sheet = 8;
           _debug_draw_state += " | DrawState: IdleFace";
       } else {
           _sprite_to_draw = walk_frame_sheets[current_direction];
           if (!sprite_exists(_sprite_to_draw)) { /* ... fallback ... */
               _debug_draw_state += " | ERROR: Walk sheet invalid for dir " + string(current_direction);
               _sprite_to_draw = spr_polarbear_face_sheet;
               _total_frames_in_sprite = 8;
               _frame_index_to_draw = current_direction % _total_frames_in_sprite;
               _xscale = 1;
               _cols_per_sheet = 8;
           } else {
              // *** MANUALLY USE 40 FRAMES FOR WALK SHEETS ***
              _total_frames_in_sprite = 40; // All walk sheets have 40 frames (8x5 grid)
              _frame_index_to_draw = floor(image_index) % _total_frames_in_sprite;
              // *** END CHANGE ***

              if (current_direction == PB_DOWN_RIGHT || current_direction == PB_RIGHT || current_direction == PB_UP_RIGHT) { _xscale = -1; } else { _xscale = 1; }
              _cols_per_sheet = 8;
              _debug_draw_state += " | DrawState: Walking";
           }
       }

   } else if (mood == "angry" && throw_timer > 0) {
        // --- Throwing State ---
         _sprite_to_draw = throw_sprite;
        if (!sprite_exists(_sprite_to_draw)) { /* ... fallback ... */
             _debug_draw_state += " | ERROR: Invalid throw_sprite! Fallback to face.";
             _sprite_to_draw = spr_polarbear_face_sheet;
             _total_frames_in_sprite = 8; // Use face sheet frame count
             _frame_index_to_draw = current_direction % _total_frames_in_sprite;
            _xscale = 1;
            _cols_per_sheet = 8;
        } else {
            _total_frames_in_sprite = sprite_get_number(_sprite_to_draw);
             if (_total_frames_in_sprite <= 0) _total_frames_in_sprite = 1;
            _frame_index_to_draw = 0;
            if (throw_duration > 0 && _total_frames_in_sprite > 0) {
                var _anim_progress = 1 - (throw_timer / throw_duration);
                _frame_index_to_draw = floor(_anim_progress * _total_frames_in_sprite);
                _frame_index_to_draw = clamp(_frame_index_to_draw, 0, _total_frames_in_sprite - 1);
            }
            if (current_direction == PB_DOWN_RIGHT || current_direction == PB_RIGHT || current_direction == PB_UP_RIGHT) { _xscale = -1; } else { _xscale = 1; }
            _cols_per_sheet = 8;
            _debug_draw_state += " | DrawState: Throwing";
        }
   } else {
        // Fallback state if logic is missed
        _debug_draw_state += " | DrawState: UNKNOWN/FALLBACK";
        _sprite_to_draw = spr_polarbear_face_sheet;
        _total_frames_in_sprite = 8; // Use face sheet frame count
        _frame_index_to_draw = current_direction % _total_frames_in_sprite;
        _xscale = 1;
        _cols_per_sheet = 8;
   }

   // --- Calculate Final Drawing Parameters ---
   _final_draw_x = _draw_x - (_frame_w / 2) * _xscale; // Apply scale offset
   _final_draw_y = _draw_y - (_frame_h / 2);
   if (_cols_per_sheet <= 0) _cols_per_sheet = 1;
   var _col = _frame_index_to_draw % _cols_per_sheet;
   var _row = floor(_frame_index_to_draw / _cols_per_sheet);
   _left = _col * _frame_w;
   _top = _row * _frame_h;

   // --- Final Draw Call & Debug ---
   if (sprite_exists(_sprite_to_draw)) {
       draw_sprite_part_ext(_sprite_to_draw, 0, _left, _top, _frame_w, _frame_h, _final_draw_x, _final_draw_y, _xscale, 1, c_white, 1);
       draw_set_halign(fa_center); draw_set_valign(fa_bottom); draw_set_font(fnt_earlygb); draw_set_color(c_yellow);
       // Refined Debug Text
       var _sprite_name = sprite_get_name(_sprite_to_draw);
       var _frame_info = " (" + string(_col) + "," + string(_row) + " of " + string(_total_frames_in_sprite) + ")";
       draw_text(x, y - _frame_h/2 - 2, _debug_draw_state + " | Spr: " + _sprite_name + " | Frm: " + string(_frame_index_to_draw) + _frame_info);
       draw_set_color(c_white); draw_set_halign(fa_left); draw_set_valign(fa_top);
   } else { /* ... fallback drawing ... */ }

   set_depth();