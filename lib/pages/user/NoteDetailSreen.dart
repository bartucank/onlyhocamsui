import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onlyhocamsui/models/NoteDTO.dart';
import 'package:onlyhocamsui/pages/user/PdfViewer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:comment_tree/comment_tree.dart';

import 'package:http/http.dart' as http;

import '../../models/ReviewDTO.dart';
import '../../service/ApiService.dart';
import '../../service/constants.dart';
import 'dart:ui' as ui;

class NoteDetailScreen extends StatefulWidget {
  final NoteDTO note;
  final bool isAdmin;
  final bool isOwner;

  const NoteDetailScreen(
      {Key? key,
      required this.note,
      required this.isAdmin,
      required this.isOwner})
      : super(key: key);

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  String _comment = '';
  final _formKey = GlobalKey<FormState>();
  final ApiService apiService = ApiService();
  bool isLoading = false;
  List<ReviewDTO> reviews = [];
  int displayCount = 10;
  bool isFavorite = false;
  Future<void> askperm() async {

    PermissionStatus firststatus = await Permission.storage.request();
  }
  @override
  void initState() {
    super.initState();
    askperm();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Column(

          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if(widget.isAdmin || widget.isOwner)
              FloatingActionButton(
                onPressed: () async {
                  //todo: delete api call
                },
                child: Icon(FontAwesomeIcons.trash,color: Colors.red,),
                backgroundColor: Constants.whiteColor,
              ),

          ],
        ),

        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Constants.mainBlueColor,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                      child: Text(
                        widget.note.title ?? 'N/A',
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 2, 15, 5),
                      child: Text(
                        'by ${widget.note.user!.name!?.toUpperCase()}' ?? '',
                        style: const TextStyle(
                          fontSize: 15,
                          color: Constants.greyColor,
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1, // Adjust the number of lines as needed
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                      child: Text(
                        widget.note.content ?? 'N/A',
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if (widget.note.isPurchased != null &&
                              widget.note.isPurchased!)
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            onPressed: () async {
                              await showDialog<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: SingleChildScrollView(
                                      // Make the dialog content scrollable
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Stack(
                                            clipBehavior: Clip.none,
                                            children: [
                                              Positioned(
                                                top: 50,
                                                left: 0,
                                                right: 0,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Container(
                                                      width: 50,
                                                      height: 50,
                                                      child: InkResponse(
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Form(
                                                key: _formKey,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8),
                                                      child: TextFormField(
                                                        maxLines: 3,
                                                        onSaved: (val) {
                                                          _comment =
                                                              (val ?? '');
                                                          print(
                                                              'Comment: $_comment');
                                                        },
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8),
                                                      child: ElevatedButton(
                                                        child: const Text(
                                                            'Submit'),
                                                        onPressed: () {
                                                          if (_formKey
                                                              .currentState!
                                                              .validate()) {
                                                            _formKey
                                                                .currentState!
                                                                .save();
                                                            //todo: add review api call
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            icon: const Icon(
                              Icons.star,
                              color: Constants.yellowColor,
                            ),
                            label: const Text('Add Review'),
                          ),
                       if (widget.note.document != null && widget.note.document!.data != null)
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            onPressed: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => PdfViewer(data: widget.note.document!.data!)),
                              );
                            },
                            icon: const Icon(
                              FontAwesomeIcons.filePdf,
                              color: Colors.green,
                            ),
                            label: const Text('Open Note'),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if (widget.note.status != "APPROVED" && widget.isAdmin)
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            onPressed: () async {
                              //todo: approve api call
                            },
                            icon: const Icon(
                              FontAwesomeIcons.check,
                              color: Colors.green,
                            ),
                            label: const Text('Approve'),
                          ),

                        ],
                      ),
                    Divider(
                      height: 20,
                    ),
                    if (widget.note.reviews!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Reviews',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Constants.mainBlueColor),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    Column(
                      children: widget.note.reviews!.map((review) {
                        return Container(
                          child: CommentTreeWidget<Comment, Comment>(
                            Comment(
                              avatar: 'null',
                              userName: review.user!.name,
                              content: review.content ?? 'No comment',
                            ),
                            [],
                            treeThemeData: TreeThemeData(
                              lineColor: Constants.mainBlueColor,
                              lineWidth: 0,
                            ),
                            avatarRoot: (context, data) => PreferredSize(
                              child: CircleAvatar(
                                radius: 18,
                                backgroundColor: Colors.grey,
                                backgroundImage:
                                    AssetImage('assets/images/default.png'),
                              ),
                              preferredSize: Size.fromRadius(18),
                            ),
                            contentRoot: (context, data) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 4),
                                        Text(
                                          '${data.content}',
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 16),
                        );
                      }).toList(),
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
