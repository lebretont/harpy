import 'package:flutter/material.dart';
import 'package:harpy/components/screens/custom_theme_screen.dart';
import 'package:harpy/core/misc/harpy_navigator.dart';
import 'package:harpy/core/misc/harpy_theme.dart';
import 'package:harpy/models/settings_model.dart';
import 'package:harpy/models/theme_model.dart';

/// A [Card] showing a selectable [HarpyTheme] that changes the apps theme when
/// selected.
class ThemeCard extends StatelessWidget {
  const ThemeCard({
    @required this.harpyTheme,
    @required this.id,
  });

  final HarpyTheme harpyTheme;
  final int id;

  Widget _buildThemeName(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.0),
      width: double.infinity,
      color: harpyTheme.theme.primaryColor,
      child: Text(
        "${harpyTheme.name}",
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.body1.copyWith(color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildThemeColors() {
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: 5,
          color: harpyTheme.theme.accentColor,
        ),
      ],
    );
  }

  Widget _buildSelectedIcon(
    SettingsModel settingsModel,
    ThemeModel themeModel,
  ) {
    if (settingsModel.selectedTheme(id)) {
      return Align(
        alignment: Alignment.topLeft,
        child: Padding(
          padding: EdgeInsets.all(4.0),
          child: const Icon(Icons.check),
        ),
      );
    }

    return Container();
  }

  void _onTap(
    BuildContext context,
    SettingsModel settingsModel,
    ThemeModel themeModel,
  ) {
    // if already selected, edit theme on top
    if (!harpyTheme.defaultTheme && settingsModel.selectedTheme(id)) {
      HarpyNavigator.push(
        context,
        CustomThemeScreen(editingThemeId: id),
      );
    } else {
      themeModel.changeSelectedTheme(harpyTheme, id);
      settingsModel.notifyListeners();
    }
  }

  void _onLongPress(BuildContext context) {
    // edit theme on long press if it is not the default theme
    if (!harpyTheme.defaultTheme) {
      HarpyNavigator.push(
        context,
        CustomThemeScreen(editingThemeId: id),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeModel = ThemeModel.of(context);
    final settingsModel = SettingsModel.of(context);

    return SizedBox(
      width: 120,
      height: 120,
      child: Theme(
        data: harpyTheme.theme,
        child: Card(
          color: harpyTheme.theme.scaffoldBackgroundColor,
          child: Stack(
            children: <Widget>[
              InkWell(
                borderRadius: BorderRadius.circular(4.0),
                onTap: () => _onTap(context, settingsModel, themeModel),
                onLongPress: () => _onLongPress(context),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      child: _buildSelectedIcon(settingsModel, themeModel),
                    ),
                    _buildThemeName(context),
                    Expanded(child: _buildThemeColors()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Similar to [ThemeCard] that can be selected to add a new custom theme.
class AddCustomThemeCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 120,
      child: Container(
        margin: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            border: Border.all(
              width: 1.0,
              color: Theme.of(context).dividerColor,
            )),
        child: InkWell(
          onTap: () => HarpyNavigator.push(context, CustomThemeScreen()),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Custom"),
              Icon(Icons.add),
            ],
          ),
        ),
      ),
    );
  }
}