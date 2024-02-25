import 'package:blood_donation/Screen/about_us_screen.dart';
import 'package:blood_donation/Screen/add_donor_screen.dart';
import 'package:blood_donation/Screen/events_appointment.dart';
import 'package:blood_donation/Screen/privacy_policy.dart';
import 'package:blood_donation/Screen/profile_screen.dart';
import 'package:blood_donation/model/screen_resolution.dart';
import 'package:blood_donation/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:blood_donation/data/drawer_items.dart';
import 'package:blood_donation/model/drawer_item.dart';
import 'package:blood_donation/Screen/sign_in_up_screen.dart';
import 'package:blood_donation/Screen/search_ambulance.dart';
import 'package:blood_donation/Screen/search_blood_bank.dart';
import 'package:blood_donation/api/api.dart';

import 'package:blood_donation/Screen/settings_screen.dart';
//import 'package:blood_donation/Screen/samples_page.dart';

import 'package:blood_donation/Screen/notification_screen.dart';
import 'package:blood_donation/provider/navigation_provider.dart';
import 'package:provider/provider.dart';

class NavigationDrawerScreen extends StatelessWidget {
  NavigationDrawerScreen({Key? key}) : super(key: key);

  final padding = const EdgeInsets.symmetric(horizontal: 20);
  final CallApi callApi = CallApi();
  @override
  Widget build(BuildContext context) {
    double asr = ScreenResolution().sh / ScreenResolution().sw;

    final safeArea =
        EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top);

    final provider = Provider.of<NavigationProvider>(context);
    final isCollapsed = provider.isCollapsed;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: isCollapsed ? 28.56 * asr : ScreenResolution().sw * 1.0,
      child: Drawer(
        child: Container(
          color: const Color(0xff161616),
          child: Column(
            children: [
              Container(
                padding:
                    EdgeInsets.symmetric(vertical: 12.24 * asr).add(safeArea),
                width: double.infinity,
                color: const Color(0xff161616),
                child: buildHeader(isCollapsed),
              ),
              const Divider(color: Colors.white70),
              // First list with more vertical space
              Expanded(
                child: buildList(items: itemsFirst, isCollapsed: isCollapsed),
              ),
              const Divider(color: Colors.white70),

              buildCollapseIcon(context, isCollapsed),
              SizedBox(height: 3.06 * asr), // Add a small space below the icon
            ],
          ),
        ),
      ),
    );
  }

  Widget buildList({
    required bool isCollapsed,
    required List<DrawerItem> items,
    int indexOffset = 0,
  }) =>
      ListView.separated(
        padding: isCollapsed ? EdgeInsets.zero : padding,
        shrinkWrap: true,
        primary: false,
        itemCount: items.length,
        separatorBuilder: (context, index) => const SizedBox(height: 0),
        itemBuilder: (context, index) {
          final item = items[index];

          return buildMenuItem(
            isCollapsed: isCollapsed,
            text: item.title,
            icon: item.icon,
            onClicked: () => selectItem(context, indexOffset + index),
          );
        },
      );

  void selectItem(BuildContext context, int index) {
    navigateTo(page) => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => page,
        ));

    Navigator.of(context).pop();
    // Access the UserProvider
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    int? profileId = userProvider.donorId;

    if (profileId != null) {
      switch (index) {
        case 0:
          navigateTo(Profile(donorId: profileId));
          break;

        case 1:
          navigateTo(const AddNewDonor());
          break;
        case 2:
          navigateTo(const NotificationScreen());
          break;
        case 3:
          navigateTo(const EventsAppointments());
          break;
        case 4:
          navigateTo(const SearchAmbulance());
          break;
        case 5:
          navigateTo(const SearchBloodBank());
          break;
        case 6:
          navigateTo(const SettingsScreen());
          break;
        case 7:
          navigateTo(const PrivacyPolicy());
          break;
        case 8:
          navigateTo(const AboutUs());
          break;
        case 9:
          callApi.logout();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const SignInSignUp(),
            ),
          );

          break;
      }
    } else {}
  }

  double asr = ScreenResolution().sh / ScreenResolution().sw;
  Widget buildMenuItem({
    required bool isCollapsed,
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    const color = Color(0xFFFFFFFF);
    final leading = Icon(icon, color: color);

    return Material(
      color: const Color(0xff161616),
      child: isCollapsed
          ? ListTile(
              title: leading,
              onTap: onClicked,
            )
          : ListTile(
              leading: leading,
              title: Text(text,
                  style: TextStyle(color: color, fontSize: 6.2 * asr)),
              onTap: onClicked,
            ),
    );
  }

  Widget buildCollapseIcon(BuildContext context, bool isCollapsed) {
    double size = 25.75 * asr;
    final icon = isCollapsed ? Icons.arrow_forward_ios : Icons.arrow_back_ios;
    final alignment = isCollapsed ? Alignment.center : Alignment.centerRight;
    final margin = isCollapsed ? null : EdgeInsets.only(right: 10.33 * asr);
    final width = isCollapsed ? double.infinity : size;

    return Container(
      alignment: alignment,
      margin: margin,
      child: Material(
        color: const Color.fromARGB(212, 240, 5, 5),
        child: InkWell(
          child: SizedBox(
            width: width,
            height: size,
            child: Icon(icon, color: Colors.white),
          ),
          onTap: () {
            final provider =
                Provider.of<NavigationProvider>(context, listen: false);

            provider.toggleIsCollapsed();
          },
        ),
      ),
    );
  }

  Widget buildHeader(bool isCollapsed) => isCollapsed
      ? Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 6.2 * asr),
              child: SizedBox(
                width: 20.4 * asr,
                height: 20.4 * asr,
                child: Image.asset(
                  'images/logo.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        )
      : Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 15.5 * asr),
                      child: SizedBox(
                        width: 25.75 * asr,
                        height: 25.75 * asr,
                        child: Image.asset(
                          'images/logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(width: 3.06 * asr),
                    Text(
                      'Mobile Blood Bank',
                      style: TextStyle(
                        fontSize: 12.24 * asr,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
}
