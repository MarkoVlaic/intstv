import 'package:flutter/material.dart';

class FloorPlanScreen extends StatelessWidget {
  const FloorPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double imageHorizontalPadding = 50;
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 50, width: double.infinity),
          Text(
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
            'Track and manage your home!',
          ),
          const SizedBox(height: 50, width: double.infinity),
          Stack(
            children: [
              Container(
                color: Colors.red.withOpacity(.5),
                child: Image.asset(
                  'assets/floor_plan/floor_plan_p.png',
                  width: screenSize.width - imageHorizontalPadding,
                ),
              ),
              Positioned(
                top: 50,
                left: 45,
                child: Opacity(
                  opacity: .8,
                  child: SizedBox(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(minimumSize: const Size(30, 40)),
                      onPressed: () => {},
                      child: const Icon(Icons.light),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 103,
                right: 90,
                child: Opacity(
                  opacity: .8,
                  child: SizedBox(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(minimumSize: const Size(30, 40)),
                      onPressed: () => {},
                      child: const Icon(Icons.light),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 170,
                left: 45,
                child: Opacity(
                  opacity: .8,
                  child: SizedBox(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(minimumSize: const Size(30, 40)),
                      onPressed: () => {},
                      child: const Icon(Icons.light),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 80,
                right: 15,
                child: Opacity(
                  opacity: .8,
                  child: SizedBox(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(minimumSize: const Size(30, 40)),
                      onPressed: () => {},
                      child: const Icon(Icons.light),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
