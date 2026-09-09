import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_installment_management/features/main_layout/home/presentation/view/home_tab.dart';
import 'package:smart_installment_management/l10n/app_localizations.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeTab(),
    Center(child: Text('Partners')),
    Center(child: Text('Groups')),
    Center(child: Text('Customers')),
    Center(child: Text('Tracker')),
    Center(child: Text('Profile')),
  ];

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.015),
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border(
              top: BorderSide(
                color: isDark
                    ? const Color(0xFF243444)
                    : const Color(0xFFDFE8FF),
                width: 1.w,
              ),
            ),
          ),
          child: NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            destinations: [
              NavigationDestination(
                icon: const Icon(Icons.home_outlined),
                selectedIcon: const Icon(Icons.home_filled),
                label: appLocalizations.home,
              ),
              NavigationDestination(
                icon: const Icon(Icons.handshake_outlined),
                selectedIcon: const Icon(Icons.handshake_rounded),
                label: appLocalizations.partners,
              ),
              NavigationDestination(
                icon: const Icon(Icons.bubble_chart_outlined),
                selectedIcon: const Icon(Icons.bubble_chart),
                label: appLocalizations.groups,
              ),
              NavigationDestination(
                icon: const Icon(Icons.people_outline_rounded),
                selectedIcon: const Icon(Icons.people_alt_rounded),
                label: appLocalizations.customers,
              ),
              NavigationDestination(
                icon: const Icon(Icons.show_chart_rounded),
                selectedIcon: const Icon(Icons.analytics_rounded),
                label: appLocalizations.tracker,
              ),
              NavigationDestination(
                icon: const Icon(Icons.person_outline_rounded),
                selectedIcon: const Icon(Icons.person_rounded),
                label: appLocalizations.profile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}