// Play the correct music

if room == rm_welcome_room
|| room == rm_plaza
|| room == rm_shore
{
	set_song_ingame( bg_music, 60, 0 );
}

//For other rooms that require different music
//if room == rm_template
//{
//	set_song_ingame( bg_music, 3*60 );
//}

//if room == rm_template
//{
//	set_song_ingame( bg_music, 2*60, 2*60 );
//}