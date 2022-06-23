import 'package:sabbar/features/places/places.dart';
import 'package:sabbar/features/search/search.dart';
import 'package:sabbar/sabbar.dart';

class PlaceListView extends StatefulWidget {
  const PlaceListView({
    required this.controller,
    required this.scrollController,
    required this.pickType,
    super.key,
  });

  final DraggableScrollableController controller;
  final ScrollController scrollController;
  final PickType pickType;

  @override
  State<PlaceListView> createState() => _PlaceListViewState();
}

class _PlaceListViewState extends State<PlaceListView> {
  @override
  void initState() {
    widget.controller.addListener(() {
      if (widget.controller.size > 0.7) {
        var res = context.read<PlacesBloc>().state;
        context.read<PlacesBloc>().add(
              LoadPlaceAction(
                  value: '',
                  uiType: UiType.expanded,
                  suggestions: res?.suggestions),
            );
      } else if (widget.controller.size < 0.5) {
        context.read<PlacesBloc>().add(
              const LoadPlaceAction(
                value: '',
                uiType: UiType.collapsed,
              ),
            );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<PlacesBloc, FetchLoadPlaceResult?>(
            buildWhen: (previous, current) {
          return previous?.uiType != current?.uiType;
        }, builder: (context, fetchResult) {
          if (fetchResult?.uiType == UiType.expanded) {
            return Container(
              margin: const EdgeInsets.only(bottom: 15),
              child: GestureDetector(
                onTap: () {
                  widget.controller.animateTo(0.27,
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.easeIn);
                },
                child: const Icon(Icons.keyboard_arrow_down)
                    .circularButton(context),
              ),
            );
          }
          return const SizedBox();
        }),

        /// Search View
        BlocBuilder<PlacesBloc, FetchLoadPlaceResult?>(
            buildWhen: (previous, current) {
          return previous?.uiType != current?.uiType;
        }, builder: (context, fetchResult) {
          if (fetchResult?.uiType == UiType.expanded) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: SearchView(
                widget.pickType,
                onChanged: (value) {
                  context.read<PlacesBloc>().add(
                      LoadPlaceAction(value: value, uiType: UiType.expanded));
                },
              ),
            );
          }
          return const SizedBox();
        }),

        /// Builder

        Expanded(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            controller: widget.scrollController,
            child: BlocBuilder<PlacesBloc, FetchLoadPlaceResult?>(
              buildWhen: (previous, current) {
                return previous?.suggestions != current?.suggestions ||
                    previous?.uiType != current?.uiType;
              },
              builder: (context, fetchResult) {
                final suggestions = fetchResult?.suggestions;
                if (suggestions == null || suggestions.isEmpty) {
                  if (fetchResult?.uiType == UiType.expanded) {
                    /// Empty view
                    return EmptyView(widget.controller, widget.pickType);
                  } else {
                    return PickupLocationView(
                      pickType: widget.pickType,
                      onTap: () {
                        widget.controller.animateTo(0.9,
                            duration: const Duration(milliseconds: 100),
                            curve: Curves.easeIn);
                      },
                    );
                  }
                } else {
                  if (fetchResult?.uiType == UiType.collapsed) {
                    return PickupLocationView(
                      pickType: widget.pickType,
                      onTap: () {
                        widget.controller.animateTo(0.9,
                            duration: const Duration(milliseconds: 100),
                            curve: Curves.easeIn);
                      },
                    );
                  } else {
                    return Column(
                      children: List.generate(
                        suggestions.length,
                        (index) {
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin:
                                      const EdgeInsets.only(top: 8, bottom: 4),
                                  child: Text((suggestions[index]).title,
                                      style: context.titleMedium!.copyWith(
                                          fontWeight: FontWeight.bold)),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.only(top: 4, bottom: 8),
                                  child: Text((suggestions[index]).description,
                                      style: context.titleSmall!.copyWith(
                                          color: context.colors.onSurface)),
                                ),
                              ],
                            ),
                            leading: Container(
                              margin: const EdgeInsets.only(right: 10),
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                  color:
                                      context.colors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(25)),
                              child: Icon(
                                Icons.location_pin,
                                size: 35,
                                color: context.colors.primary,
                              ),
                            ),
                            onTap: () {
                              widget.controller.animateTo(0.27,
                                  duration: const Duration(milliseconds: 100),
                                  curve: Curves.easeIn);

                              context.read<CurrentPlaceBloc>().add(
                                  LocationAction(
                                      context: context,
                                      placeId: suggestions[index].placeId));
                            },
                          );
                        },
                      ),
                    );
                  }
                }
              },
            ),
          ),
        )
      ],
    );
  }
}
