import 'package:flutter/material.dart';

class ResponsiveScaffold extends StatefulWidget {
  const ResponsiveScaffold({super.key});

  @override
  State<ResponsiveScaffold> createState() => _ResponsiveScaffoldState();
}

class _ResponsiveScaffoldState extends State<ResponsiveScaffold> {
  int selectedIndex = 0; // Track the selected menu item

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Responsive Sidebar Example'),
      ),
      body: Row(
        children: [
          if (isDesktop)
            Expanded(
              flex: 2,
              child: SideBar(
                selectedIndex: selectedIndex,
                onItemSelected: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
              ),
            ),
          Expanded(
            flex: 8,
            child: Center(child: Text('Main Content Area')),
          ),
        ],
      ),
      drawer: isDesktop
          ? null
          : Drawer(
        child: SideBar(
          selectedIndex: selectedIndex,
          onItemSelected: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}

class SideBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const SideBar({
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        DrawerHeader(
          decoration: BoxDecoration(color: Colors.blue),
          child: Text(
            'Sidebar Header',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
        _buildMenuItem(
          context,
          index: 0,
          icon: Icons.home,
          label: 'Home',
        ),
        _buildMenuItem(
          context,
          index: 1,
          icon: Icons.person,
          label: 'Profile',
        ),
        _buildMenuItem(
          context,
          index: 2,
          icon: Icons.settings,
          label: 'Settings',
        ),
      ],
    );
  }

  Widget _buildMenuItem(BuildContext context, {required int index, required IconData icon, required String label}) {
    final isSelected = index == selectedIndex;
    return ListTile(
      leading: Icon(icon, color: isSelected ? Colors.white : Colors.black),
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
        ),
      ),
      tileColor: isSelected ? Colors.black : Colors.transparent,
      onTap: () {
        onItemSelected(index);
      },
    );
  }
}
