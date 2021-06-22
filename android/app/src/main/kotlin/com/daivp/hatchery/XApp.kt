package com.daivp.hatchery

import android.app.Application
import cn.jpush.android.api.JPushInterface

class XApp : Application() {
    override fun onCreate() {
        super.onCreate()
        JPushInterface.setDebugMode(true);
        JPushInterface.init(this);
        android.util.Log.d("DDAI","XApp.onCreate");
    }
}