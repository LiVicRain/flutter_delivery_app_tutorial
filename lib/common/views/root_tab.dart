import 'package:delivery_app_tutorial/common/constants/colors.dart';
import 'package:delivery_app_tutorial/common/layouts/default_layout.dart';
import 'package:delivery_app_tutorial/restaurant/views/restaurant_screen.dart';
import 'package:flutter/material.dart';

class RootTab extends StatefulWidget {
  const RootTab({super.key});

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> with SingleTickerProviderStateMixin {
  late TabController _controller;
  int currentTab = 0;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 4, vsync: this);
    // vsync 렌더링 엔진에서 필요하다
    // 현재 컨트롤러를 선언하는 State를 넣어주면 된다
    // 그런데 this(State)가 특정 기능을 갖고 있어야 한다
    // 이때는 State 에 SingleTickerProviderStateMixin 를 넣어줘야 한다
    _controller.addListener(tabListener);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void tabListener() {
    setState(() {
      currentTab = _controller.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '딜리버리',
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _controller,
        children: [
          RestaurantScreen(),
          Center(child: Text("음식")),
          Center(child: Text("주문")),
          Center(child: Text("프로필")),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: uPrimaryColor,
        unselectedItemColor: uFontBodyColor,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          _controller.animateTo(index);
        },
        currentIndex: currentTab,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: "홈",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood_outlined),
            label: '음식',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            label: '주문',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: '프로필',
          ),
        ],
      ),
    );
  }
}
