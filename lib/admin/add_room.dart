import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:homehunt/services/database.dart';
import 'package:homehunt/widget/support_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class AddRoom extends StatefulWidget {
  const AddRoom({super.key});

  @override
  State<AddRoom> createState() => _AddRoomState();
}

class _AddRoomState extends State<AddRoom> {
  final List<String> roomItems = ['Standard', 'Deluxe', 'Suites', 'Specialty'];
  String? category, status;
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final addressController = TextEditingController();
  final priceController = TextEditingController();
  final maxGuestsController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  Future<void> getImage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  Future<void> uploadItem() async {
    if (selectedImage != null && titleController.text.isNotEmpty &&
        descController.text.isNotEmpty && addressController.text.isNotEmpty &&
        priceController.text.isNotEmpty && maxGuestsController.text.isNotEmpty &&
        status != null) {
      final addId = randomAlphaNumeric(10);
      final firebaseStorageRef = FirebaseStorage.instance.ref().child("Image").child(addId);
      final task = firebaseStorageRef.putFile(selectedImage!);
      final downloadUrl = await (await task).ref.getDownloadURL();

      final addItem = {
        "Image": downloadUrl,
        "Title": titleController.text,
        "Description": descController.text,
        "Address": addressController.text,
        "Price": priceController.text,
        "MaxGuests": maxGuestsController.text,
        "Status": status,
      };

      await DatabaseMethods().addRoomItem(addItem, category!).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text("Room Item has been added Successfully", style: TextStyle(fontSize: 18.0)),
          ),
        );
      });
    }
  }

  Widget buildTextField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Appwidget.semiboldtextfieldstyle()),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(color: Color(0xFFececf8), borderRadius: BorderRadius.circular(10)),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(border: InputBorder.none, hintText: "Enter $label", hintStyle: Appwidget.lighttextfieldstyle()),
          ),
        ),
      ],
    );
  }

  Widget buildDropdown(String label, List<String> items, String? selectedValue, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Appwidget.semiboldtextfieldstyle()),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(color: Color(0xFFececf8), borderRadius: BorderRadius.circular(10)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              items: items.map((item) => DropdownMenuItem(value: item, child: Text(item, style: TextStyle(fontSize: 18, color: Colors.black)))).toList(),
              onChanged: onChanged,
              dropdownColor: Colors.white,
              hint: Text("Select $label"),
              iconSize: 36,
              icon: Icon(Icons.arrow_drop_down, color: Colors.black),
              value: selectedValue,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios_new_outlined, color: Color(0xFF373866)),
        ),
        centerTitle: true,
        title: Text("Add Item", style: Appwidget.HeadlineTextfieldstyle()),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Upload the Item Picture", style: Appwidget.semiboldtextfieldstyle()),
              SizedBox(height: 20),
              GestureDetector(
                onTap: getImage,
                child: Center(
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(border: Border.all(color: Colors.black, width: 1.5), borderRadius: BorderRadius.circular(20)),
                      child: selectedImage == null
                          ? Icon(Icons.camera_alt_outlined, color: Colors.black)
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.file(selectedImage!, fit: BoxFit.cover),
                            ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              buildTextField("Title", titleController),
              SizedBox(height: 30),
              buildTextField("Description", descController, maxLines: 6),
              SizedBox(height: 30),
              buildTextField("Address", addressController),
              SizedBox(height: 30),
              buildTextField("Price", priceController),
              SizedBox(height: 30),
              buildTextField("Maximum Guests", maxGuestsController),
              SizedBox(height: 20),
              buildDropdown("Select Category", roomItems, category, (value) => setState(() => category = value)),
              SizedBox(height: 30),
              buildDropdown("Select Status", ["Available", "Not Available"], status, (value) => setState(() => status = value)),
              SizedBox(height: 30),
              GestureDetector(
                onTap: uploadItem,
                child: Center(
                  child: Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      width: 150,
                      decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10)),
                      child: Center(
                        child: Text("Add", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
