import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomNav extends StatefulWidget {
  final int currentIndex;
  final Function(int)? onTap;

  const BottomNav({super.key, required this.currentIndex, this.onTap});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  final List<String> menuIcons = [
    'assets/icons/home.svg',
    'assets/icons/channelList.svg',
    'assets/icons/tvRating.svg',
    'assets/icons/socialRanking.svg',
  ];

  @override
  Widget build(BuildContext context) {
    final navColor = Theme.of(context).colorScheme.secondary;

    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: navColor,
      ),
      child: BottomAppBar(
        height: 60,
        color: navColor,
        elevation: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(menuIcons.length, (index) {
            return _buildNavItem(index);
          }),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    return GestureDetector(
      onTap: () {
        if (index != widget.currentIndex && widget.onTap != null) {
          widget.onTap!(index);
        }
      },
      child: SizedBox(
        height: 50,
        width: 60,
        child: Center(
          child: SvgPicture.asset(
            menuIcons[index],
            height: 28,
            width: 28,
            colorFilter: widget.currentIndex == index
                ? const ColorFilter.mode(Colors.white, BlendMode.srcIn)
                : const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
          ),
        ),
      ),
    );
  }
}
