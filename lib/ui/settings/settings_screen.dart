import 'package:flutter/material.dart';
import 'package:flutter_demo/ui/settings/settings_manager.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final manager = SettingsManager();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: manager.appState,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(title: Text('Settings')),
          body: ListView(
            children: [
              ListTile(
                title: Text('Theme'),
                subtitle: Text(manager.currentThemeTitle),
                onTap: () async {
                  await _showThemeDialog();
                },
              ),
              ListTile(
                title: Text('App Language'),
                subtitle: Text("English"),
                onTap: () async {
                  await _showLanguageDialog();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  ThemeMode theme = ThemeMode.system;

  Future<ThemeMode?> _showThemeDialog() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SegmentedButton<ThemeMode>(
          segments: [
            ButtonSegment(value: ThemeMode.light, icon: Icon(Icons.light_mode)),
            ButtonSegment(
              value: ThemeMode.system,
              icon: Icon(Icons.smartphone),
            ),
            ButtonSegment(value: ThemeMode.dark, icon: Icon(Icons.dark_mode)),
          ],
          selected: {manager.currentTheme},
          onSelectionChanged: (Set<ThemeMode> selection) {
            manager.setTheme(selection.first);
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }

  Future<ThemeMode?> _showLanguageDialog() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SegmentedButton<Locale>(
          segments: [
            ButtonSegment(value: Locale('en'), label: Text('English')),
            ButtonSegment(value: Locale('mn'), label: Text('Mongolian')),
            ButtonSegment(value: Locale('ko'), label: Text('Korean')),
          ],
          selected: {manager.currentLocale},
          onSelectionChanged: (Set<Locale> selection) {
            manager.setLocale(selection.first);
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}
