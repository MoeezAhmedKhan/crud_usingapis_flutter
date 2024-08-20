// import 'dart:convert';
// import 'dart:io';
// import 'package:assignment02/apis/api.dart';
// import 'package:assignment02/const/sp.dart';
// import 'package:assignment02/model/usermodel.dart';
// import 'package:assignment02/route/routes_name.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// class UserImageScreen extends StatefulWidget {
//   UserImageScreen({super.key});
//   SharedPref sp = SharedPref();
//   Api api = Api();

//   @override
//   State<UserImageScreen> createState() => _UserImageScreenState();
// }

// class _UserImageScreenState extends State<UserImageScreen> {
//   File? image;
//   final picker = ImagePicker();
//   bool showSpinner = false;
//   int? userId;
//   var userProfile;

//   Future<void> getImage() async {
//     final pickedFile =
//         await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
//     if (pickedFile != null) {
//       image = File(pickedFile.path);
//       print("Upload hone se phle");
//       setState(() {});
//       uploadImage(image);
//       print("Upload hone ke bad");
//     } else {
//       print("No Image Selected");
//     }
//   }

//   Future<Usermodel> _loadUserId() async {
//     await widget.sp.init();
//     userId = widget.sp.getUserId();
//     if (userId != null) {
//       return await widget.api.getIndividualApi(userId);
//     } else {
//       throw Exception("User ID not found");
//     }
//   }

//   Future<void> uploadImage(File? uimage) async {
//     final response = await widget.api
//         .submitIndividualProfile(uid: userId, imageFile: uimage);
//     print("Uploaded Response is : ${response}");
//     if (response is String) {
//       var decodedResponse = jsonDecode(response);
//       var profile_img = decodedResponse['data']['profile_pic'];
//       print("Profile Image On Ui is : $profile_img");
//       setState(() {
//         userProfile = profile_img;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     print("Aya");
//     Api api = Api();
//     final mq = MediaQuery.of(context).size;
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: FutureBuilder(
//         future: _loadUserId(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             userProfile = snapshot.data!.data!.profileImage;
//             return Container(
//               padding: EdgeInsets.symmetric(
//                   horizontal: mq.width * 0.04, vertical: mq.height * 0.02),
//               width: double.infinity,
//               child: Column(
//                 children: [
//                   Expanded(
//                       child: InkWell(
//                     onTap: () {
//                       getImage();
//                     },
//                     child: userProfile == null || userProfile.isEmpty
//                         ? Container(
//                             height: mq.height * 0.6,
//                             width: mq.width * 0.6,
//                             decoration: const BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: Colors.blueAccent,
//                             ),
//                             child: Icon(
//                               Icons.add_a_photo,
//                               color: Colors.white,
//                               size: mq.height * 0.08,
//                             ))
//                         : Container(
//                             height: mq.height * 0.6,
//                             width: mq.width * 0.6,
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               image: DecorationImage(
//                                 image: NetworkImage(
//                                     "http://192.168.0.109/flutter_api/uploads/$userProfile"),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           ),
//                   )),
//                   InkWell(
//                     onTap: () {
//                       Navigator.pushNamed(context, RoutesName.UserProfileScreen,
//                           arguments: image);
//                     },
//                     child: Container(
//                       height: mq.height * 0.08,
//                       width: double.infinity,
//                       padding:
//                           EdgeInsets.symmetric(horizontal: mq.width * 0.05),
//                       decoration: BoxDecoration(
//                         color: Colors.blueAccent,
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Icon(
//                         Icons.arrow_right_alt,
//                         size: mq.width * 0.18,
//                         color: Colors.white,
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             );
//           } else {
//             return const Center(
//               child: CircularProgressIndicator(
//                 color: Colors.white,
//                 backgroundColor: Colors.blueAccent,
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'dart:io';
import 'package:assignment02/apis/api.dart';
import 'package:assignment02/const/sp.dart';
import 'package:assignment02/route/routes_name.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImageScreen extends StatefulWidget {
  UserImageScreen({super.key});
  SharedPref sp = SharedPref();
  Api api = Api();

  @override
  State<UserImageScreen> createState() => _UserImageScreenState();
}

class _UserImageScreenState extends State<UserImageScreen> {
  File? image;
  final picker = ImagePicker();
  bool showSpinner = false;
  int? userId;
  String? userProfile;
  String? username;
  String? useremail;
  String? userphone;
  String? usercountry;
  String? userpassword;
  String? usercreated_at;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    await widget.sp.init();
    Map<String, dynamic>? uData = widget.sp.getUserData();
    print("User Id On Shared Pref is $uData");
    if (uData!['user_id'] != null) {
      var userModel = await widget.api.getIndividualApi(userId);
      setState(() {
        userProfile = userModel.data!.profileImage;
        username = userModel.data!.name;
        useremail = userModel.data!.email;
        userphone = userModel.data!.phone;
        usercountry = userModel.data!.country;
        userpassword = userModel.data!.password;
        usercreated_at = userModel.data!.createdAt;
      });
    } else {
      throw Exception("User ID not found");
    }
  }

  Future<void> getImage() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (pickedFile != null) {
      setState(() {
        image = File(pickedFile.path);
      });
      uploadImage(image);
    } else {
      print("No Image Selected");
    }
  }

  Future<void> uploadImage(File? uimage) async {
    final response = await widget.api
        .submitIndividualProfile(uid: userId, imageFile: uimage);
    if (response is String) {
      var decodedResponse = jsonDecode(response);
      setState(() {
        userProfile = decodedResponse['data']['profile_pic'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: userId == null
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                backgroundColor: Colors.blueAccent,
              ),
            )
          : Container(
              padding: EdgeInsets.symmetric(
                  horizontal: mq.width * 0.04, vertical: mq.height * 0.02),
              width: double.infinity,
              child: Column(
                children: [
                  Expanded(
                    child: userProfile == null || userProfile!.isEmpty
                        ? InkWell(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: getImage,
                            child: Container(
                              height: mq.height * 0.6,
                              width: mq.width * 0.6,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.blueAccent,
                              ),
                              child: Icon(
                                Icons.add_a_photo,
                                color: Colors.white,
                                size: mq.height * 0.08,
                              ),
                            ),
                          )
                        : Container(
                            height: mq.height * 0.6,
                            width: mq.width * 0.6,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage(
                                    "http://192.168.0.109/flutter_api/uploads/$userProfile"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, RoutesName.UserProfileScreen,
                          arguments: {
                            "user_id": userId,
                            "userProfile": userProfile,
                            "name": username,
                            "email": useremail,
                            "phone": userphone,
                            "country": usercountry,
                            "password": userpassword,
                            "created_at": usercreated_at,
                          });
                    },
                    child: Container(
                      height: mq.height * 0.08,
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(horizontal: mq.width * 0.05),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.arrow_right_alt,
                        size: mq.width * 0.18,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
