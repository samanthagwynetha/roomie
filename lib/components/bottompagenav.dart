import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:homehunt/pages/booking.dart'; // Make sure this is the right Booking page you want to show.
import 'package:homehunt/pages/booking_status.dart'; // The page to check booking status
import 'package:homehunt/pages/home.dart';
import 'package:homehunt/pages/profile.dart';

class Bottompagenav extends StatefulWidget {
  const Bottompagenav({super.key});

  @override
  State<Bottompagenav> createState() => _BottompagenavState();
}

class _BottompagenavState extends State<Bottompagenav> {
  late List<Widget> pages;
  late Home homepage;
  late BookingStatusPage bookingStatusPage; // Use BookingStatusPage for booking status
  late Profile profile;
  int currenttabindex = 0;

  @override
  void initState() {
    super.initState();
    homepage = Home();
    
    // Use the booking status page instead of the original booking page
    bookingStatusPage = BookingStatusPage();
    profile = Profile();
    
    pages = [homepage, bookingStatusPage, profile]; // Make sure the second tab is for booking status
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 65,
        backgroundColor: Colors.white,
        color: Color.fromARGB(255, 0, 0, 0),
        animationDuration: Duration(milliseconds: 500),
        onTap: (int index) {
          setState(() {
            currenttabindex = index;
          });
        },
        items: [
          Icon(Icons.home_outlined, color: Colors.white),
          Icon(Icons.book_online_outlined, color: Colors.white),
          Icon(Icons.person_2_outlined, color: Colors.white),
        ],
      ),
      body: pages[currenttabindex],
    );
  }
}