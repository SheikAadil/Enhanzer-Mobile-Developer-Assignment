import 'package:flutter/material.dart';
import 'package:mobile_developer_assignment/Widgets/TabBarItem.dart';

class CustomTabBar extends StatelessWidget {
  final TabController tabController;
  final List<TabBarItem> tabs;

  const CustomTabBar({
    super.key,
    required this.tabController,
    required this.tabs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        color: Colors.white,
        border: Border.all(
          color: Colors.blue.shade900,
          width: 3,
        ),
      ),
      child: TabBar(
        controller: tabController,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        indicator: BoxDecoration(
          color: Colors.blue.shade900,
          borderRadius: tabController.index == 0
              ? const BorderRadius.only(
                  topLeft: Radius.circular(2),
                  bottomLeft: Radius.circular(2),
                )
              : const BorderRadius.only(
                  topRight: Radius.circular(2),
                  bottomRight: Radius.circular(2),
                ),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.blue.shade900,
        tabs: tabs,
      ),
    );
  }
}
