/*
import 'package:flutter/material.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String selectedPage;
  final VoidCallback openDrawer;

  const MyAppBar({
    Key? key,
    required this.selectedPage,
    required this.openDrawer,
  }) : super(key: key);

  @override
  State<MyAppBar> createState() => _MyAppBarState();

  @override // PreferredSizeWidget를 사용하기 위해 정의
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _MyAppBarState extends State<MyAppBar> {
  void _openDrawer() {
    widget.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xff9DD7DD),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      centerTitle: true, // 중앙 정렬

      title: Column(
        children: [
          const Text(
            '부자 친구',
            style: TextStyle(fontSize: 20),
          ),
          Text(
            widget.selectedPage, // 현재 선택된 페이지 이름을 표시
            style: const TextStyle(fontSize: 10),
          ),
        ],
      ),

      // AppBar에 있는 사이드바 Drawer 메뉴
      actions: [
        GestureDetector(
          onTap: _openDrawer,
          child: const Row(
            children: [
              Icon(
                Icons.menu,
              ),
              SizedBox(width: 10),
            ],
          ),
        ),
      ],
    );
  }
}
*/