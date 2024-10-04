import 'package:flutter/material.dart';
import 'package:homehunt/services/database.dart';
import 'package:homehunt/widget/support_widget.dart';

class EditRoomScreen extends StatefulWidget {
  final String collectionName;
  final String docID;
  final String images;
  final String title;
  final String description;
  final String address;
  final String price;
  final String maxGuests;
  final String status;

  EditRoomScreen({
    required this.collectionName,
    required this.docID,
    required this.images,
    required this.title,
    required this.description,
    required this.address,
    required this.price,
    required this.maxGuests,
    required this.status,
  });

  @override
  _EditRoomScreenState createState() => _EditRoomScreenState();
}

class _EditRoomScreenState extends State<EditRoomScreen> {
  final titleController = TextEditingController();
  final descController = TextEditingController();
  final addressController = TextEditingController();
  final priceController = TextEditingController();
  final maxGuestsController = TextEditingController();
  String? status;

  @override
  void initState() {
    super.initState();
    // Initialize text controllers with the current room details
    titleController.text = widget.title;
    descController.text = widget.description;
    addressController.text = widget.address;
    priceController.text = widget.price;
    maxGuestsController.text = widget.maxGuests;
    status = widget.status; // Set the initial status
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Room"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _updateRoom,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Title"),
            TextField(controller: titleController),
            SizedBox(height: 10),
            Text("Description"),
            TextField(controller: descController),
            SizedBox(height: 10),
            Text("Address"),
            TextField(controller: addressController),
            SizedBox(height: 10),
            Text("Price"),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            Text("Max Guests"),
            TextField(
              controller: maxGuestsController,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),
            Text("Status"),
            DropdownButton<String>(
              value: status,
              items: <String>['Available', 'Not Available'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  status = newValue!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateRoom() async {
    // Prepare the data to update in Firestore
    Map<String, dynamic> updatedData = {
      "Title": titleController.text,
      "Description": descController.text,
      "Address": addressController.text,
      "Price": priceController.text,
      "MaxGuests": maxGuestsController.text,
      "Status": status,
      "Image": widget.images, // Assuming the image URL doesn't change
    };

    try {
      // Update the document in Firestore
      await DatabaseMethods().updateRoomItem(widget.collectionName, widget.docID, updatedData);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Room updated successfully.")));
      Navigator.pop(context); // Go back to the previous screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error updating room: $e")));
    }
  }
}

