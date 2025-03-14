import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../user_authentication/login_page.dart';
import '../../user_prof_mang/user_prof_mang_view/emplo_prof_view.dart';
import 'feedback_page.dart';
import 'payment_history_page.dart';
import 'user_payment_history/uer_payment_view/user_payment_view.dart';
import 'waste_submit_page.dart';

class HomePage extends StatefulWidget {
  const HomePage(
      {super.key,
      this.userId, // Remove `required` to allow null values
      this.userName,
      this.isCompleted,
      this.isNotCompleted,
      this.status});

  final int? userId;
  final String? userName;
  final bool? isCompleted;
  final bool? isNotCompleted;
  final String? status;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int? userId;
  final int _selectedIndex = 0;
  String? userName;
  bool? incomplete;
  bool? complete;

  @override
  void initState() {
    // TODO: implement initState
    userId = widget.userId;
    userName = widget.userName;
    complete = widget.isCompleted;
    incomplete = widget.isCompleted;
    printUserName();

    super.initState();

    // print("For Home Page userId ===============$userId");
    // print("For Home Page complet ===============$complete");
    // print("For Home Page incomplete ===============$incomplete");
    print('UserName ============= $userName');
    // print('Home Screen ==============$userId');
  }

  _onItemTapped(int index) {
    if (index == 1) {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return HistoryPage(
            userid: userId,
          );
        },
      ));
    }
    if (index == 2) {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return const PaymentDetailsScreen();
        },
      ));
    }
  }

  void showAlertBox() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Do you want to Logout?',
            style: TextStyle(fontSize: 20),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('No'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) {
                        return LoginPage(
                          userName: userName,
                          userId: userId,
                        );
                      },
                    ));
                  },
                  child: const Text('Yes'),
                )
              ],
            )
          ],
        );
      },
    );
  }

  Future<void> printUserName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userName = prefs.getString('name');

    if (userName != null) {
      print("UserName: $userName"); // ✅ Prints the stored username
    } else {
      print("UserName is null or not set."); // ⚠️ Handle null case
    }
  }

  @override
  Widget build(BuildContext context) {
    // double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    List<Map<String, dynamic>> homeList = [
      {'name': 'Plastic', 'kg': '10 kg'},
      {'name': 'Non-Biodegradable Wastes', 'kg': '10 kg'},
      {'name': 'Hazardous Waste', 'kg': '10 kg'},
      {'name': 'E-Waste', 'kg': '10 kg'},
      {'name': 'Sanitary Waste', 'kg': '10 kg'},
      {'name': 'Other Waste', 'kg': '10 kg'},
    ];

    return SafeArea(
      child: Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 53, 119, 87),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.account_circle, size: 60, color: Colors.white),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Profile Management'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return EmployeeProfilePage(
                        userId: userId!,
                        //name: userName!,
                      );
                    },
                  ));
                },
              ),
              // ListTile(
              //   leading: const Icon(Icons.history),
              //   title: const Text('View History'),
              //   onTap: () {
              //     Navigator.push(context, MaterialPageRoute(
              //       builder: (context) {
              //         return HistoryPage(userid: userId);
              //       },
              //     ));
              //   },
              // ),
              ListTile(
                leading: const Icon(Icons.feedback_outlined),
                title: const Text('Feed Back'),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return FeedbackPage(
                        userid: userId,
                      );
                    },
                  ));
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () {
                  showAlertBox();
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 53, 119, 87),
          title: Text(
            userName ?? "Guest",
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          // actions: [
          //   TextButton.icon(
          //     onPressed: () {},
          //     label: const Text(
          //       'Current Location',
          //       style: TextStyle(color: Colors.white),
          //     ),
          //     icon: const Icon(
          //       Icons.location_on_outlined,
          //       color: Colors.white,
          //     ),
          //   )
          // ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                'Collected Waste Given by ME....',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemCount: homeList.length,
                  itemBuilder: (context, index) {
                    final list = homeList[index];
                    return Card(
                      color: Colors.white,
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.clean_hands_outlined,
                                size: 40, color: Colors.green),
                            const SizedBox(height: 8),
                            Text(
                              list['name'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                            // const SizedBox(height: 4),
                            // Text(
                            //   list['kg'],
                            //   style: const TextStyle(color: Colors.grey),
                            //   textAlign: TextAlign.center,
                            // ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: width,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 53, 119, 87),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0)),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return const WasteSubmitPage();
                      },
                    ));
                  },
                  child: const Text(
                    'Request',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: const Color.fromARGB(255, 24, 87, 27),
            selectedFontSize: 14.0,
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
            unselectedItemColor: Colors.grey,
            unselectedFontSize: 12.0,
            //  selectedIconTheme: IconThemeData(),
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.history), label: 'View History'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.logout_sharp), label: 'Payment History')
            ]),
      ),
    );
  }
}
