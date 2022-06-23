import 'package:sabbar/features/places/places.dart';
import 'package:sabbar/features/search/view/search_view.dart';
import 'package:sabbar/sabbar.dart';
import 'package:shimmer/shimmer.dart';

class PickupLocationView extends StatelessWidget {
  const PickupLocationView({
    required this.pickType,
    this.onTap,
    Key? key,
  }) : super(key: key);

  final void Function()? onTap;
  final PickType pickType;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentPlaceBloc, FetchSelectPlaceResult?>(
      builder: ((context, state) {
        switch (pickType) {
          case PickType.pickup:
            return LocationWidget(
              state?.pickupData ?? LocationData(),
              "Pickup",
              pickType,
              onTap: onTap,
            );

          case PickType.dropoff:
            return LocationWidget(
              state?.dropoffData ?? LocationData(),
              "Dropoff",
              pickType,
              onTap: onTap,
            );
        }
      }),
    );
  }
}

class LocationWidget extends StatelessWidget {
  const LocationWidget(this.data, this.title, this.pickType,
      {this.onTap, Key? key})
      : super(key: key);

  final LocationData data;
  final String title;
  final void Function()? onTap;
  final PickType pickType;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: <Widget>[
            Text(
              "$title Location?",
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const Spacer(),
          ],
        ),
        const SizedBox(height: 18),
        if (data.lat == '0' && !data.loading)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: SearchView(pickType, onTap: onTap),
          )
        else if (!data.loading)
          Row(
            children: <Widget>[
              Flexible(
                flex: 2,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      color: context.colors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(25)),
                  child: Icon(
                    Icons.location_pin,
                    size: 35,
                    color: context.colors.primary,
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Flexible(
                  flex: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.address[0],
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        data.address.getRange(1, 2).join(','),
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.grey),
                      )
                    ],
                  )),
              const Spacer(),
            ],
          )
        else
          Shimmer.fromColors(
            baseColor: context.colors.primary,
            highlightColor: context.colors.tertiary,
            child: Row(
              children: <Widget>[
                Flexible(
                  flex: 2,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        color: context.colors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(25)),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Flexible(
                    flex: 8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: context.colors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(25)),
                          width: 100,
                          height: 16,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                              color: context.colors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(25)),
                          width: 200,
                          height: 16,
                        )
                      ],
                    )),
                const Spacer(),
              ],
            ),
          ),
        const SizedBox(
          height: 10,
        ),
        if (!data.initial)
          GestureDetector(
            onTap: () {
              if (!data.loading && title.toLowerCase() == "pickup") {
                context.pushNamed('dropoff');
              } else {
                LatLng? pickupLocation;
                LatLng? dropoffLocation;
                LocationData pl =
                    context.read<CurrentPlaceBloc>().state?.pickupData ??
                        LocationData();
                LocationData dl =
                    context.read<CurrentPlaceBloc>().state?.dropoffData ??
                        LocationData();
                if (pl.lat != '0') {
                  double lat = double.tryParse(pl.lat) ?? 0;
                  double lng = double.tryParse(pl.lng) ?? 0;
                  pickupLocation = LatLng(lat, lng);
                }
                if (dl.lat != '0') {
                  double lat = double.tryParse(dl.lat) ?? 0;
                  double lng = double.tryParse(dl.lng) ?? 0;
                  dropoffLocation = LatLng(lat, lng);
                }

                context.pushNamed('route', extra: <String, dynamic>{
                  'pickupLocation': pickupLocation,
                  'dropoffLocation': dropoffLocation,
                  'pickupAddress': pl.address.join(','),
                  'dropoffAddress': dl.address.join(',')
                });
              }
            },
            child: SizedBox(
              width: double.maxFinite,
              height: 50,
              child: Material(
                elevation: 3,
                color: context.colors.primary,
                borderRadius: BorderRadius.circular(30),
                child: Center(
                    child: data.loading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: context.colors.background,
                            ),
                          )
                        : Text(
                            "Confirm $title",
                            style: TextStyle(
                                color: context.colors.background,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          )),
              ),
            ),
          )
      ],
    );
  }
}
