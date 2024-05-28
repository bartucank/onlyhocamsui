import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:onlyhocamsui/models/NoteDTO.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:comment_tree/comment_tree.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

import '../../models/ReviewDTO.dart';
import '../../service/ApiService.dart';
import '../../service/constants.dart';
import 'dart:ui' as ui;
import 'dart:io';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:filesaverz/filesaverz.dart';


class PdfViewer extends StatefulWidget {
  final Uint8List data;

  const PdfViewer(
      {Key? key,
      required this.data})
      : super(key: key);

  @override
  State<PdfViewer> createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  PdfViewerController controller = PdfViewerController();
  void save()async{

    PermissionStatus secondstatus = await Permission.manageExternalStorage.request();

    if ((secondstatus == null || secondstatus.isGranted)) {

      FileSaver fileSaver = FileSaver(
        initialFileName: 'New File',
        fileTypes: const ['pdf'],
      );
      final random = Random();
      final randomInt = random.nextInt(10000);
      final directory = await getApplicationDocumentsDirectory();
      print(directory.path);
      final path ='${directory.path}/note_$randomInt.pdf';
      final file = File(path);
      await file.writeAsBytes(widget.data);
      try{
        // await FileSaver.instance.saveFile(name: "note_$randomInt.pdf",
        //     file: file,
        //     mimeType: MimeType.pdf);
        List<int> last = await controller.saveDocument();
        await fileSaver.writeAsBytes(last, context: context);

      }catch (e){
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error :( Please contact with system admin.')),
        );
      }
    }


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

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
          actions: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
              child: GestureDetector(
                  onTap: (){
                    save();
                  },
                  child: Icon(FontAwesomeIcons.solidFloppyDisk,color: Colors.white,)),
            )
          ],
        ),
        body:                       Padding(padding: const EdgeInsets.all(15),
          child:SfPdfViewer.memory(widget.data,controller:controller ,),
        ));
  }
}
