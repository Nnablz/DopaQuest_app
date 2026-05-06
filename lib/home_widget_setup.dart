/// NATIVE HOME SCREEN WIDGET INTEGRATION (home_widget)
///
/// To display the user's Level, HP, and top 3 Quests on the Android home screen:
///
/// 1. Data Syncing (Flutter Side):
/// Every time a quest is completed or stats change, save the updated values to 
/// native storage so the widget can access them.
/// 
/// ```dart
/// import 'package:home_widget/home_widget.dart';
/// 
/// void updateWidgetData(UserStats stats, List<Quest> quests) {
///   HomeWidget.saveWidgetData<int>('level', stats.level);
///   HomeWidget.saveWidgetData<int>('hp', stats.hp);
///   
///   // Save top 3 pending quests
///   final pending = quests.where((q) => !q.isCompleted).take(3).toList();
///   for (int i = 0; i < 3; i++) {
///     if (i < pending.length) {
///       HomeWidget.saveWidgetData<String>('quest_$i', pending[i].name);
///     } else {
///       HomeWidget.saveWidgetData<String>('quest_$i', ''); // Clear if empty
///     }
///   }
///   
///   HomeWidget.updateWidget(
///       name: 'DopaQuestWidgetProvider', // Name of your Android AppWidgetProvider
///       iOSName: 'DopaQuestWidget' // Name of your iOS AppGroup/Target
///   );
/// }
/// ```
/// 
/// 2. Android Configuration (Native Side):
/// 
/// Create an XML layout for the widget in `android/app/src/main/res/layout/widget_layout.xml`
/// Add TextViews for level, hp, and quest_0, quest_1, quest_2.
/// 
/// Create an AppWidgetProvider class in Kotlin:
/// `android/app/src/main/kotlin/com/example/dopaquest_app/DopaQuestWidgetProvider.kt`
/// ```kotlin
/// package com.example.dopaquest_app
/// 
/// import android.appwidget.AppWidgetManager
/// import android.content.Context
/// import android.content.SharedPreferences
/// import android.widget.RemoteViews
/// import es.antonborri.home_widget.HomeWidgetProvider
/// 
/// class DopaQuestWidgetProvider : HomeWidgetProvider() {
///     override fun onUpdate(
///         context: Context,
///         appWidgetManager: AppWidgetManager,
///         appWidgetIds: IntArray,
///         widgetData: SharedPreferences
///     ) {
///         appWidgetIds.forEach { widgetId ->
///             val views = RemoteViews(context.packageName, R.layout.widget_layout).apply {
///                 val level = widgetData.getInt("level", 1)
///                 val hp = widgetData.getInt("hp", 100)
///                 setTextViewText(R.id.level_text, "Level: $level")
///                 setTextViewText(R.id.hp_text, "HP: $hp/100")
///                 
///                 setTextViewText(R.id.quest_0_text, widgetData.getString("quest_0", ""))
///                 setTextViewText(R.id.quest_1_text, widgetData.getString("quest_1", ""))
///                 setTextViewText(R.id.quest_2_text, widgetData.getString("quest_2", ""))
///             }
///             appWidgetManager.updateAppWidget(widgetId, views)
///         }
///     }
/// }
/// ```
/// 
/// Register the provider in `AndroidManifest.xml` inside the `<application>` tag:
/// ```xml
/// <receiver android:name=".DopaQuestWidgetProvider" android:exported="true">
///     <intent-filter>
///         <action android:name="android.appwidget.action.APPWIDGET_UPDATE" />
///     </intent-filter>
///     <meta-data android:name="android.appwidget.provider"
///                android:resource="@xml/widget_info" />
/// </receiver>
/// ```
