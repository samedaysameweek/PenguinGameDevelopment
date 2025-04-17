var _finalVol = global.musicVolume*global.masterVolume;

//Play the target song
if songAsset != targetSongAsset
{
	//Tell the old song to fade out
	if audio_is_playing( songInstance )
	{
		//add out songInstance to our array of songs to fade out
		array_push( fadeOutInstances, songInstance );
		//add the songInstance's starting volume (so theres no adrupt change in volume)
		array_push( fadeOutInstVol, fadeInInstVol );
		//add the fadeOutInstance's fade out frames
		array_push( fadeOutInstTime, endFadeOutTime );
		
		//reset the songInstance and songAsset variables
		songInstance = noone;
		songAsset = noone;
	}
	
	
	//Play the song if the old song has faded out
	if array_length( fadeOutInstances) == 0
	{
		if audio_exists( targetSongAsset)
		{
			//Play the song and store its instance in a variable
			songInstance = audio_play_sound( targetSongAsset, 4, true );
	
			//Start the song's volume at 0
			audio_sound_gain( songInstance, 0, 0 );
			fadeInInstVol = 0;
		}
	
	//Set the songAssest to match the targetSongAsset
	songAsset = targetSongAsset;
	}
}


//Volume Control
	//Main song volume
	if audio_is_playing( songInstance )
	{
		//Fade the song in
		if startFadeInTime > 0
		{
			if fadeInInstVol < 1 { fadeInInstVol += 1/startFadeInTime; } else fadeInInstVol = 1
		}
		//Immediately start the song if the fade in time is 0 framces
		else
		{
			fadeInInstVol = 1;
		}
	
		//Actually set the gain
		audio_sound_gain( songInstance, fadeInInstVol*_finalVol, 0 )
	}
	
	//Fading songs out
	for(var i = 0; i < array_length(fadeOutInstances); i++ )
	{
		//Fade the volume
		if fadeOutInstTime[i] > 0
		{
			if	fadeOutInstVol[i] > 0 {fadeOutInstVol[i] -= 1/fadeOutInstTime[i]; }
		}
		//Immediately cut volume to 0 otherwuse
		else
		{
			fadeOutInstVol[i] = 0;
		}
		
		//Actually set the gain
		audio_sound_gain( fadeOutInstances[i], fadeOutInstVol[i]*_finalVol, 0 );
		
		//Stop the song when it's volume is at 0 and remove it from ALL arrays
		if fadeOutInstVol[i] <= 0
		{
			//stop the song	
			if audio_is_playing( fadeOutInstances[i] ) { audio_stop_sound( fadeOutInstances[i] ); };
			//remove it from the arrays
			array_delete( fadeOutInstances, i, 1);
			array_delete( fadeOutInstVol, i, 1);
			array_delete( fadeOutInstTime, i, 1);
			//set the loop back 1 since we just deleted an entry
			i--;
		}
	}
	
	
	
	