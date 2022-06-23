import 'package:sabbar/features/route_preview/route_preview.dart';
import 'package:sabbar/sabbar.dart';

class AvailableDrivers extends StatelessWidget {
  const AvailableDrivers({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Marker> drivers = [];

    return BlocBuilder<PreviewMapBloc, FetchResult>(
      builder: ((context, state) {
        if (state is NearbyDriverResult) {
          drivers
            ..clear()
            ..addAll(state.drivers);
        }

        if (drivers.isNotEmpty) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                drivers.length,
                (index) => GestureDetector(
                  onTap: () {
                    context.read<PreviewMapBloc>().add(
                        MoveToMarkerAction(marker: drivers[index].position));
                    context
                        .read<BottomBloc>()
                        .add(DriverSelectedAction(marker: drivers[index]));
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BlocBuilder<BottomBloc, FetchResult>(
                          builder: ((context, state) {
                        String id = '';
                        if (state is DriverSelectedResult) {
                          id = state.marker.markerId.value;
                        }
                        return Container(
                          padding: const EdgeInsets.all(7),
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                              color: context.colors.primary.withOpacity(
                                  id == drivers[index].markerId.value
                                      ? 1
                                      : 0.1),
                              borderRadius: BorderRadius.circular(30)),
                          child: Image.asset(
                            "assets/images/truck1.png",
                            width: 35,
                            height: 35,
                          ),
                        );
                      })),
                      const SizedBox(
                        height: 8,
                      ),
                      Center(
                        child: Text(
                          drivers[index].infoWindow.title ?? '',
                          textAlign: TextAlign.center,
                          style: context.bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          return ShimmerDriver(context: context);
        }
      }),
    );
  }
}
