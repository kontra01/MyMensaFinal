import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Container1 extends StatelessWidget {
  int selectedDay = 0;
  DateTime date = DateTime.now();
  int dateFocus = 0; // day = 0; month = 1; year = 2;
  var pageController = PageController(initialPage: 0);
  Container1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Day $selectedDay'),
      ),
      body: Column(
        children: [
          // HeadBar
          Container(
            color: Colors.blue,
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    // Handle previous day swipe
                    pageController.previousPage(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
                Text(
                  'Day $selectedDay',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: () {
                    // Handle next day swipe
                    pageController.nextPage(
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
              ],
            ),
          ),
          // Swipeable Inner Container using PageView
          Expanded(
            child: PageView.builder(
              controller: pageController,
              onPageChanged: (index) {
                selectedDay = index;
              },
              itemBuilder: (context, index) {
                return Container(
                  color: Colors.grey[200],
                  child: Center(
                    child: Text(
                      'Content for Day $index',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
