import 'package:sabbar/features/map/view/view.dart';
import 'package:sabbar/features/places/places.dart';
import 'package:sabbar/sabbar.dart';

class PickLocationScreen extends StatefulWidget {
  const PickLocationScreen({required this.pickType, Key? key})
      : super(key: key);

  final PickType pickType;

  @override
  State<PickLocationScreen> createState() => _PickLocationScreenState();
}

class _PickLocationScreenState extends State<PickLocationScreen> {
  bool initial = true;

  late DraggableScrollableController _dcontroller;
  @override
  void initState() {
    _dcontroller = DraggableScrollableController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// Map view
          MapView(widget.pickType),

          DraggableScrollableSheet(
              initialChildSize: 0.25,
              minChildSize: 0.25,
              maxChildSize: 0.82,
              controller: _dcontroller,
              builder: (ctx, controller) {
                return Material(
                  elevation: 5,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(children: <Widget>[
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.6),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: PlaceListView(
                            pickType: widget.pickType,
                            controller: _dcontroller,
                            scrollController: controller),
                      ),
                    ]),
                  ),
                );
              }),

          if (widget.pickType == PickType.dropoff)
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
