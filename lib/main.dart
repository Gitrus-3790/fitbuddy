import 'dart:async';
import 'dart:convert' show json;
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart' as perstat;
import 'package:contacts_service/contacts_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

import 'src/sign_in_button.dart';

void main() {
  runApp(
    MaterialApp(
      home: MyApp()
    )
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late GoogleMapController mapController;
  
  final LatLng _center = LatLng(37.192778, 127.027468);

  Location location = Location();

  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData _locationData;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> handleLocation() async {
    location.onLocationChanged.listen((LocationData currentLocation) async {
      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          return;
        }
      }

      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          return;
        }
      }

      _locationData = await location.getLocation();
    });

    location.enableBackgroundMode(enable: true);
  }

  /*
  // Note: GoogleMap()의 속성으로 구현됨... *
  Future<void> getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best
    );

    mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 18.0
      )
    ));
  }
   */


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    handleLocation();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        // leading: Text('같이 운동하기', style: TextStyle( fontSize: 20 ),),
         title: Row(
           children: [
             TextButton( onPressed: () {},
               child: Text(
                 '같이 운동하기', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0x9B000000)),
               ),
             ),
             Text('  '),
             TextButton( onPressed: () {},
                 child: Text(
                     '매칭 관리', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0x9B000000))
                 ),
             ),
           ],
         ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              labelText: '검색',
              //hintText: '검색',
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 7),
            height: 270,
            child: GoogleMap(
              mapType: MapType.terrain,
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(target: _center, zoom: 11.0),
              markers: {
                Marker(
                  markerId: MarkerId('한신대학교 60주년기념관'),
                  position: _center,
                  infoWindow: InfoWindow(
                    title: '한신대학교 60주년기념관(장준하통일관)',
                    anchor: Offset(0, 0),
                    snippet: '경기도 오산시 한신대길 137',
                  ),
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
                  draggable: true,
                )
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              mapToolbarEnabled: true,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: true,
              //minMaxZoomPreference: MinMaxZoomPreference(50, 10000),
              compassEnabled: true,
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(5, 7, 5, 0),
            child: Table(
              border: TableBorder(
                horizontalInside: BorderSide(color: Color(0xFFCCCCCC), width: 1),
                verticalInside: BorderSide.none,
                bottom: BorderSide(color: Color(0xFFCCCCCC), width: 1),
              ),
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Color(0xffe1edfc),
                  ),
                  children: [
                    TableCell(child: Center(child: TextButton.icon(
                          onPressed: () {

                          },
                          label: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('일시', style: TextStyle(color: Color(0x99000000), fontWeight: FontWeight.bold, fontSize: 16),),
                              Transform.rotate(
                                angle: pi / 2,
                                child: Icon(Icons.compare_arrows, size: 17,),
                              ),
                            ],
                          ),
                        ),
                    ),),
                    TableCell(child: Center(child: TextButton.icon(
                      onPressed: () {

                      },
                      label: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('장소', style: TextStyle(color: Color(0x99000000), fontWeight: FontWeight.bold, fontSize: 16),),
                          Transform.rotate(
                            angle: pi / 2,
                            child: Icon(Icons.compare_arrows, size: 17,),
                          ),
                        ],
                      ),
                    ),),),
                    TableCell(child: Center(child: TextButton.icon(
                      onPressed: () {

                      },
                      label: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('모집인원', style: TextStyle(color: Color(0x99000000), fontWeight: FontWeight.bold, fontSize: 16),),
                          Transform.rotate(
                            angle: pi / 2,
                            child: Icon(Icons.compare_arrows, size: 17,),
                          ),
                        ],
                      ),
                    ),),)
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('4/22 월', style: TextStyle( color: Color(0x99000000), fontSize: 14),),
                              Text('8:00~9:00', style: TextStyle( color: Color(0x99000000), fontSize: 14),),
                            ],
                        ),
                      ),
                    ),
                    TableCell(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('서울시 서초구', style: TextStyle( color: Color(0x99000000), fontSize: 14),),
                            Text('A 휘트니스', style: TextStyle( color: Color(0x99000000), fontSize: 14),),
                          ],
                        ),
                      ),
                    ),
                    TableCell(
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.only(top: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                Text('1/2', style: TextStyle( color: Color(0x99000000), fontSize: 14),),
                              ],
                            ),
                        ),
                        ),
                      ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('4/22 월', style: TextStyle( color: Color(0x99000000),),),
                            Text('18:00~20:00', style: TextStyle( color: Color(0x99000000),),),
                          ],
                        ),
                      ),
                    ),
                    TableCell(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('서울시 중랑구', style: TextStyle( color: Color(0x99000000),),),
                            Text('B 휘트니스', style: TextStyle( color: Color(0x99000000),),),
                          ],
                        ),
                      ),
                    ),
                    TableCell(
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.only(top: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('2/3', style: TextStyle( color: Color(0x99000000),),),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    TableCell(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('4/22 화', style: TextStyle( color: Color(0x99000000),),),
                            Text('19:00~20:30', style: TextStyle( color: Color(0x99000000),),),
                          ],
                        ),
                      ),
                    ),
                    TableCell(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('경기도 수원시', style: TextStyle( color: Color(0x99000000),),),
                            Text('C 휘트니스', style: TextStyle( color: Color(0x99000000),),),
                          ],
                        ),
                      ),
                    ),
                    TableCell(
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.only(top: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('2/3', style: TextStyle( color: Color(0x99000000),),),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ]
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

        },
        backgroundColor: Color(0xffe1edfc),
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        unselectedItemColor: Color(0x9B000000),
        selectedItemColor: Colors.blue,
        items: [
          BottomNavigationBarItem(
            icon: IconButton(
                onPressed: () {

                },
                icon: Icon(Icons.home_outlined)),
            activeIcon: Icon(Icons.home),
            label: '홈',
            tooltip: '홈',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
                onPressed: () {

                },
                icon: Icon(Icons.chat_bubble_outline)),
            activeIcon: Icon(Icons.chat_bubble_rounded),
            label: '커뮤니티',
            tooltip: '커뮤니티',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
                onPressed: () {

                },
                icon: Icon(Icons.people_outlined)),
            activeIcon: Icon(Icons.people),
            label: '매칭',
            tooltip: '매칭',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
                onPressed: () {

                },
                icon: Icon(Icons.person_outlined)),
            activeIcon: Icon(Icons.person),
            label: '마이페이지',
            tooltip: '마이페이지',
          ),
        ],
      ),
    );
  }
}

class MatchingRegister extends StatefulWidget {
  const MatchingRegister({super.key});

  @override
  State<MatchingRegister> createState() => _MatchingRegisterState();
}

class _MatchingRegisterState extends State<MatchingRegister> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.cancel),
        title: Center(child: Text('글 쓰기') ,),
        actions: [ TextButton(
            onPressed: () {
              // Register method...
            },
            child: Text('등록')) ],
      ),
      body: Container(
        margin: EdgeInsets.only(top: 7),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
          ],
        ),
      ),
    );
  }
}



// class SignInDemo extends StatefulWidget {
//   const SignInDemo({super.key});
//
//   @override
//   State createState() => _SignInDemoState();
// }
//
// class _SignInDemoState extends State<SignInDemo> {
//   GoogleSignInAccount? _currentUser;
//   bool _isAuthorized = false;
//   String _contactText = '';
//   final Completer<GoogleMapController> _mapController = Completer<GoogleMapController>();
//
//   static const CameraPosition _kGooglePlex = CameraPosition(
//     target: LatLng(37.42796133580664, -122.085749655962),
//     zoom: 14.4746,
//   );
//
//   static const CameraPosition _kLake = CameraPosition(
//       bearing: 192.8334901395799,
//       target: LatLng(37.43296265331129, -122.08832357078792),
//       tilt: 59.440717697143555,
//       zoom: 19.151926040649414);
//
//   @override
//   void initState() {
//     super.initState();
//
//     _googleSignIn.onCurrentUserChanged
//         .listen((GoogleSignInAccount? account) async {
//       bool isAuthorized = account != null;
//       if (kIsWeb && account != null) {
//         isAuthorized = await _googleSignIn.canAccessScopes(scopes);
//       }
//
//       setState(() {
//         _currentUser = account;
//         _isAuthorized = isAuthorized;
//       });
//
//       if (isAuthorized) {
//         unawaited(_handleGetContact(account!));
//       }
//     });
//
//     _googleSignIn.signInSilently();
//   }
//
//   Future<void> _handleGetContact(GoogleSignInAccount user) async {
//     setState(() {
//       _contactText = '연락처 정보 가져오는 중...';
//     });
//     final http.Response response = await http.get(
//       Uri.parse('https://people.googleapis.com/v1/people/me/connections'
//           '?requestMask.includeField=person.names'),
//       headers: await user.authHeaders,
//     );
//     if (response.statusCode != 200) {
//       setState(() {
//         _contactText = 'People API gave a ${response.statusCode} '
//             'response. Check logs for details.';
//       });
//       print('People API ${response.statusCode} response: ${response.body}');
//       return;
//     }
//     final Map<String, dynamic> data =
//     json.decode(response.body) as Map<String, dynamic>;
//     final String? namedContact = _pickFirstNamedContact(data);
//     setState(() {
//       if (namedContact != null) {
//         _contactText = '$namedContact 님을 아시는군요!';
//       } else {
//         _contactText = '알고 있는 연락처가 없습니다.';
//       }
//     });
//   }
//
//   String? _pickFirstNamedContact(Map<String, dynamic> data) {
//     final List<dynamic>? connections = data['connections'] as List<dynamic>?;
//     final Map<String, dynamic>? contact = connections?.firstWhere(
//           (dynamic contact) =>
//       (contact as Map<Object?, dynamic>)['names'] != null,
//       orElse: () => null,
//     ) as Map<String, dynamic>?;
//     if (contact != null) {
//       final List<dynamic> names = contact['names'] as List<dynamic>;
//       final Map<String, dynamic>? name = names.firstWhere(
//             (dynamic name) =>
//         (name as Map<Object?, dynamic>)['displayName'] != null,
//         orElse: () => null,
//       ) as Map<String, dynamic>?;
//       if (name != null) {
//         return name['displayName'] as String?;
//       }
//     }
//     return null;
//   }
//
//   Future<void> _handleSignIn() async {
//     try {
//       await _googleSignIn.signIn();
//     } catch (error) {
//       print(error);
//     }
//   }
//
//   Future<void> _handleAuthorizeScopes() async {
//     final bool isAuthorized = await _googleSignIn.requestScopes(scopes);
//     setState(() {
//       _isAuthorized = isAuthorized;
//     });
//     if (isAuthorized) {
//       unawaited(_handleGetContact(_currentUser!));
//     }
//   }
//
//   Future<void> _handleSignOut() => _googleSignIn.disconnect();
//
//   Future<void> _goToTheLake() async {
//     final GoogleMapController controller = await _mapController.future;
//     await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
//   }
//
//   Widget _buildBody() {
//     final GoogleSignInAccount? user = _currentUser;
//     if (user != null) {
//       return Column(
//         children: <Widget>[
//           ListTile(
//             leading: GoogleUserCircleAvatar(
//               identity: user,
//             ),
//             title: Text(user.displayName ?? ''),
//             subtitle: Text(user.email),
//           ),
//           const Text('FitBuddy 가입을 환영합니다!'),
//           if (_isAuthorized)
//             Text(_contactText),
//           ElevatedButton(
//             onPressed: _handleSignOut,
//             child: const Text('로그아웃'),
//           ),
//           Expanded(
//             child: GoogleMap(
//               mapType: MapType.hybrid,
//               initialCameraPosition: _kGooglePlex,
//               onMapCreated: (GoogleMapController controller) {
//                 _mapController.complete(controller);
//               },
//             ),
//           ),
//           FloatingActionButton.extended(
//             onPressed: _goToTheLake,
//             label: const Text('To the lake!'),
//             icon: const Icon(Icons.directions_boat),
//           ),
//         ],
//       );
//     } else {
//       return Column(
//         children: <Widget>[
//           const Text('로그인이 필요합니다.'),
//           buildSignInButton(onPressed: _handleSignIn),
//         ],
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Google 로그인'),
//       ),
//       body: _buildBody(),
//     );
//   }
// }
