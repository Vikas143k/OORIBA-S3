// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:ooriba_s3/HR/hr_dashboard_page.dart';
// import 'package:ooriba_s3/firebase_options.dart';
// import 'package:ooriba_s3/post_login_page.dart';
// import 'package:ooriba_s3/services/auth_service.dart';
// import 'package:ooriba_s3/services/dark_mode.dart';
// import 'package:ooriba_s3/signup_page.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:provider/provider.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   await _requestPermissions();
//   final AuthService authService = AuthService();
//   final String? email = await authService.getUserSession();
//   final String? role = await authService.getUserRole();
  
//   runApp(OoribaApp(isLoggedIn: email != null,email: email, userRole: role));
// }

// Future<void> _requestPermissions() async {
//   PermissionStatus status = await Permission.storage.request();
//   if (status.isGranted) {
//     print('Storage permission granted');
//   } else if (status.isDenied) {
//     print('Storage permission denied');
//   } else if (status.isPermanentlyDenied) {
//     print('Storage permission permanently denied');
//     openAppSettings();
//   }
// }

// class OoribaApp extends StatelessWidget {
//   final bool isLoggedIn;
//   final String? userRole;
//   final String? email;

//   const OoribaApp({Key? key, required this.isLoggedIn, required this.email,required this.userRole}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (_) => DarkModeService(),
//       child: Consumer<DarkModeService>(
//         builder: (context, darkModeService, _) {
//           return MaterialApp(
//             debugShowCheckedModeBanner: false,
//             title: 'OORIBA_S3',
//             theme: ThemeData(
//               primarySwatch: Colors.blue,
//               brightness: Brightness.light,
//             ),
//             darkTheme: ThemeData(
//               primarySwatch: Colors.blue,
//               brightness: Brightness.dark,
//             ),
//             themeMode: darkModeService.isDarkMode ? ThemeMode.dark : ThemeMode.light,
//             home: _getInitialPage(isLoggedIn,email, userRole),
//           );
//         },
//       ),
//     );
//   }

//   Widget _getInitialPage(bool isLoggedIn,String? email, String? role) {
//     if (!isLoggedIn) {
//       return LoginPage();
//     } else if (role == 'HR') {
//       return HRDashboardPage();
//     } else {
//       email!=null?email=email:email='';
//       return PostLoginPage(email: email, userDetails: {});
//     }
//   }
// }

// class LoginPage extends StatelessWidget {
//   LoginPage({super.key});

//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     final darkModeService = Provider.of<DarkModeService>(context, listen: false);
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('OORIBA_S3'),
//         actions: [
//           IconButton(
//             icon: Icon(darkModeService.isDarkMode ? Icons.light_mode : Icons.dark_mode),
//             onPressed: () {
//               darkModeService.toggleDarkMode();
//             },
//           ),
//         ],
//       ),
//       body: LayoutBuilder(
//         builder: (context, constraints) {
//           return SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Center(
//                 child: ConstrainedBox(
//                   constraints: const BoxConstraints(maxWidth: 400),
//                   child: Container(
//                     padding: const EdgeInsets.all(16.0),
//                     decoration: BoxDecoration(
//                       color: Theme.of(context).colorScheme.surface,
//                       borderRadius: BorderRadius.circular(10),
//                       boxShadow: const [
//                         BoxShadow(
//                           color: Colors.black12,
//                           blurRadius: 10,
//                           offset: Offset(0, 5),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: <Widget>[
//                         const Text(
//                           'Welcome To OORIBA-S3',
//                           style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                         ),
//                         const SizedBox(height: 20),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: <Widget>[
//                             Image.asset(
//                               'assets/images/companyLogo.png',
//                               width: 200,
//                               height: 190,
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 20),
//                         TextField(
//                           controller: _emailController,
//                           decoration: const InputDecoration(
//                             filled: true,
//                             labelText: 'Email ID',
//                             border: OutlineInputBorder(),
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                         TextField(
//                           controller: _passwordController,
//                           decoration: const InputDecoration(
//                             labelText: 'Password',
//                             border: OutlineInputBorder(),
//                           ),
//                           obscureText: true,
//                         ),
//                         const SizedBox(height: 10),
//                         Align(
//                           alignment: Alignment.centerRight,
//                           child: TextButton(
//                             onPressed: () {
//                               // Handle forgot password
//                             },
//                             child: const Text('Forgot Password'),
//                           ),
//                         ),
//                         const SizedBox(height: 20),
//                         ElevatedButton(
//                           onPressed: () async {
//                             bool success = await AuthService().signin(
//                               email: _emailController.text,
//                               password: _passwordController.text,
//                               context: context,
//                             );
//                             if (success) {
//                               // Navigation is handled within AuthService
//                             }
//                           },
//                           child: const Text('Sign In'),
//                         ),
//                         const SizedBox(height: 20),
//                         RichText(
//                           text: TextSpan(
//                             text: "Don't have an account? ",
//                             style: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color),
//                             children: [
//                               TextSpan(
//                                 text: 'Sign Up here',
//                                 style: const TextStyle(
//                                   color: Colors.blue,
//                                   decoration: TextDecoration.underline,
//                                 ),
//                                 recognizer: TapGestureRecognizer()
//                                   ..onTap = () {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(builder: (context) => const SignUpPage()),
//                                     );
//                                   },
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:firebase_core/firebase_core.dart';
import 'package:ooriba_s3/geolocation/geo.dart';
import 'package:ooriba_s3/test/checkin.dart';
import 'package:ooriba_s3/test/employeedashboardtest.dart';
import 'firebase_options.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ooriba_s3/HR/hr_dashboard_page.dart';
import 'package:ooriba_s3/post_login_page.dart';
import 'package:ooriba_s3/services/auth_service.dart';
import 'package:ooriba_s3/services/dark_mode.dart';
import 'package:ooriba_s3/signup_page.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await _requestPermissions();
  final AuthService authService = AuthService();
  final String? email = await authService.getUserSession();
  final String? role = await authService.getUserRole();
  
  runApp(OoribaApp(isLoggedIn: email != null, email: email, userRole: role));
}

Future<void> _requestPermissions() async {
  PermissionStatus status = await Permission.storage.request();
  if (status.isGranted) {
    print('Storage permission granted');
  } else if (status.isDenied) {
    print('Storage permission denied');
  } else if (status.isPermanentlyDenied) {
    print('Storage permission permanently denied');
    openAppSettings();
  }
}

class OoribaApp extends StatelessWidget {
  final bool isLoggedIn;
  final String? userRole;
  final String? email;

  const OoribaApp({super.key, required this.isLoggedIn, required this.email, required this.userRole});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DarkModeService(),
      child: Consumer<DarkModeService>(
        builder: (context, darkModeService, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'OORIBA_S3',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              brightness: Brightness.light,
            ),
            darkTheme: ThemeData(
              primarySwatch: Colors.blue,
              brightness: Brightness.dark,
            ),
            themeMode: darkModeService.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: _getInitialPage(isLoggedIn, email, userRole),
          );
        },
      ),
    );
  }

  Widget _getInitialPage(bool isLoggedIn, String? email, String? role) {
    if (!isLoggedIn) {
      return LoginPage();
    } else if (role == 'HR') {
      return const HRDashboardPage();
    } else {
      email != null ? email = email : email = '';
      return PostLoginPage(email: email, userDetails: const {});
    }
  }
}

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final darkModeService = Provider.of<DarkModeService>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('OORIBA_S3'),
        actions: [
          IconButton(
            icon: Icon(darkModeService.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              darkModeService.toggleDarkMode();
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Text(
                          'Welcome To OORIBA-S3',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              'assets/images/companyLogo.png',
                              width: 200,
                              height: 190,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            filled: true,
                            labelText: 'Email ID',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          controller: _passwordController,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                               Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) =>  const EmployeeDashboard()),
                                    );
                            },
                            child: const Text('Forgot Password'),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () async {
                            bool success = await AuthService().signin(
                              email: _emailController.text,
                              password: _passwordController.text,
                              context: context,
                            );
                            if (success) {
                              // Navigation is handled within AuthService
                            }
                          },
                          child: const Text('Sign In'),
                        ),
                        const SizedBox(height: 20),
                        RichText(
                          text: TextSpan(
                            text: "Don't have an account? ",
                            style: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color),
                            children: [
                              TextSpan(
                                text: 'Sign Up here',
                                style: const TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const SignUpPage()),
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                        //const SizedBox(height: 20),
                        //ElevatedButton(
                        //  onPressed: () {
                        //    Navigator.push(
                        //      context,
                        //      MaterialPageRoute(builder: (context) => CheckInPage()),
                        //    );
                        //  },
                        //  child: const Text('Geolocation'),
                        //),
                        // Additional buttons can be added here
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
