package flixel.sound;

/**
 * A way of grouping sounds for things such as collective volume control
 */
class FlxSoundGroup
{
    /**
     * The sounds in this group
     */
    public var sounds:Array<FlxSound> = [];

    /**
     * The volume of this group
     */
    public var volume(default, set):Float;

    /**
     * Whether or not this group is muted
     */
    public var muted(default, set):Bool;

    /**
     * Create a new sound group
     * @param	volume  The initial volume of this group
     */
    public function new(volume:Float = 1)
    {
        this.volume = volume;
    }

    /**
     * Add a sound to this group, will remove the sound from any group it is currently in
     * @param	sound The sound to add to this group
     * @return True if sound was successfully added, false otherwise
     */
    public function add(sound:FlxSound):Bool
    {
        if (sound == null) {
            #if debug
            trace("WARNING: Attempt to add null sound to FlxSoundGroup");
            #end
            return false;
        }
        
        if (!sounds.contains(sound))
        {
            try {
                // remove from prev group
                if (sound.group != null)
                    sound.group.sounds.remove(sound);
                
                sounds.push(sound);
                @:bypassAccessor
                sound.group = this;
                
                if (sound.updateTransform != null) {
                    sound.updateTransform();
                } else {
                    #if debug
                    trace("WARNING: sound.updateTransform null");
                    #end
                }
                
                return true;
            } catch (e:Dynamic) {
                #if debug
                trace("ERROR trying to add a sound to the group" + e);
                #end
                return false;
            }
        }
        return false;
    }

    /**
     * Remove a sound from this group
     * @param	sound The sound to remove
     * @return True if sound was successfully removed, false otherwise
     */
    public function remove(sound:FlxSound):Bool
    {
        if (sound == null) {
            #if debug
            trace("WARNING: Attempt to remove null sound from FlxSoundGroup");
            #end
            return false;
        }
        
        if (sounds.contains(sound))
        {
            try {
                @:bypassAccessor
                sound.group = null;
                sounds.remove(sound);
                
                if (sound.updateTransform != null) {
                    sound.updateTransform();
                } else {
                    #if debug
                    trace("WARNING: sound.updateTransform is null durant remove");
                    #end
                }
                
                return true;
            } catch (e:Dynamic) {
                #if debug
                trace("ERROR on removing the sound of the group: " + e);
                #end
                return false;
            }
        }
        return false;
    }

    /**
     * Call this function to pause all sounds in this group.
     * @since 4.3.0
     */
    public function pause():Void
    {
        if (sounds != null) {
            for (sound in sounds) {
                if (sound != null) {
                    try {
                        sound.pause();
                    } catch (e:Dynamic) {
                        #if debug
                        trace("ERROR on pausing sound: " + e);
                        #end
                    }
                }
            }
        }
    }

    /**
     * Unpauses all sounds in this group. Only works on sounds that have been paused.
     * @since 4.3.0
     */
    public function resume():Void
    {
        if (sounds != null) {
            for (sound in sounds) {
                if (sound != null) {
                    try {
                        sound.resume();
                    } catch (e:Dynamic) {
                        #if debug
                        trace("ERROR resuming sound: " + e);
                        #end
                    }
                }
            }
        }
    }

    /**
     * Returns the volume of this group, taking `muted` in account.
     * @return The volume of the group or 0 if the group is muted.
     */
    public function getVolume():Float
    {
        return muted ? 0.0 : volume;
    }

    function set_volume(volume:Float):Float
    {
        this.volume = volume;
        
        if (sounds != null) {
            for (sound in sounds) {
                if (sound != null && sound.updateTransform != null) {
                    try {
                        sound.updateTransform();
                    } catch (e:Dynamic) {
                        #if debug
                        trace("ERROR updating transform on set_volume: " + e);
                        #end
                    }
                }
            }
        }
        
        return volume;
    }

    function set_muted(value:Bool):Bool
    {
        muted = value;
        
        if (sounds != null) {
            for (sound in sounds) {
                if (sound != null && sound.updateTransform != null) {
                    try {
                        sound.updateTransform();
                    } catch (e:Dynamic) {
                        #if debug
                        trace("ERROR updating transform on set_muted: " + e);
                        #end
                    }
                }
            }
        }
        
        return muted;
    }

    /**
     * Cleans up null sounds from the group.
     */
    public function cleanup():Void
    {
        if (sounds != null) {
            sounds = sounds.filter(function(sound) return sound != null);
        }
    }
}