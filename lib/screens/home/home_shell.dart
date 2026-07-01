import 'package:flutter/material.dart';

class HomeShell extends StatefulWidget {
    @override
    State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
    int _selectedIndex = 0;

    final List<Widget> _screens = [
        Center(child: Text('Notice Board')),
        Center(child: Text('Social Feed')),
        Center(child: Text('Study Hub')),
    ];

    @override
Widget build(BuildContext context) {
  return Scaffold(
    body: _screens[_selectedIndex],
    bottomNavigationBar: BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.announcement),
          label: 'Notices',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: 'Social',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu_book),
          label: 'Study Hub',
        ),
      ],
    ),
  );
}
}