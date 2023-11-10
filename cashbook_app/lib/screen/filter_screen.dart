import 'package:cashbook_app/screen_provider/filter_screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilterScreen extends StatelessWidget {
  static const routeName = '/FilterScreen';

  const FilterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Row(
        children: [
          SizedBox(
            width: 132,
            child: Column(
              children: [
                FilterPartsIcons(
                  count: 1.toString(),
                  isChanged: true,
                  onTap: () {
                    print("objectzzle");
                  },
                  title: Provider.of<FilterScreenProvider>(context).dateValue,
                ),
                const Divider(
                  height: 0.6,
                  color: Colors.black,
                  indent: 0,
                  endIndent: 0,
                )
              ],
            ),
          ),
          const VerticalDivider(
            width: 0.6,
            indent: 0,
            endIndent: 0,
            color: Colors.black,
          ),
          const Expanded(
              child: Column(
            children: [],
          ))
        ],
      ),
    );
  }
}

class FilterPartsIcons extends StatelessWidget {
  FilterPartsIcons({
    super.key,
    required this.onTap,
    required this.title,
    required this.count,
    required this.isChanged,
  });
  final String title;
  final String count;
  final bool isChanged;
  Function onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      splashColor: Theme.of(context).primaryColorLight,
      child: SizedBox(
        height: 52,
        child: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.labelMedium,
              ),
              isChanged
                  ? Row(
                      children: [
                        Text(
                          count,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(
                                  color: Theme.of(context).indicatorColor),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).indicatorColor,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(5),
                                bottomLeft: Radius.circular(5)),
                          ),
                          height: 52,
                          width: 4,
                        )
                      ],
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
