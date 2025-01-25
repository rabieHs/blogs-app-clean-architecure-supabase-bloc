import 'package:hive/hive.dart';

import '../models/blog_model.dart';

abstract interface class BlogLocalDatasource {
  void cacheBlogs({required List<BlogModel> blogs});
  List<BlogModel> getCachedBlogs();
}

class BlogLocalDatasourceImpl implements BlogLocalDatasource {
  final Box box;

  BlogLocalDatasourceImpl({required this.box});
  @override
  void cacheBlogs({required List<BlogModel> blogs}) {
    box.clear();
    box.write(() {
      for (int i = 0; i < blogs.length; i++) {
        box.put(i.toString(), blogs[i].toMap());
      }
    });
  }

  @override
  List<BlogModel> getCachedBlogs() {
    List<BlogModel> blogs = [];
    box.read(() {
      for (int i = 0; i < box.length; i++) {
        blogs.add(BlogModel.fromMap(box.get(i.toString())));
      }
    });
    return blogs;
  }
}
