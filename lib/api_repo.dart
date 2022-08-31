import 'dart:convert';
import 'dart:io';

import 'package:api_call_sample/error_model.dart';
import 'package:api_call_sample/network_api.dart';
import 'package:api_call_sample/post.dart';
import 'package:api_call_sample/product.dart';
import 'package:either_dart/either.dart';
import 'package:http/http.dart' as http;

class ApiRepo with BaseApi {
  Future<Either<Error, List<Post>>> get fetchPosts async {
    try {
      var response = await http.get(Uri.parse("$baseUrl/posts"));
      if (response.statusCode == HttpStatus.ok) {
        var decodedResponse = jsonDecode(response.body);
        List<Post> posts = List<Post>.from(
            decodedResponse.map((postItem) => Post.fromMap(postItem)));

        return Right(posts);
      } else {
        return Left(Error(message: response.body, code: response.statusCode));
      }
    } on SocketException {
      return Left(Error(
          message: "Sorry, you don't have an internet connection", code: 400));
    } catch (e) {
      return Left(Error(message: e.toString(), code: 400));
    }
  }

  Future<Either<Error, Product>> addProduct(Product product) async {
    try {
      var response = await http.post(
          Uri.parse("https://fakestoreapi.com/products"),
          body: jsonEncode(product.toMap()));

      if (response.statusCode == HttpStatus.ok) {
        var decodedRepsonse = jsonDecode(response.body);
        var product = Product.fromMap(decodedRepsonse);
        return Right(product);
      } else {
        return Left(Error(message: response.body, code: response.statusCode));
      }
    } on SocketException {
      return Left(Error(
          message: "Sorry, you don't have an internet connection", code: 400));
    } catch (e) {
      return Left(Error(message: e.toString(), code: 400));
    }
  }
}
