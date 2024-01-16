/*
import 'package:flutter/material.dart';

class DrawerContent extends StatelessWidget {
  final Function(String) navigateToPage;

  const DrawerContent({super.key, required this.navigateToPage});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // 메뉴 Header
          SizedBox(
            height: 175,
            child: DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xff9DD7DD), // Drawer 사이드 바의 배경색
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '사용자 님',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context); // 아이콘을 누르면 사이드바 닫기
                        },
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10), // 밑줄 아래 여백
                    height: 1,
                    color: Colors.white,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.home),
                        onPressed: () {
                          navigateToPage('Home');
                        },
                        color: Colors.white,
                      ),
                      IconButton(
                        icon: const Icon(Icons.person),
                        onPressed: () {
                          navigateToPage('내 정보');
                        },
                        color: Colors.white,
                      ),
                      IconButton(
                        icon: const Icon(Icons.mail),
                        onPressed: () {
                          navigateToPage('건의사항');
                        },
                        color: Colors.white,
                      ),
                      IconButton(
                        icon: const Icon(Icons.settings),
                        onPressed: () {
                          navigateToPage('설정');
                        },
                        color: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          ExpansionTile(
            title: const Text('자산 계산기'),
            children: [
              ListTile(
                title: const Text('은퇴계산기'),
                onTap: () {
                  navigateToPage('은퇴계산기');
                },
              ),
              ListTile(
                title: const Text('부자계산기'),
                onTap: () {
                  navigateToPage('부자계산기');
                },
              ),
              ListTile(
                title: const Text('복리 계산기'),
                onTap: () {
                  navigateToPage('복리 계산기');
                },
              ),
            ],
          ),
          ExpansionTile(
            title: const Text('개인연금'),
            children: [
              ListTile(
                title: const Text('개인연금 종류'),
                onTap: () {
                  navigateToPage('개인연금 종류');
                },
              ),
              ListTile(
                title: const Text('개인연금 꿀팁'),
                onTap: () {
                  navigateToPage('개인연금 꿀팁');
                },
              ),
              ListTile(
                title: const Text('개인연금 효율'),
                onTap: () {
                  navigateToPage('개인연금 효율');
                },
              ),
            ],
          ),
          ExpansionTile(
            title: const Text('국민연금'),
            children: [
              ListTile(
                title: const Text('국민연금 수령액'),
                onTap: () {
                  navigateToPage('국민연금 수령액');
                },
              ),
              ListTile(
                title: const Text('국민연금 개편 내용'),
                onTap: () {
                  navigateToPage('국민연금 개편 내용');
                },
              ),
            ],
          ),
          ExpansionTile(
            title: const Text('유용한 정보'),
            children: [
              ListTile(
                title: const Text('세금 2023'),
                onTap: () {
                  navigateToPage('세금 2023');
                },
              ),
              ListTile(
                title: const Text('세액공제'),
                onTap: () {
                  navigateToPage('세액공제');
                },
              ),
              ListTile(
                title: const Text('연말정산'),
                onTap: () {
                  navigateToPage('연말정산');
                },
              ),
              ListTile(
                title: const Text('물가상승률'),
                onTap: () {
                  navigateToPage('물가상승률');
                },
              ),
              ListTile(
                title: const Text('복리의 중요성'),
                onTap: () {
                  navigateToPage('복리의 중요성');
                },
              ),
            ],
          ),
          ListTile(
            title: const Text('커뮤니티'),
            onTap: () {
              navigateToPage('커뮤니티');
            },
          ),
        ],
      ),
    );
  }
}
*/