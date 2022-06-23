import 'package:sabbar/sabbar.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerDriver extends StatelessWidget {
  const ShimmerDriver({
    Key? key,
    required this.context,
  }) : super(key: key);

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.colors.primary,
      highlightColor: context.colors.tertiary,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            3,
            (index) => Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      color: context.colors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30)),
                ),
                const SizedBox(
                  height: 8,
                ),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                        color: context.colors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(25)),
                    width: 50,
                    height: 16,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
