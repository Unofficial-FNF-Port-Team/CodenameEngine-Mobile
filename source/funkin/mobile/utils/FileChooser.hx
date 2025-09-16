package funkin.mobile.utils;

import lime.system.JNI;

class FileChooser {
    public static function openFilePicker() {
        var cls = JNI.getEnv().findClass("org/haxe/lime/GameActivity");
        var method = JNI.getEnv().getMethodID(cls, "openFilePicker", "()V");
        JNI.getEnv().callVoidMethod(JNI.getEnv().getStaticObjectField(cls, "mainActivity", "Lorg/haxe/lime/GameActivity;"), method);
    }
}
