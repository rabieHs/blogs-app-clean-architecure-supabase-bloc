import 'package:blogs_supabase/Features/blog/domain/entities/blog.dart';
import 'package:blogs_supabase/core/theme/app_palette.dart';
import 'package:blogs_supabase/core/utils/calculating_reading_time.dart';
import 'package:blogs_supabase/core/utils/format_date.dart';
import 'package:flutter/material.dart';

class BlogViewerPage extends StatelessWidget {
  final Blog blog;
  const BlogViewerPage({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  blog.title,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "BY ${blog.posterName} ",
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 16),
                ),
                Text(
                  "${formatDateByDMMMYYYY(blog.updatedAt)} - ${calculateReadingTime(blog.content)} min",
                  style: const TextStyle(
                      color: AppPallete.greyColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 20,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(blog.imageUrl),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  blog.content,
                  style: const TextStyle(fontSize: 16, height: 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
