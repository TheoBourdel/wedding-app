import 'package:client/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class GuestPage extends StatefulWidget {
  const GuestPage({super.key});

  @override
  State<GuestPage> createState() => _GuestPageState();
}

class _GuestPageState extends State<GuestPage> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          bottom: TabBar(
            dividerColor: Colors.transparent,
            unselectedLabelColor: AppColors.pink,
            labelColor: Colors.white,
            indicator: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: AppColors.pink,
            ),
            tabs: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Tab(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: Border.all(color: AppColors.pink, width: 0),
                    ),
                    child: const Align(
                      alignment: Alignment.center,
                      child: Text("Tout"),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Tab(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: Border.all(color: AppColors.pink, width: 1),
                    ),
                    child: const Align(
                      alignment: Alignment.center,
                      child: Text("Confirmés"),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: Tab(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      border: Border.all(color: AppColors.pink, width: 1),
                    ),
                    child: const Align(
                      alignment: Alignment.center,
                      child: Text("Annulés"),
                    ),
                  ),
                ),
              ),
            ],
          ),
          centerTitle: false,
          title: const Text('Invités'),
          titleTextStyle: const TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        body: const TabBarView(
          children: [
            Text('Tout'),
            Text('Confirmés'),
            Text('Annulés'),
          ],
        ),
      ),
    );
  }
}