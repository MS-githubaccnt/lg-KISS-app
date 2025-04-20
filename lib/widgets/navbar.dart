import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Navbar extends StatelessWidget{
  final int selectedIndex;
  const Navbar({super.key,required this.selectedIndex});
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: (index){
        switch(index){
          case 0:
            context.replace('/home');
            break;
          case 1:
            context.go('/settings');
            break;
        }
      },
      items: const[
        BottomNavigationBarItem(icon:Icon(
          Icons.home
        ),
        label:"Home"),
        BottomNavigationBarItem(icon:Icon(
          Icons.settings
        ),
        label:"Settings")
      ]);
  }
}