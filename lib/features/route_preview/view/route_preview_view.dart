import 'package:flutter_animarker/flutter_map_marker_animation.dart';
import 'package:sabbar/features/map/map.dart';
import 'package:sabbar/features/route_preview/route_preview.dart';
import 'package:sabbar/sabbar.dart';

class RoutePreviewMapView extends StatefulWidget {
  const RoutePreviewMapView(
      {required this.pickupLocation, required this.dropoffLocation, Key? key})
      : super(key: key);
  final LatLng pickupLocation;
  final LatLng dropoffLocation;

  @override
  State<RoutePreviewMapView> createState() => _RoutePreviewMapViewState();
}

class _RoutePreviewMapViewState extends State<RoutePreviewMapView> {
  GoogleMapController? mapController;
  final completer = Completer<GoogleMapController>();

  List<LatLng> polylineCoordinates = [];
  List<Marker> markers = [];
  Set<Polyline> polylines = {};

  @override
  void initState() {
    context.read<PreviewMapBloc>()
      ..add(InitialMarkerAction(
          pick: widget.pickupLocation, drop: widget.dropoffLocation))
      ..add(TripPolylineAction(
          dropOff: widget.dropoffLocation, pickup: widget.pickupLocation))
      ..add(NearbyDriverAction(
          lat: widget.pickupLocation.latitude,
          lng: widget.pickupLocation.longitude));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BlocBuilder<PreviewMapBloc, FetchResult>(
          builder: ((context, state) {
            setStates(state, context);

            return LayoutBuilder(
              builder: (context, cons) {
                return Animarker(
                  curve: Curves.ease,
                  rippleColor: context.colors.primary,
                  shouldAnimateCamera: true,
                  useRotation: true,
                  mapId: completer.future.then<int>((value) => value.mapId),
                  child: GoogleMap(
                    padding: EdgeInsets.only(bottom: cons.maxHeight * 0.5),
                    mapToolbarEnabled: false,
                    myLocationButtonEnabled: false,
                    mapType: MapType.normal,
                    initialCameraPosition: CameraPosition(
                      target: widget.pickupLocation,
                      zoom: 14,
                    ),
                    markers: markers.toSet(),
                    polylines: polylines,
                    onMapCreated: (GoogleMapController controller) {
                      completer.complete(controller);
                      controller.setMapStyle(jsonEncode(style1));
                      mapController = controller;
                    },
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }

  void setStates(FetchResult state, BuildContext context) {
    if (state is InitialMarkerResult) {
      markers.addAll(state.markers);
    }

    if (state is NearbyDriverResult) {
      markers.addAll(state.drivers);
    }
    if (state is TripPolylineResult) {
      addPolyline(state, context, 'route');
    }
    if (state is PickupPolylineResult) {
      addPolyline(state, context, 'pickup');
      List<Marker> m = [];
      MarkerId id = const MarkerId('');
      for (var v in markers) {
        if (v.position == state.markerLocation) {
          m.add(v);
          id = v.markerId;
        } else if (v.position == widget.pickupLocation ||
            v.position == widget.dropoffLocation) {
          m.add(v);
        }
      }

      markers
        ..clear()
        ..addAll(m);
      Future.delayed(const Duration(milliseconds: 500), () {
        final stream = Stream.periodic(
                const Duration(seconds: 2), (count) => state.polyline[count])
            .take(state.polyline.length);
        var bloc = context.read<TripBloc>();
        bloc.add(TripChangeAction(
          status: TripStatus.started,
          oldResult: bloc.state as TripChangeResult,
        ));
        stream.listen((element) {
          context.read<PreviewMapBloc>().add(UpdateMarkerAction(element, id));
        }, onDone: () {
          bloc.add(TripChangeAction(
            status: TripStatus.reached,
            oldResult: bloc.state as TripChangeResult,
          ));
          Future.delayed(const Duration(seconds: 1), () {
            bloc.add(
              TripChangeAction(
                status: TripStatus.pickup,
                oldResult: bloc.state as TripChangeResult,
              ),
            );
            Polyline? pol;
            for (var p in polylines) {
              if (p.polylineId.value == 'route') {
                pol = p;
              }
            }
            if (pol != null) {
              final routeStream = Stream.periodic(
                      const Duration(seconds: 2), (count) => pol!.points[count])
                  .take(pol.points.length);

              Future.delayed(const Duration(seconds: 1), () {
                bloc.add(
                  TripChangeAction(
                      status: TripStatus.onway,
                      oldResult: bloc.state as TripChangeResult),
                );
              });

              routeStream.listen((event) {
                context
                    .read<PreviewMapBloc>()
                    .add(UpdateMarkerAction(event, id));
              }, onDone: () {
                bloc.add(
                  TripChangeAction(
                    status: TripStatus.delivered,
                    oldResult: bloc.state as TripChangeResult,
                  ),
                );
                Future.delayed(const Duration(seconds: 1), () {
                  bloc.add(
                    TripChangeAction(
                      status: TripStatus.complete,
                      oldResult: bloc.state as TripChangeResult,
                    ),
                  );
                });
              });
            }
          });
        });
      });
    }

    if (state is MoveToMarkerResult && mapController != null) {
      mapController!
          .animateCamera(CameraUpdate.newLatLngZoom(state.marker, 14));
      for (var v in markers) {
        if (v.position == state.marker) {
          mapController!.showMarkerInfoWindow(v.markerId);
        }
      }
    }

    if (state is UpdateMarkerResult) {
      for (int i = 0; i < markers.length; i++) {
        if (state.id == markers[i].markerId) {
          final double bearing =
              getBearing(markers[i].position, state.marker.position);
          var distance = getRange(state.marker.position, widget.pickupLocation);

          markers[i] = state.marker.copyWith(
              rotationParam: bearing, anchorParam: const Offset(0.5, 0.5));
        }
      }
      if (mapController != null) {
        mapController!.animateCamera(
            CameraUpdate.newLatLngZoom(state.marker.position, 17));
        mapController!.hideMarkerInfoWindow(state.marker.markerId);
      }
    }
  }

  void addPolyline(var state, BuildContext context, String id) {
    var v = polylines.firstWhere(
      (element) => element.polylineId.value == id,
      orElse: () => const Polyline(polylineId: PolylineId('')),
    );
    if (v.polylineId.value.isEmpty) {
      polylines.add(
        Polyline(
          polylineId: PolylineId(id),
          points: state.polyline,
          color:
              id == 'route' ? context.colors.primary : const Color(0xff598527),
          width: 6,
        ),
      );
    } else {
      polylines.remove(v);
      polylines.add(
        Polyline(
          polylineId: PolylineId(id),
          points: state.polyline,
          color:
              id == 'route' ? context.colors.primary : const Color(0xff598527),
          width: 6,
        ),
      );
    }
  }
}
