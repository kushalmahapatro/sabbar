import 'package:sabbar/features/route_preview/route_preview.dart';
import 'package:sabbar/sabbar.dart';
import 'package:intl/intl.dart';

class BottomWidget extends StatelessWidget {
  const BottomWidget({
    Key? key,
    required this.pickupAddress,
    required this.dropoffAddress,
    required this.pickupLocation,
    required this.dropoffLocation,
  }) : super(key: key);

  final String pickupAddress;
  final String dropoffAddress;
  final LatLng pickupLocation;
  final LatLng dropoffLocation;

  @override
  Widget build(BuildContext context) {
    Marker marker = const Marker(markerId: MarkerId(''));
    TripStatus status = TripStatus.notSarted;
    int step = 1;
    Map<String, DateTime> time = {};

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.6),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
            ),
          ),
          const SizedBox(height: 20),
          BlocBuilder<TripBloc, FetchResult>(builder: ((ctx, state) {
            if (state is TripChangeResult) {
              status = state.status;
              if (status == TripStatus.started) {
                time['Start Time'] = state.startTime!;
              } else if (status == TripStatus.pickup) {
                time['Pick Time'] = state.pickTime!;
              } else if (status == TripStatus.delivered) {
                time['Drop Time'] = state.dropTime!;
              }
            }
            if (status == TripStatus.notSarted) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        MarkerDetails(
                            pickupAddress: pickupAddress,
                            loc: pickupLocation,
                            "Pickup"),
                        const SizedBox(width: 15),
                        MarkerDetails(
                            pickupAddress: dropoffAddress,
                            loc: dropoffLocation,
                            "Dropoff"),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      "Available Drivers",
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const AvailableDrivers(),
                  const SizedBox(
                    height: 20,
                  ),
                  BlocBuilder<BottomBloc, FetchResult>(builder: ((ctx, state) {
                    if (state is DriverSelectedResult) {
                      marker = state.marker;
                    }
                    return GestureDetector(
                      onTap: () {
                        if (marker.markerId.value.isNotEmpty) {
                          context.read<PreviewMapBloc>().add(
                              PickupPolylineAction(
                                  pickup: marker.position,
                                  dropOff: pickupLocation));
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        width: double.maxFinite,
                        height: 50,
                        child: Material(
                          elevation: 3,
                          color: marker.markerId.value.isNotEmpty
                              ? context.colors.primary
                              : context.colors.surfaceVariant.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(30),
                          child: Center(
                              child: Text(
                            "Confirm",
                            style: TextStyle(
                                color: context.colors.background,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          )),
                        ),
                      ),
                    );
                  })),
                ],
              );
            } else if (status == TripStatus.complete) {
              return TripCompleteWidget(time: time, marker: marker);
            } else {
              if (status == TripStatus.reached) {
                step = 2;
              } else if (status == TripStatus.pickup) {
                step = 3;
              } else if (status == TripStatus.onway) {
                step = 4;
              } else if (status == TripStatus.delivered) {
                step = 5;
              }
              List<String> t = [];
              time.forEach((key, value) {
                t.add('$key : ${DateFormat.Hms().format(value)}');
              });

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            color: context.colors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(40)),
                        child: Image.asset(
                          "assets/images/truck1.png",
                          width: 40,
                          height: 40,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            marker.infoWindow.title ?? '',
                            style: context.titleLarge,
                          ),
                          SizedBox(
                            width: context.size!.width * 0.7,
                            child: Text(
                              t.join(', '),
                              maxLines: 3,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(children: [
                        TimeLineTrack(
                            step: step,
                            check: 0,
                            text: 'Driver on way to pickup location'),
                        TimeLineTrack(
                            step: step,
                            check: 1,
                            text: 'Driver reached to pickup location'),
                        TimeLineTrack(
                            step: step,
                            check: 2,
                            text: 'Item was picked up by driver'),
                        TimeLineTrack(
                            step: step,
                            check: 3,
                            text: 'Driver on way to Dopoff location'),
                        TimeLineTrack(
                            step: step,
                            check: 5,
                            text:
                                'Driver reached the dropoff location and item was delivered'),
                      ]))
                ],
              );
            }
          }))
        ]);
  }
}
