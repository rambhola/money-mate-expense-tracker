import 'package:flutter/material.dart';

class WeaklyCart extends StatelessWidget {
  const WeaklyCart({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(width * 0.04),

        child: isLandscape
            ///LANDSCAPE VIEW
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _leftCard(context),

                  SizedBox(width: width * 0.04),

                  _rightCards(context),
                ],
              )
            /// PORTRAIT VIEW
            : Row(
                children: [
                  _leftCard(context),

                  SizedBox(height: height * 0.03),

                  _rightCards(context),
                ],
              ),
      ),
    );
  }
}

//// ---------------- LEFT CHART ----------------
Widget _leftCard(BuildContext context) {
  double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height;
  bool isLandscape =
      MediaQuery.of(context).orientation == Orientation.landscape;

  List<double> values = [0.4, 0.8, 0.7, 0.6, 0.4];
  List<String> days = ["M", "T", "W", "T", "F"];

  return Container(
    padding: EdgeInsets.all(isLandscape ? width * 0.01 : width * 0.04),
    decoration: BoxDecoration(
      color: const Color(0xFFF3F3F3),
      borderRadius: BorderRadius.circular(width * 0.05),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// HEADER
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "WEEKLY FLOW",
              style: TextStyle(
                fontSize: isLandscape ? width * 0.02 : width * 0.03,
                color: Colors.grey,
                letterSpacing: 1,
              ),
            ),
            const Icon(Icons.more_horiz, color: Colors.grey),
          ],
        ),

        SizedBox(height: height * 0.03),

        /// CHART
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(5, (index) {
            double barWidth = isLandscape ? width * 0.05 : width * 0.10;
            double barMaxHeight = isLandscape ? height * 0.25 : height * 0.12;

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      width: barWidth,
                      height: barMaxHeight,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0E0E0),
                        borderRadius: BorderRadius.circular(barWidth),
                      ),
                    ),

                    Container(
                      width: barWidth,
                      height: barMaxHeight * values[index],
                      decoration: BoxDecoration(
                        color: index == 2
                            ? Colors.green
                            : const Color(0xFF8FB6D8),
                        borderRadius: BorderRadius.circular(barWidth),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: height * 0.01),

                Text(
                  days[index],
                  style: TextStyle(
                    fontSize: isLandscape ? width * 0.02 : width * 0.03,
                    color: index == 2 ? Colors.green : Colors.black,
                  ),
                ),
              ],
            );
          }),
        ),
      ],
    ),
  );
}

//// ---------------- RIGHT CARDS ----------------
Widget _rightCards(BuildContext context) {
  double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height;
  bool isLandscape =
      MediaQuery.of(context).orientation == Orientation.landscape;

  return Column(
    children: [
      /// FOOD CARD
      Container(
        height: isLandscape ? height * 0.22 : height * 0.11,
        width: isLandscape ? width * 0.25 : width * 0.32,
        margin: EdgeInsets.only(bottom: height * 0.02),
        decoration: BoxDecoration(
          color: const Color(0xFFF6EAEA),
          borderRadius: BorderRadius.circular(
            isLandscape ? width * 0.05 : width * 0.05,
          ),
          border: Border.all(color: Colors.red.shade100),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant, color: Colors.red),
            SizedBox(height: 8),
            Text("Food"),
            Text(
              "₹4,200",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),

      /// TRAVEL CARD
      Container(
        height: isLandscape ? height * 0.22 : height * 0.11,
        width: isLandscape ? width * 0.25 : width * 0.32,
        decoration: BoxDecoration(
          color: const Color(0xFFE8F1FB),
          borderRadius: BorderRadius.circular(width * 0.05),
          border: Border.all(color: Colors.blue.shade100),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.directions_car, color: Colors.blue),
            SizedBox(height: 8),
            Text("Travel"),
            Text(
              "₹1,500",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    ],
  );
}
