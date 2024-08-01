
import 'package:blinq_sol/appData/AuthData.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../appData/dailogbox.dart';
import 'ProfileSection.dart';
import 'Userprofile.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key});

  Future<void> logout() async {
    await AuthData.saveLoginStatus(false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('isLoggedIn');
  }
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: screenHeight / 210,
          horizontal: screenWidth / 120,
        ),
        child: BottomNavigationBar(
          selectedItemColor: Colors.orange,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            if (index == 0) {
              if (ModalRoute.of(context)?.settings.name != '/dashboard') {
                Navigator.pushReplacementNamed(context, '/dashboard');
              }
            }
            else if (index == 1) {

              Profile.showAlertDialog(context, '', '', screenWidth);
            } else if (index == 3) {

            } else if (index == 2) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Are you sure?'),
                  content: const Text('Do you want to logout from the app?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("No", style: TextStyle(
                        color: Colors.deepOrange, // Text color
                      ),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        logout();
                        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                      },
                      child: const Text("Yes", style: TextStyle(
                        color: Colors.deepOrange, // Text color
                      ),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 30,
              ),
              label: 'Home',
            ),

            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                size: 30,
              ),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.logout,
                size: 30,
              ),
              label: 'Logout',
            ),
          ],
        ),
      ),
    );
  }
}

