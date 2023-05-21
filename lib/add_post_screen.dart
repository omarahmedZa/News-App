import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class NewsPostPage extends StatefulWidget {
  @override
  _NewsPostPageState createState() => _NewsPostPageState();
}

class _NewsPostPageState extends State<NewsPostPage> {
  final picker = ImagePicker();
  File? selectedImage;
  GoogleMapController? mapController;
  LatLng? selectedLocation;

  final newsCollection = FirebaseFirestore.instance.collection('news');
  final storage = FirebaseStorage.instance;
  final storageReference = FirebaseStorage.instance.ref().child('news_images');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News Post'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: selectImage,
              child: Text('Select Image'),
            ),
            SizedBox(height: 16.0),
            selectedImage != null
                ? Image.file(selectedImage!)
                : Placeholder(),
            SizedBox(height: 16.0),
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter temperature',
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: GoogleMap(
                onMapCreated: onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: LatLng(0, 0),
                  zoom: 10,
                ),
                onTap: (_) => selectLocation(),
              ),
            ),
            ElevatedButton(
              onPressed: () => saveNewsPost(
                'Sample Title',
                'Sample Description',
                '25°C',
              ),
              child: Text('Save Post'),
            ),
          ],
        ),
      ),
    );
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> selectImage() async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedImage != null) {
        selectedImage = File(pickedImage.path);
      }
    });
  }

  void selectLocation() async {
    LocationData currentLocation;
    var location = Location();

    try {
      currentLocation = await location.getLocation();
    } catch (e) {
      // Handle location access error
      return;
    }

    setState(() {
      selectedLocation = LatLng(
        currentLocation.latitude!,
        currentLocation.longitude!,
      );
    });
  }

  Future<void> saveNewsPost(
      String title,
      String description,
      String temperature,
      ) async {
    if (selectedImage == null || selectedLocation == null) {
      // Handle error, image or location not selected
      return;
    }

    UploadTask uploadTask =
    storageReference.child(selectedImage!.path).putFile(selectedImage!);
    TaskSnapshot storageSnapshot = await uploadTask;
    String imageUrl = await storageSnapshot.ref.getDownloadURL();

    await newsCollection.add({
      'title': title,
      'description': description,
      'temperature': temperature,
      'image_url': imageUrl,
      'location': GeoPoint(
        selectedLocation!.latitude,
        selectedLocation!.longitude,
      ),
    });

    // Success! News post saved to Firestore
    // You can navigate to a different screen or show a success message here
  }
}
