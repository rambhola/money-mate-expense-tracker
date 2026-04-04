import 'package:flutter/material.dart';

class WeaklyCart extends StatelessWidget {
  const WeaklyCart({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: width,
        color: const Color(0xFFF5F5F5),

        child: OrientationBuilder(
          builder: (context, orientation) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(width * 0.04),

                child: orientation == Orientation.portrait

                /// ✅ PORTRAIT FIXED
                    ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: width * 0.6,
                      child: _leftCard(context),
                    ),

                    SizedBox(width: width * 0.04),

                    SizedBox(
                      width: width * 0.32,
                      child: _rightCards(context),
                    ),
                  ],
                )

                /// ✅ LANDSCAPE (already fine)
                    : Column(
                  children: [
                    _leftCard(context),

                    SizedBox(height: height * 0.03),

                    _rightCards(context),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// ---------------- LEFT CARD ----------------
  Widget _leftCard(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      padding: EdgeInsets.all(width * 0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(width * 0.05),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "WEEKLY FLOW",
            style: TextStyle(
              fontSize: width * 0.03,
              color: Colors.grey,
            ),
          ),

          SizedBox(height: height * 0.02),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(5, (index) {
              List<double> heights = [0.05, 0.10, 0.09, 0.08, 0.05];

              return Column(
                children: [
                  Container(
                    width: width * 0.08,
                    height: height * heights[index],
                    decoration: BoxDecoration(
                      color: index == 2
                          ? Colors.green
                          : const Color(0xFF9CC3E6),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(width * 0.05),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    ["M", "T", "W", "T", "F"][index],
                    style: TextStyle(
                      fontSize: width * 0.03,
                      color:
                      index == 2 ? Colors.green : Colors.black,
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

  /// ---------------- RIGHT CARDS ----------------
  Widget _rightCards(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Column(
      children: [
        /// FOOD
        Container(
          height: height * 0.2,
          margin: EdgeInsets.only(bottom: height * 0.02),
          padding: EdgeInsets.all(width * 0.04),
          decoration: BoxDecoration(
            color: const Color(0xFFF8EDED),
            borderRadius: BorderRadius.circular(width * 0.05),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.restaurant,
                  color: Colors.red, size: width * 0.06),
              const SizedBox(height: 8),
              const Text("Food"),
              const Text(
                "₹4,200",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        /// TRAVEL
        Container(
          height: height * 0.2,
          padding: EdgeInsets.all(width * 0.04),
          decoration: BoxDecoration(
            color: const Color(0xFFEAF2FB),
            borderRadius: BorderRadius.circular(width * 0.05),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.directions_car,
                  color: Colors.blue, size: width * 0.06),
              const SizedBox(height: 8),
              const Text("Travel"),
              const Text(
                "₹1,500",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}