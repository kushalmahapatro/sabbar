import 'package:sabbar/features/route_preview/route_preview.dart';
import 'package:sabbar/sabbar.dart';

class MarkerDetails extends StatelessWidget {
  const MarkerDetails(
    this.type, {
    required this.pickupAddress,
    required this.loc,
    Key? key,
  }) : super(key: key);

  final String pickupAddress;
  final LatLng loc;
  final String type;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: BlocBuilder<BottomBloc, FetchResult>(
        builder: ((context, state) {
          String address = '';
          if (state is PlaceSelectedResult) {
            address = state.address;
          }
          return Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(
                color: address == pickupAddress
                    ? context.colors.primary
                    : Colors.transparent,
              ),
              color: address == pickupAddress
                  ? context.colors.primary.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$type Location',
                  style: context.titleMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () {
                    context
                        .read<PreviewMapBloc>()
                        .add(MoveToMarkerAction(marker: loc));
                    context
                        .read<BottomBloc>()
                        .add(PlaceSelectedAction(address: pickupAddress));
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Flexible(
                          flex: 2,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                color: const Color(0xff598527).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(25)),
                            child: Image.asset(
                              "assets/images/${type.toLowerCase()}.png",
                              width: 35,
                              height: 35,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 6,
                          child: Text(
                            pickupAddress,
                            maxLines: 2,
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
