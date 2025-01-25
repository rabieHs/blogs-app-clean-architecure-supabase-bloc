import 'package:blogs_supabase/Features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blogs_supabase/Features/blog/presentation/widgets/blog_card.dart';
import 'package:blogs_supabase/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blogs_supabase/core/common/widgets/loader.dart';
import 'package:blogs_supabase/core/theme/app_palette.dart';
import 'package:blogs_supabase/core/utils/show_snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'add_blog.dart';

class BlogPage extends StatefulWidget {
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  @override
  void initState() {
    context.read<BlogBloc>().add(BlogFetchAllBlogs());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Blogs"),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.add_circled),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AddBlogPage()));
            },
          )
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackBar(context, state.error);
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return Loader();
          }

          if (state is BlogDisplaySuccess) {
            return ListView.builder(
                itemCount: state.blogs.length,
                itemBuilder: (context, index) {
                  return BlogCard(
                    blog: state.blogs[index],
                    color: AppPallete
                        .cardColors[index % AppPallete.cardColors.length],
                  );
                });
          }
          return const SizedBox();
        },
      ),
    );
  }
}
