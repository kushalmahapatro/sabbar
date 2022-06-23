import 'package:sabbar/sabbar.dart';
import 'package:timeline_tile/timeline_tile.dart';

class TimeLineTrack extends StatelessWidget {
  const TimeLineTrack({
    Key? key,
    required this.step,
    required this.text,
    required this.check,
  }) : super(key: key);

  final int step;
  final String text;
  final int check;

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      alignment: TimelineAlign.start,
      endChild: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15),
          height: check == 5 ? 50 : 40,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(text,
                  style: (check == 5 ? step == check : step > check)
                      ? context.titleMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.colors.primary)
                      : context.bodyMedium),
            ],
          )),
      isLast: check == 5,
      isFirst: check == 0,
      indicatorStyle: IndicatorStyle(
          color: (check == 5 ? step == check : step > check)
              ? context.colors.primary
              : Colors.black),
      beforeLineStyle: LineStyle(
          color: (check == 5 ? step == check : step > check)
              ? context.colors.primary
              : Colors.black),
      afterLineStyle: LineStyle(
          color: (check == 5 ? step == check : step > check)
              ? context.colors.primary
              : Colors.black),
    );
  }
}
