import 'package:sabbar/features/route_preview/route_preview.dart';
import 'package:sabbar/sabbar.dart';

class RoutePreviewScreen extends StatelessWidget {
  const RoutePreviewScreen(
      {required this.pickupLocation,
      required this.dropoffLocation,
      required this.pickupAddress,
      required this.dropoffAddress,
      Key? key})
      : super(key: key);
  final LatLng pickupLocation;
  final LatLng dropoffLocation;
  final String pickupAddress;
  final String dropoffAddress;

  @override
  Widget build(BuildContext context) {
    context.read<BottomBloc>().add(PlaceSelectedAction(address: pickupAddress));

    return Scaffold(
      body: Stack(
        children: [
          /// Map view
          RoutePreviewMapView(
            pickupLocation: pickupLocation,
            dropoffLocation: dropoffLocation,
          ),

          DraggableScrollableSheet(
              initialChildSize: 0.4,
              minChildSize: 0.4,
              maxChildSize: 0.4,
              builder: (ctx, controller) {
                return Material(
                  elevation: 5,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                  child: BottomWidget(
                    pickupAddress: pickupAddress,
                    dropoffAddress: dropoffAddress,
                    pickupLocation: pickupLocation,
                    dropoffLocation: dropoffLocation,
                  ),
                );
              }),

          GestureDetector(
              onTap: () {
                context.pop();
              },
              child: Padding(
                padding: const EdgeInsets.only(top: kToolbarHeight, left: 15),
                child: const Icon(
                  Icons.keyboard_arrow_left,
                  size: 30,
                ).circularButton(context, size: 50),
              )),
        ],
      ),
    );
  }
}
