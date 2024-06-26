import 'package:onlyhocamsui/models/NoteDTO.dart';
import 'package:onlyhocamsui/models/UserDTOListResponse.dart';
import 'package:path/path.dart';

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:onlyhocamsui/models/CategoryDTO.dart';
import 'package:onlyhocamsui/models/NoteDTOListResponse.dart';
import 'package:onlyhocamsui/models/PostDTOListResponse.dart';
import '../models/CategoryDTOListResponse.dart';
import '../models/UserDTO.dart';
import 'constants.dart';

import 'package:multi_image_picker_view/multi_image_picker_view.dart';

class ApiService {
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<String?> getJwtToken() async {
    try {
      final jwtToken = await storage.read(key: 'jwt_token');
      return jwtToken;
    } catch (error) {
      return "NOT_FOUND";
    }
  }
  Future<String?> getUserId() async {
    try {
      final jwtToken = await storage.read(key: 'userId');
      return jwtToken;
    } catch (error) {
      return "NOT_FOUND";
    }
  }
  Future<String?> getRole() async {
    try {
      final jwtToken = await storage.read(key: 'role');
      return jwtToken;
    } catch (error) {
      return "NOT_FOUND";
    }
  }

  Future<void> saveJwtToken(String token) async {
    await storage.write(key: 'jwt_token', value: token);
  }

  Future<void> logout() async {
    await storage.deleteAll();
  }

  Future<void> saveRole(String token) async {
    await storage.write(key: 'role', value: token);
  }
  Future<void> saveUserId(int token) async {
    await storage.write(key: 'userId', value: token.toString());
  }

  Future<String> purchaseNote(int? id) async {

      final jwtToken = await getJwtToken();
      final response = await http.post(
        Uri.parse('${Constants.apiBaseUrl}/api/user/note/purchase?id=$id'),
        headers: {
          'Authorization': 'Bearer $jwtToken',
          'Content-Type': 'application/json',
        },
      );

      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return jsonResponse['data']['msg'];
      } else {
        print(jsonResponse);
        return jsonResponse['message'];
      }

  }

  Future<Map<String, dynamic>> loginRequest(dynamic body) async {
    final response = await http.post(
      Uri.parse('${Constants.apiBaseUrl}/api/auth/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );
    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      await saveJwtToken(jsonResponse['data']['jwt']);
      await saveRole(jsonResponse['data']['role']);

      await getUserDetails();
    }
    return jsonResponse;
  }


  Future<Map<String, dynamic>> registerRequest(dynamic body) async {
    final response = await http.post(
      Uri.parse('${Constants.apiBaseUrl}/api/auth/register'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );
    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      await saveJwtToken(jsonResponse['data']['jwt']);
      await saveRole(jsonResponse['data']['role']);

      await getUserDetails();
    }
    return jsonResponse;
  }

  Future<UserDTO> getUserDetails() async {
    final jwtToken = await getJwtToken();
    final response = await http.get(
      Uri.parse('${Constants.apiBaseUrl}/api/user/getUserDetails'),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 401) {
      throw CustomException("NEED_LOGIN");
    }
    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    UserDTO result = UserDTO.fromJson(jsonResponse['data']);
    saveUserId(result.id!);
    return result;
  }

  Future<CategoryDTOListResponse> getCategories() async{
    final jwtToken = await getJwtToken();
    final response = await http.get(
      Uri.parse('${Constants.apiBaseUrl}/api/user/category'),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 401) {
      throw CustomException("NEED_LOGIN");
    }
    print(response.body);
    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    print("test");
    return CategoryDTOListResponse.fromJson(jsonResponse);
  }

  Future<String> createCategory(String name) async{
    final jwtToken = await getJwtToken();
    final response = await http.post(
      Uri.parse('${Constants.apiBaseUrl}/api/admin/category?name=$name'),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 401) {
      throw CustomException("NEED_LOGIN");
    }
    if(response.statusCode == 200){
      return "ok";
    }
    return "-1";
  }
  Future<String> updatecategory(String name,int id) async{
    final jwtToken = await getJwtToken();
    final response = await http.put(
      Uri.parse('${Constants.apiBaseUrl}/api/admin/category?name=$name&id=$id'),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 401) {
      throw CustomException("NEED_LOGIN");
    }
    if(response.statusCode == 200){
      return "ok";
    }
    return "-1";
  }
  Future<String> deletecategory(int id) async{
    final jwtToken = await getJwtToken();
    final response = await http.delete(
      Uri.parse('${Constants.apiBaseUrl}/api/admin/category?id=$id'),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 401) {
      throw CustomException("NEED_LOGIN");
    }
    if(response.statusCode == 200){
      return "ok";
    }
    return "-1";
  }
  Future<String> deleteReview(int id) async{
    final jwtToken = await getJwtToken();
    final response = await http.delete(
      Uri.parse('${Constants.apiBaseUrl}/api/user/note/review?id=$id'),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 401) {
      throw CustomException("NEED_LOGIN");
    }
    if(response.statusCode == 200){
      return "ok";
    }
    return "-1";
  }

  Future<PostDTOListResponse> getPosts(int limit, int offset, int id,String text) async {
    final jwtToken = await getJwtToken();
    print("bis");
    String uri = '${Constants.apiBaseUrl}/api/user/post?offset=$offset&limit=$limit&categoryId=$id';

    if(text != null && text != ""){
      uri = uri+"&key=$text";
      print(uri);
    }
    final response = await http.get(
      Uri.parse(uri),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 401) {
      throw CustomException("NEED_LOGIN");
    }
    print("buradayim");
    print(response.body);
    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    print("test");
    return PostDTOListResponse.fromJson(jsonResponse);

  }

  Future<NoteDTOListResponse> getNotes(int limit, int offset,String text,bool _switchValue) async {
    final jwtToken = await getJwtToken();
    print("bis");
    String uri = '${Constants.apiBaseUrl}/api/user/note?offset=$offset&limit=$limit';

    if(text != null && text != ""){
      uri = uri+"&key=$text";
      print(uri);
    }
    if(_switchValue != null && _switchValue){
      uri = uri+"&waiting=true";
    }
    final response = await http.get(
      Uri.parse(uri),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 401) {
      throw CustomException("NEED_LOGIN");
    }
    print(response.body);
    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    return NoteDTOListResponse.fromJson(jsonResponse);

  }

  Future<UserDTOListResponse> getUsers() async {
    final jwtToken = await getJwtToken();
    String uri = '${Constants.apiBaseUrl}/api/admin/users';
    final response = await http.get(
      Uri.parse(uri),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 401) {
      throw CustomException("NEED_LOGIN");
    }
    Map<String, dynamic> jsonResponse = jsonDecode(response.body);
    print(response.body);
    return UserDTOListResponse.fromJson(jsonResponse);

  }
  Future<NoteDTO> getnotebyid(int id) async {
    final jwtToken = await getJwtToken();
    String uri = '${Constants.apiBaseUrl}/api/user/note/detail?id=$id';
    final response = await http.get(
      Uri.parse(uri),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 401) {
      throw CustomException("NEED_LOGIN");
    }
    print(response.body);
    Map<String, dynamic> jsonResponse = jsonDecode(response.body);

    return NoteDTO.fromJson(jsonResponse['data']);

  }



  Future<String> shareNote(Map<String, dynamic> body) async {
    final jwtToken = await getJwtToken();
    String uri = '${Constants.apiBaseUrl}/api/user/note';

    print('Sending JSON body: ${jsonEncode(body)}');

    final response = await http.post(
      Uri.parse(uri),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return 'ok';
    } else {
      return "-1";
    }
  }
  Future<String> sharePost(Map<String, dynamic> body) async {
    final jwtToken = await getJwtToken();
    String uri = '${Constants.apiBaseUrl}/api/user/post';

    print('Sending JSON body: ${jsonEncode(body)}');

    final response = await http.post(
      Uri.parse(uri),
      headers: {
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return 'ok';
    } else {
      throw CustomException('-1');
    }
  }
  Future<int> uploadImage(ImageFile imageFile) async {
    try {
      final jwtToken = await getJwtToken();
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${Constants.apiBaseUrl}/api/user/document'),
      );
      Map<String, String> headers = {
        "Authorization": "Bearer $jwtToken",
        "Content-type": "multipart/form-data"
      };
      if (imageFile.bytes != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'document',
            imageFile.bytes!, // Image bytes
            filename: '${imageFile.name}.${imageFile.extension}',
          ),
        );
      } else if (imageFile.path != null) {
        File file = File(imageFile.path!);
        List<int> imageBytes = await file.readAsBytes();
        request.files.add(
          http.MultipartFile.fromBytes(
            'document',
            imageBytes, // Image bytes
            filename: '${imageFile.name}.${imageFile.extension}',
          ),
        );
      }
      request.headers.addAll(headers);
      var res = await request.send();
      if (res.statusCode == 200) {
        var responseString = await res.stream.bytesToString();
        print(responseString);
        var jsonResponse = json.decode(responseString);
        print(jsonResponse);
        var msgValue = (jsonResponse['data']['additionalInformation']);
        return msgValue;
      }
      return -1;
    } catch (e) {
      print("cactched");
      print(e);
      return -1;
    }
  }

  Future<int> uploadDocument(String filePath) async {
    try {
      final jwtToken = await getJwtToken();
      var uri = Uri.parse('${Constants.apiBaseUrl}/api/user/document');
      var request = http.MultipartRequest('POST', uri);



      File file = File(filePath);
      request.files.add(
          http.MultipartFile(
              'document',
              file.readAsBytes().asStream(),
              file.lengthSync(),
              filename: basename(file.path),
              contentType: MediaType.parse(getMimeType(basename(file.path).split('.').last))
          )
      );

      Map<String, String> headers = {
        "Authorization": "Bearer $jwtToken",
        "Content-type": "multipart/form-data"
      };

      request.headers.addAll(headers);
      var response = await request.send();
      var responseString = await response.stream.bytesToString();
      var jsonResponse = json.decode(responseString);
      print(jsonResponse);

      if (response.statusCode == 200) {
        print(response.statusCode);
        return jsonResponse['data']['additionalInformation'];
      } else {
        print("Failed to upload material. Status code: ${response.statusCode}. Response: $responseString");
        return -1;
      }
    } catch (e) {
      print("Error uploading material: $e");
      return -1;
    }
  }

  String getMimeType(String extension) {
    switch (extension.toLowerCase()) {
      case 'pdf':
        return 'application/pdf';
      case 'epub':
        return 'application/epub+zip';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'html':
        return 'text/html';
      case 'txt':
        return 'text/plain';
      default:
        return 'application/octet-stream';
    }
  }
  Future<String> deletePost(int? id) async {
    try {
      final jwtToken = await getJwtToken();
      /*
      var uri=Uri.parse('${Constants.apiBaseUrl}//api/user/post?id=$id');

      Map<String, String> headers = {
        "Authorization": "Bearer $jwtToken",
        "Content-type": "application/json"
      };

      final response = await http.delete(uri, headers: headers);
*/

      final response= await http.delete(Uri.parse('${Constants.apiBaseUrl}/api/user/post?id=$id'),headers: {
        "Authorization": "Bearer $jwtToken",
        "Content-type": "application/json"
      },

      );
      if (response.statusCode == 200) {
        return '200';
      } else {
        return '400';
      }
    } catch (e) {
      return '400';
    }
  }

  Future<String> addComment(int? id, String? comment) async {
    try {
      final jwtToken = await getJwtToken();
      final response = await http.post(
        Uri.parse('${Constants.apiBaseUrl}/api/user/post/comment?id=$id&comment=$comment'),
        headers: {
          'Authorization': 'Bearer $jwtToken',
          'Content-Type': 'application/json',
        }

      );

      if (response.statusCode == 200) {
        return '200';
      } else {
        throw CustomException('Failed to add comment: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw CustomException('Error adding comment: $e');
    }
  }

  Future<String> likePost(int? id) async {
    try {
      final jwtToken = await getJwtToken();
      final response = await http.post(
        Uri.parse('${Constants.apiBaseUrl}/api/user/post/like?id=$id'),
        headers: {
          'Authorization': 'Bearer $jwtToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return '200';
      } else {
        throw CustomException('Failed to like post: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw CustomException('Error liking post: $e');
    }
  }

  Future<String> dislikePost(int? id) async {
    try {
      final jwtToken = await getJwtToken();
      final response = await http.post(
        Uri.parse('${Constants.apiBaseUrl}/api/user/post/dislike?id=$id'),
        headers: {
          'Authorization': 'Bearer $jwtToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return '200';
      } else {
        throw CustomException('Failed to dislike post: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw CustomException('Error disliking post: $e');
    }
  }

  Future<String> addReview(int? id, String? content, String? type) async {
    try {
      final jwtToken = await getJwtToken();
      final response = await http.post(
        Uri.parse('${Constants.apiBaseUrl}/api/user/note/review?id=$id&content=$content&type=$type'),
        headers: {
          'Authorization': 'Bearer $jwtToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return '200';
      } else {
        throw CustomException('Failed to add review: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw CustomException('Error adding review: $e');
    }
  }

  Future<String> deleteNote(int? id) async {
    try {
      final jwtToken = await getJwtToken();
      final response = await http.delete(
        Uri.parse('${Constants.apiBaseUrl}/api/user/note/?id=$id'),
        headers: {
          'Authorization': 'Bearer $jwtToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return 'ok';
      } else {
        throw CustomException('Failed to delete note: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw CustomException('Error deleting note: $e');
    }
  }

  Future<String> approveNote(int? id) async {
    try {
      final jwtToken = await getJwtToken();
      final response = await http.post(
        Uri.parse('${Constants.apiBaseUrl}/api/admin/note/?id=$id'),
        headers: {
          'Authorization': 'Bearer $jwtToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return 'ok';
      } else {
        throw CustomException('Failed to approve note: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw CustomException('Error approving note: $e');
    }
  }


}

class CustomException implements Exception {
  final String message;

  CustomException(this.message);
}
