import 'package:sabbar/features/places/presenter/presenter.dart';
import 'package:sabbar/sabbar.dart';

class EmptyView extends StatelessWidget {
  const EmptyView(this.controller, this.pickType, {Key? key}) : super(key: key);

  final DraggableScrollableController controller;
  final PickType pickType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
              color: context.colors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(25)),
          child: Icon(
            Icons.search,
            size: 35,
            color: context.colors.primary,
          ),
        ),
        const SizedBox(height: 40),
        Text(
          pickType == PickType.pickup
              ? "Your pickup location?"
              : "Your dropoff location?",
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          "Enter your desitnation in the search area above to find your location.",
          textAlign: TextAlign.center,
          style: TextStyle(color: context.colors.onSurfaceVariant),
        ),
        const SizedBox(height: 40),
        GestureDetector(
          onTap: () {
            controller.animateTo(0.27,
                duration: const Duration(milliseconds: 100),
                curve: Curves.easeIn);
          },
          child: Center(
              child: Text(
            "Select location on map",
            style: TextStyle(
                color: context.colors.onPrimary,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          )).circularBorder(context, color: context.colors.primary),
        )
      ],
    );
  }
}
