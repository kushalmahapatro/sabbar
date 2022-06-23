import 'package:sabbar/features/map/map.dart';
import 'package:sabbar/features/places/places.dart';
import 'package:sabbar/sabbar.dart';
import 'package:sabbar/screens/screens.dart';

import '../features/route_preview/route_preview.dart';

final appRouter = GoRouter(
  routes: [
    /// Home Screen
    GoRoute(
        name: 'pickup',
        path: '/',
        builder: (context, state) => MultiBlocProvider(providers: [
              BlocProvider.value(value: PlacesBloc()),
              BlocProvider.value(value: MapBloc(context, PickType.pickup)),
            ], child: const PickLocationScreen(pickType: PickType.pickup))),
    GoRoute(
        name: "dropoff",
        path: '/dropoff',
        builder: (context, state) => MultiBlocProvider(providers: [
              BlocProvider.value(value: PlacesBloc()),
              BlocProvider.value(value: MapBloc(context, PickType.dropoff)),
            ], child: const PickLocationScreen(pickType: PickType.dropoff))),

    GoRoute(
        name: "route",
        path: '/route',
        builder: (context, state) {
          final pl =
              (state.extra as Map<String, dynamic>)['pickupLocation'] as LatLng;
          final dl = (state.extra as Map<String, dynamic>)['dropoffLocation']
              as LatLng;
          final pa =
              (state.extra as Map<String, dynamic>)['pickupAddress'].toString();
          final da = (state.extra as Map<String, dynamic>)['dropoffAddress']
              .toString();
          return MultiBlocProvider(
            providers: [
              BlocProvider.value(value: PreviewMapBloc(context)),
              BlocProvider.value(value: BottomBloc(context)),
              BlocProvider.value(value: TripBloc(context)),
            ],
            child: RoutePreviewScreen(
                pickupLocation: pl,
                dropoffLocation: dl,
                pickupAddress: pa,
                dropoffAddress: da),
          );
        })
  ],
);
