package funkin.mobile.utils;

import lime.system.JNI;

class FileChooser {
    public static var onSelect:String->Void = null;
    
    public static function openFilePicker() {
        #if android
        var openFilePicker_jni = JNI.createStaticMethod("org/haxe/lime/GameActivity", "openFilePicker", "()V");
        openFilePicker_jni();
        #end
    }
    
    /* 
    * This func will be called from Java when a file is selected
    */
    public static function onFileSelected(path:String):Void {
        if (onSelect != null) {
            onSelect(path);
        }
    }
}
