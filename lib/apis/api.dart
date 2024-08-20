import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:assignment02/const/sp.dart';
import 'package:assignment02/model/usermodel.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; // Import this package for MediaType

class Api {
  bool loading = false;
  void setLoading(bool value) {
    loading = value;
  }

  Future<Object?> registerUser(Map<String, dynamic> sendData) async {
    // print("Before submit data: $sendData");
    const url = "http://192.168.0.109/flutter_api/singup.php";
    try {
      await Future.delayed(const Duration(seconds: 1));
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
        },
        body: {
          "token":
              "as23rlkjadsnlkcj23qkjnfsDKJcnzdfb3353ads54vd3favaeveavgbqaerbVEWDSC",
          "name": "${sendData['name']}",
          "email": "${sendData['email']}",
          "password": "${sendData['password']}"
        },
      );
      if (response.statusCode == 200) {
        print('Request successful: ${jsonDecode(response.body.toString())}');
        return response.body;
      }
    } on SocketException catch (e) {
      print("Network error: $e");
    } catch (e) {
      print("Error: $e");
    }
    return null;
  }

  Future<Object?> loginUser(Map<String, dynamic> sendData) async {
    print("Before Login data: $sendData");
    const url = "http://192.168.0.109/flutter_api/login.php";
    try {
      await Future.delayed(const Duration(seconds: 1));
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
        },
        body: {
          "token":
              "as23rlkjadsnlkcj23qkjnfsDKJcnzdfb3353ads54vd3favaeveavgbqaerbVEWDSC",
          "email": "${sendData['email']}",
          "password": "${sendData['password']}"
        },
      );
      if (response.statusCode == 200) {
        print('Request successful: ${jsonDecode(response.body.toString())}');
        return response.body;
      }
    } on SocketException catch (e) {
      print("Network error: $e");
    } catch (e) {
      print("Error: $e");
    }
    return null;
  }

  Future<Usermodel> getIndividualApi(int? uid) async {
    // await Future.delayed(Duration(seconds: 10));
    const url = "http://192.168.0.109/flutter_api/get_individual.php";
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
      body: {
        "token":
            "as23rlkjadsnlkcj23qkjnfsDKJcnzdfb3353ads54vd3favaeveavgbqaerbVEWDSC",
        "uid": uid.toString(),
      },
    );
    var data = jsonDecode(response.body.toString());
    // print("Json Decoded Data: ${data}");
    if (response.statusCode == 200) {
      return Usermodel.fromJson(data);
    } else {
      return Usermodel.fromJson(data);
    }
  }

  Future<dynamic> submitIndividualProfile(
      {required int? uid, required File? imageFile}) async {
    print("Go Image User Id: $uid, File is: $imageFile");

    var stream = new http.ByteStream(imageFile!.openRead());
    // stream.cast();

    var length = await imageFile.length();
    print("Length of File: $length");
    var surl = Uri.parse(
        "http://192.168.0.109/flutter_api/submit_individual_profile.php");

    var request = new http.MultipartRequest("POST", surl);

    request.fields['token'] =
        "as23rlkjadsnlkcj23qkjnfsDKJcnzdfb3353ads54vd3favaeveavgbqaerbVEWDSC";
    request.fields['user_id'] = uid.toString();

    // Get the file extension
    String fileExtension = imageFile.path.split('.').last.toLowerCase();
    MediaType? mediaType;

    // Set contentType based on file extension
    if (fileExtension == 'jpg' || fileExtension == 'jpeg') {
      mediaType = MediaType('image', 'jpeg');
    } else if (fileExtension == 'png') {
      mediaType = MediaType('image', 'png');
    } else {
      mediaType = MediaType('application', 'octet-stream'); // default
    }

    var multipart = new http.MultipartFile(
      "profile_image",
      stream,
      length,
      filename: imageFile.path.split('/').last,
      contentType: mediaType,
    );

    request.files.add(multipart);

    var response = await request.send();
    if (response.statusCode == 200) {
      var responseBody = await http.Response.fromStream(response);
      print("Image Uploaded Successfully: ${responseBody.body}");
      return responseBody.body;
    } else {
      print("Failed to Upload Image, Status Code: ${response.statusCode}");
      return null;
    }
  }

  Future<Object?> updateProfile(int uid, Map<String, dynamic> map) async {
    // print("User Id : $uid and Data On Update Call: ${map['name']}");
    String Url = "http://192.168.0.109/flutter_api/update_profile.php";
    try {
      final response = await http.put(Uri.parse(Url), headers: {
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      }, body: {
        "token":
            "as23rlkjadsnlkcj23qkjnfsDKJcnzdfb3353ads54vd3favaeveavgbqaerbVEWDSC",
        "user_id": uid.toString(),
        "name": "${map['name']}",
        "email": "${map['email']}",
        "phone": "${map['phone']}",
        "country": "${map['country']}",
        "password": "${map['password']}"
      });

      if (response.statusCode == 200) {
        // print(
        //     'Update Request successful: ${jsonDecode(response.body.toString())}');
        return response.body;
      } else {
        print("Something went wrong while updating");
      }
    } on SocketException catch (e) {
      print("Network error: $e");
    } catch (e) {
      print("Error: $e");
    }
    return null;
  }
}
