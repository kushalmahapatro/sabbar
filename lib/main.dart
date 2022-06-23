import 'package:dynamic_color/dynamic_color.dart';
import 'package:sabbar/sabbar.dart';
import 'package:sabbar/shared/router.dart';
import 'package:sabbar/shared/theme/lib_color_schemes.g.dart';
import 'package:sabbar/shared/theme/theme_provider.dart';

import 'features/places/places.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final settings = ValueNotifier(ThemeSettings(
      darkColorScheme: darkColorScheme,
      lightColorScheme: lightColorScheme,
      themeMode: ThemeMode.light,
    ));

    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) => ThemeProvider(
          lightDynamic: settings.value.lightColorScheme,
          darkDynamic: settings.value.darkColorScheme,
          settings: settings,
          child: NotificationListener<ThemeSettingChange>(
            onNotification: (notification) {
              settings.value = notification.settings;
              return true;
            },
            child: ValueListenableBuilder<ThemeSettings>(
              valueListenable: settings,
              builder: (context, value, _) {
                final theme = ThemeProvider.of(context);
                return BlocProvider(
                    create: ((context) => CurrentPlaceBloc(context)),
                    child: MaterialApp.router(
                      debugShowCheckedModeBanner: false,
                      theme: theme.light(),
                      darkTheme: theme.dark(),
                      themeMode: theme.themeMode(),
                      routeInformationParser: appRouter.routeInformationParser,
                      routerDelegate: appRouter.routerDelegate,
                    ));
              },
            ),
          )),
    );
  }
}
