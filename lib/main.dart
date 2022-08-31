import 'dart:developer';

import 'package:api_call_sample/api_repo.dart';
import 'package:api_call_sample/error_model.dart';
import 'package:api_call_sample/post.dart';
import 'package:api_call_sample/product.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: FutureBuilder<Either<Error, List<Post>>>(
          future: ApiRepo().fetchPosts,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator.adaptive());
            }
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                Either<Error, List<Post>> result = snapshot.data!;
                if (result.isLeft) {
                  Error error = result.left;
                  return Center(
                    child: Text(error.message!),
                  );
                } else {
                  List<Post> posts = result.right;
                  return ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (ctx, index) {
                        return ListTile(
                          title: Text(
                            posts[index].title!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            posts[index].body!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      });
                }
              } else {
                return const SizedBox.shrink();
              }
            }
            return const Text("body");
          }),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: (() {
            _addProduct();
          })), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _addProduct() async {
    Product product = const Product(
        title: "My title",
        category: "Tech",
        description: "This is just a simple description",
        id: 23,
        image: "https://i.pravatar.cc",
        price: 100);
    var result = await ApiRepo().addProduct(product);
    if (result.isLeft) {
      Error error = result.left;
      log("Error: ${error.message}");
    } else {
      Product pro = result.right;
      log("Success: ${pro.toMap()}");
    }
  }
}
