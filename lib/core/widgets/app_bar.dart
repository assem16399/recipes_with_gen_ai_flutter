import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:recipes_with_gen_ai/core/styles/theme.dart';
import 'package:recipes_with_gen_ai/core/utils/extensions.dart';
import 'package:recipes_with_gen_ai/core/widgets/app_bar_shape_border.dart';
import 'package:recipes_with_gen_ai/core/widgets/app_info_dialog.dart';

class AnimatedAppBar extends StatelessWidget {
  const AnimatedAppBar({
    required this.scrollController,
    required this.textStyle,
    required this.tabController,
    super.key,
  });

  final ScrollController scrollController;
  double get collapsedHeight => 100;
  double get expandedHeight => 300;
  double get avatarSize => 50;
  final TextStyle textStyle;
  final TabController tabController;

  String get headerText {
    return switch (tabController.index) {
      0 => 'Create a recipe',
      1 => 'Saved recipes',
      2 => 'Settings',
      _ => 'Uh oh!',
    };
  }

  String get helperText {
    return switch (tabController.index) {
      0 => "Tell me what ingredients you have and what you're feeling', "
          "and I'll create a recipe for you!",
      1 => 'These are all my saved recipes created by Chef Noodle.',
      2 => 'Settings',
      _ => 'Uh oh!',
    };
  }

  @override
  Widget build(BuildContext context) {
    return SliverLayoutBuilder(
      builder: (context, constraints) {
        return SliverAppBar(
          automaticallyImplyLeading: false,
          pinned: true,
          forceElevated: true,
          elevation: 2,
          shadowColor: Colors.black,
          expandedHeight: expandedHeight,
          collapsedHeight: collapsedHeight,
          backgroundColor: Theme.of(context).primaryColor,
          shape: const AppBarShapeBorder(50),
          title: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: avatarSize,
                    height: avatarSize,
                    child: SvgPicture.asset(
                      'assets/chef_cat.svg',
                      semanticsLabel: 'Chef cat icon',
                    ),
                  ),
                  const SizedBox(
                    width: AppTheme.spacing1,
                  ),
                  if (scrollController.positions.isNotEmpty &&
                      scrollController.offset < 200)
                    Text(
                      "Aloha! Let's get cooking!",
                      style: AppTheme.heading3,
                    ),
                  if (scrollController.positions.isNotEmpty &&
                      scrollController.offset > 200)
                    Text(
                      headerText,
                      style: AppTheme.heading3,
                    ),
                  const Spacer(),
                  if (scrollController.positions.isNotEmpty &&
                      scrollController.offset > 200)
                    IconButton(
                      onPressed: () => showDialog<void>(
                        context: context,
                        builder: (context) => const AppInfoDialog(),
                      ),
                      icon: const Icon(
                        Symbols.info,
                        color: Colors.black12,
                      ),
                    ),
                ],
              ),
            ],
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: Padding(
              padding: const EdgeInsets.all(AppTheme.spacing4),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Text(
                        helperText,
                        style: constraints.isMobile
                            ? AppTheme.subheading2
                            : AppTheme.subheading1,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        showDialog<void>(
                          context: context,
                          builder: (context) => const AppInfoDialog(),
                        );
                      },
                      icon: const Icon(
                        Symbols.info,
                        color: Colors.black12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size(double.infinity, 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(
                  left: constraints.isMobile
                      ? AppTheme.spacing2
                      : AppTheme.spacing1,
                ),
                child: AnimatedDefaultTextStyle(
                  duration: Duration.zero,
                  style: textStyle,
                  child: Text(
                    headerText,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
