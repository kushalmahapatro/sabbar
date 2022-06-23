import 'package:sabbar/features/map/map.dart';
import 'package:sabbar/sabbar.dart';

class Pointer extends StatelessWidget {
  const Pointer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      height: 58,
      width: 58,
      margin: const EdgeInsets.only(bottom: 120),
      child: BlocBuilder<MapBloc, FetchResult>(builder: ((context, state) {
        if (state is MapResult) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Material(
                    elevation: 6,
                    color: state.color,
                    animationDuration: const Duration(milliseconds: 100),
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      alignment: Alignment.bottomCenter,
                      curve: Curves.easeInOutExpo,
                      width: state.size,
                      height: state.size,
                    ),
                  ),
                  AnimatedOpacity(
                      duration: const Duration(milliseconds: 100),
                      opacity: state.size == 40 ? 1 : 0,
                      child:
                          Container(color: state.color, width: 3, height: 18))
                ],
              ),
              Positioned(
                bottom: 0,
                child: Material(
                  elevation: 6,
                  color: state.color,
                  animationDuration: const Duration(milliseconds: 100),
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    width: 10,
                    height: 10,
                  ),
                ),
              ),
            ],
          );
        }
        return const SizedBox();
      })),
    ));
  }
}
