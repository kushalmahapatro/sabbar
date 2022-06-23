import 'package:sabbar/features/map/map.dart';
import 'package:sabbar/features/places/places.dart';
import 'package:sabbar/sabbar.dart';

class MapView extends StatelessWidget {
  const MapView(this.pickType, {Key? key}) : super(key: key);

  final PickType pickType;

  @override
  Widget build(BuildContext context) {
    CameraPosition? pos;
    GoogleMapController? mapController;

    bool initial = true;
    CameraPosition kGooglePlex = const CameraPosition(
      target: LatLng(25.2048, 55.2708),
      zoom: 14,
    );

    _getAddressFromLatLng() {
      try {
        if (pos != null) {
          context.read<CurrentPlaceBloc>().add(SelectPlaceAction(
                lat: pos!.target.latitude.toString(),
                lng: pos!.target.longitude.toString(),
                initial: initial,
                pickType: pickType,
                oldData: context.read<CurrentPlaceBloc>().state ??
                    const FetchSelectPlaceResult(),
              ));
        }
      } catch (e) {
        debugPrint(e.toString());
      }
    }

    LocationData d =
        context.read<CurrentPlaceBloc>().state?.dropoffData ?? LocationData();
    if (d.lat != '0') {
      double lat = double.tryParse(d.lat) ?? 0;
      double lng = double.tryParse(d.lng) ?? 0;
      kGooglePlex = CameraPosition(
        target: LatLng(lat, lng),
        zoom: 14,
      );
    }

    return Stack(
      children: [
        BlocBuilder<MapBloc, FetchResult>(builder: ((context, state) {
          if (state is MapResult && mapController != null) {
            if (state.latLng != null) {
              mapController!
                  .animateCamera(CameraUpdate.newLatLngZoom(state.latLng!, 16));
              context.read<MapBloc>().add(LoadMapCameraAction(
                  oldResult: context.read<MapBloc>().state as MapResult,
                  lat: 0,
                  lng: 0));
            }
          }
          return GoogleMap(
            padding: const EdgeInsets.only(bottom: 60),
            mapToolbarEnabled: false,
            myLocationButtonEnabled: false,
            mapType: MapType.normal,
            initialCameraPosition: kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              controller.setMapStyle(jsonEncode(style1));
              mapController = controller;
            },
            onCameraMoveStarted: () {
              context.read<CurrentPlaceBloc>().add(SelectPlaceAction(
                  oldData: context.read<CurrentPlaceBloc>().state ??
                      const FetchSelectPlaceResult(),
                  loading: true,
                  initial: initial,
                  pickType: pickType));
              var mapBloc = context.read<MapBloc>();
              if (state is MapResult) {
                mapBloc.add(LoadMapAction(
                    size: 0, oldResult: mapBloc.state as MapResult));
              }

              Future.delayed(const Duration(milliseconds: 100), () {
                if (state is MapResult) {
                  mapBloc.add(LoadMapAction(
                      color: context.colors.onSurface,
                      oldResult: mapBloc.state as MapResult));
                }
              });
            },
            onCameraMove: (position) {
              pos = position;
            },
            onCameraIdle: () {
              if (!initial) {
                if (state is MapResult) {
                  _getAddressFromLatLng();
                  context.read<MapBloc>().add(LoadMapAction(
                      size: 40,
                      color: context.colors.primary,
                      oldResult: context.read<MapBloc>().state as MapResult));
                }
              } else {
                initial = false;
              }
            },
          );
        })),
        const Pointer(),
      ],
    );
  }
}
