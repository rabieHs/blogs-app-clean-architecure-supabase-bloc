import 'dart:io';

import 'package:blogs_supabase/Features/blog/presentation/bloc/blog_bloc.dart';
import 'package:blogs_supabase/Features/blog/presentation/pages/blog_page.dart';
import 'package:blogs_supabase/Features/blog/presentation/widgets/blog_editor.dart';
import 'package:blogs_supabase/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blogs_supabase/core/common/widgets/loader.dart';
import 'package:blogs_supabase/core/theme/app_palette.dart';
import 'package:blogs_supabase/core/utils/pick_image.dart';
import 'package:blogs_supabase/core/utils/show_snackbar.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddBlogPage extends StatefulWidget {
  const AddBlogPage({super.key});

  @override
  State<AddBlogPage> createState() => _AddBlogPageState();
}

class _AddBlogPageState extends State<AddBlogPage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  File? image;

  List<String> selectedTopics = [];

  void pickImage() async {
    final pickedImage = await selectImage();

    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }

  void upload() {
    if (formKey.currentState!.validate() &&
        selectedTopics.isNotEmpty &&
        image != null) {
      final posterId =
          (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
      context.read<BlogBloc>().add(BlogUpload(
          posterId: posterId,
          title: titleController.text.trim(),
          content: contentController.text.trim(),
          topics: selectedTopics,
          image: image!));
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(icon: const Icon(Icons.done_rounded), onPressed: upload)
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackBar(context, state.error);
          }

          if (state is BlogUploadSuccess) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const BlogPage()),
                (route) => false);
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Loader();
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    image != null
                        ? GestureDetector(
                            onTap: pickImage,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                image!,
                                height: 150,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: pickImage,
                            child: DottedBorder(
                                strokeCap: StrokeCap.round,
                                radius: const Radius.circular(10),
                                dashPattern: const [10, 4],
                                color: AppPallete.borderColor,
                                borderType: BorderType.RRect,
                                child: const SizedBox(
                                  height: 150,
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.folder_open,
                                        size: 40,
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        "Select Image",
                                        style: TextStyle(fontSize: 15),
                                      )
                                    ],
                                  ),
                                )),
                          ),
                    const SizedBox(
                      height: 20,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          'Technology',
                          'Science',
                          'Health',
                          'Business'
                        ]
                            .map((e) => Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      selectedTopics.contains(e)
                                          ? selectedTopics.remove(e)
                                          : selectedTopics.add(e);
                                      setState(() {});
                                    },
                                    child: Chip(
                                      label: Text(e),
                                      side: selectedTopics.contains(e)
                                          ? null
                                          : const BorderSide(
                                              color: AppPallete.borderColor),
                                      color: selectedTopics.contains(e)
                                          ? const WidgetStatePropertyAll(
                                              AppPallete.gradient1)
                                          : null,
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    BlogEditor(
                        controller: titleController, hintText: 'Blog Title'),
                    const SizedBox(
                      height: 10,
                    ),
                    BlogEditor(
                        controller: contentController,
                        hintText: 'Blog Content'),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
