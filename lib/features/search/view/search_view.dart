import 'package:sabbar/features/places/presenter/presenter.dart';
import 'package:sabbar/sabbar.dart';

class SearchView extends StatelessWidget {
  const SearchView(this.pickType, {this.onChanged, this.onTap, Key? key})
      : super(key: key);

  final void Function(String value)? onChanged;
  final void Function()? onTap;
  final PickType pickType;

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    String hint = "Enter your pick up location";
    if (pickType == PickType.dropoff) {
      hint = "Enter your dropoff location";
    }
    return Center(
      child: TextField(
        onTap: onTap,
        controller: controller,
        onChanged: onChanged,
        style: const TextStyle(fontSize: 18),
        decoration: InputDecoration(
            focusedBorder: InputBorder.none,
            border: InputBorder.none,
            hintText: hint,
            prefixIcon: const Icon(Icons.search)),
      ),
    ).circularBorder(context);
  }
}
