import 'package:flutter/material.dart';
import 'package:kb_shop_admin/consts/constants.dart';
import 'package:kb_shop_admin/responsive.dart';
// import 'package:kb_shop_admin/services/utils.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({
    super.key,
    required this.fct,
    required this.title,
    this.isAllowSearch = true,
  });

  final Function fct;
  final String title;
  final bool isAllowSearch;

  @override
  Widget build(BuildContext context) {
    // final theme = Utils(context).getTheme;
    // final color = Utils(context).color;

    return Row(
      children: [
        if (!Responsive.isDesktop(context))
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              fct();
            },
          ),
        if (Responsive.isDesktop(context))
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          ),
        if (Responsive.isDesktop(context)) Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
        isAllowSearch
            ? Expanded(
                child: TextField(
                  style: TextStyle(color: Theme.of(context).colorScheme.onBackground),
                  decoration: InputDecoration(
                    hintText: "Search",
                    fillColor: Theme.of(context).primaryColor.withOpacity(0.15),
                    filled: true,
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    suffixIcon: InkWell(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.all(defaultPadding * 0.75),
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Icon(
                          Icons.search,
                          size: 25,
                          color: Theme.of(context).colorScheme.background,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
