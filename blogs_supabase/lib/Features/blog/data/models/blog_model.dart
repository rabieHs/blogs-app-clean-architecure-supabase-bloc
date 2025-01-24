import 'dart:convert';

import 'package:blogs_supabase/Features/blog/domain/entities/blog.dart';

class BlogModel extends Blog {
  BlogModel(
      {required super.id,
      required super.poserId,
      required super.title,
      required super.content,
      required super.imageUrl,
      required super.topics,
      required super.updatedAt,
      super.posterName});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'poster_id': poserId,
      'title': title,
      'content': content,
      'image_url': imageUrl,
      'topics': topics,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory BlogModel.fromMap(Map<String, dynamic> map) {
    return BlogModel(
        updatedAt: map['updated_at'] == null
            ? DateTime.now()
            : DateTime.parse(map['updated_at']),
        id: map['id'] as String,
        poserId: map['poster_id'] as String,
        title: map['title'] as String,
        content: map['content'] as String,
        imageUrl: map['image_url'] ?? "",
        topics: List<String>.from(
          (map['topics'] ?? []),
        ));
  }

  BlogModel copyWith(
      {String? id,
      String? poserId,
      String? title,
      String? content,
      String? imageUrl,
      List<String>? topics,
      DateTime? updatedAt,
      String? posterName}) {
    return BlogModel(
        id: id ?? this.id,
        poserId: poserId ?? this.poserId,
        title: title ?? this.title,
        content: content ?? this.content,
        imageUrl: imageUrl ?? this.imageUrl,
        topics: topics ?? this.topics,
        updatedAt: updatedAt ?? this.updatedAt,
        posterName: posterName ?? this.posterName);
  }
}
