import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:sabbar/sabbar.dart';

class TripCompleteWidget extends StatelessWidget {
  const TripCompleteWidget({
    Key? key,
    required this.time,
    required this.marker,
  }) : super(key: key);

  final Map<String, DateTime> time;
  final Marker marker;

  @override
  Widget build(BuildContext context) {
    List<Widget> t = [];
    time.forEach((key, value) {
      t.add(Container(
          margin: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                key,
                style:
                    context.titleMedium!.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(DateFormat.Hms().format(value),
                  style: context.titleMedium!
                      .copyWith(color: context.colors.primary))
            ],
          )));
    });
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
              const SizedBox(
                height: 10,
              ),
              RatingBar.builder(
                initialRating: 3,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) =>
                    Icon(Icons.star, color: context.colors.primary),
                onRatingUpdate: (rating) {},
              )
            ],
          ),
        ],
      ),
      const SizedBox(
        height: 20,
      ),
      ...t,
      const SizedBox(height: 20),
      GestureDetector(
        onTap: () {},
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15),
          width: double.maxFinite,
          height: 50,
          child: Material(
            elevation: 3,
            color: context.colors.primary,
            borderRadius: BorderRadius.circular(30),
            child: Center(
                child: Text(
              "Submit",
              style: TextStyle(
                  color: context.colors.background,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            )),
          ),
        ),
      )
    ]);
  }
}
