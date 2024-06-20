import 'dart:async';

import 'package:client/features/service/pages/service_form.dart';
import 'package:client/model/user.dart';
import 'package:client/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:client/repository/service_repository.dart';
import 'package:client/model/service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../model/category.dart';
import '../../../repository/category_repository.dart';
import '../services_list_view.dart';
import '../services_theme.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServicesScreen extends StatefulWidget {
  @override
  _ServicesScreenState createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> with TickerProviderStateMixin {
  AnimationController? animationController;
  final ScrollController _scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();
  List<Category> categories = [];
  int? selectedCategoryId;
  late Future<String> role;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);
    _loadCategories();
    role = _getUserRole();
  }

  Future<String> _getUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token')!;
    final int userId = JwtDecoder.decode(token)['sub'];
    final UserRepository userRepository = UserRepository();
    try {
      User user = await userRepository.getUser(userId);
      return user.role;
    } catch (e) {
      print("Error fetching user: $e");
      return "Error fetching user";
    }
  }

  void _loadCategories() async {
    categories = await CategoryRepository().getCategorys();
    selectedCategoryId = null;
    setState(() {});
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  Widget buildSearchBar(Function(String) onSearchChanged) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextField(
        controller: searchController,
        decoration: const InputDecoration(
          labelText: 'Search',
          hintText: 'Enter service name',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
        ),
        onChanged: onSearchChanged,
      ),
    );
  }

  Widget buildCategorySelector(Function(int?) onCategoryChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: DropdownButtonFormField<int?>(
        value: selectedCategoryId,
        decoration: const InputDecoration(
          labelText: 'Catégorie',
          border: OutlineInputBorder(),
        ),
        onChanged: onCategoryChanged,
        items: [
          const DropdownMenuItem<int?>(
            value: null,
            child: Text("Tous"),
          ),
          ...categories.map<DropdownMenuItem<int?>>((Category category) {
            return DropdownMenuItem<int?>(
              value: category.id,
              child: Text(category.name),
            );
          }).toList(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ServiceTheme.buildLightTheme(),
      child: Scaffold(
        body: Column(
          children: [
            buildSearchBar((query) => setState(() {})),
            buildCategorySelector((categoryId) {
              selectedCategoryId = categoryId;
              setState(() {});
            }),
            Expanded(
              child: ServiceList(
                searchQuery: searchController.text,
                selectedCategoryId: selectedCategoryId,
                animationController: animationController,
              ),
            ),
          ],
        ),
        floatingActionButton: FutureBuilder<String>(
          future: role,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(); // Return an empty container while waiting
            }
            if (snapshot.hasData && snapshot.data == "provider") {
              return FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ServiceForm()),
                  ).then((value) {
                    setState(() {});
                  });
                },
                backgroundColor: AppColors.pink,
                child: const Icon(Icons.add, color: Colors.white),
              );
            } else {
              return Container();
            }
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      ),
    );
  }
}

class ServiceList extends StatelessWidget {
  final String searchQuery;
  final int? selectedCategoryId;
  final AnimationController? animationController;

  const ServiceList({super.key, required this.searchQuery, required this.selectedCategoryId, this.animationController});

  Future<String> getUserRole(userId) async {
    final UserRepository userRepository = UserRepository();
    try {
      User user = await userRepository.getUser(userId);
      return user.role;
    } catch (e) {
      print("Error fetching user: $e");
      return "Error fetching user";
    }
  }

  Future<List<Service>> getServices() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token')!;
    final int userId = JwtDecoder.decode(token)['sub'];
    var role = await getUserRole(userId);

    if(role == "marry") {
      return ServiceRepository().getServices().then((services) {
        return services.where((service) {
          bool categoryMatch = selectedCategoryId == null ||
              service.CategoryID == selectedCategoryId;
          bool nameMatch = searchQuery.isEmpty ||
              service.name!.toLowerCase().contains(searchQuery.toLowerCase());
          return categoryMatch && nameMatch;
        }).toList();
      });
    }else if(role == "provider"){
      return ServiceRepository().getServicesByUserID(userId).then((services) {
        return services.where((service) {
          bool categoryMatch = selectedCategoryId == null ||
              service.CategoryID == selectedCategoryId;
          bool nameMatch = searchQuery.isEmpty ||
              service.name!.toLowerCase().contains(searchQuery.toLowerCase());
          return categoryMatch && nameMatch;
        }).toList();
      });
    } else {
      return Future.value([]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Service>>(
      future: getServices(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              padding: const EdgeInsets.only(top: 8),
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                final int count = snapshot.data!.length > 10 ? 10 : snapshot.data!.length;
                final Animation<double> animation = Tween<double>(
                  begin: 0.0,
                  end: 1.0,
                ).animate(
                  CurvedAnimation(
                    parent: animationController!,
                    curve: Interval(
                      (1 / count) * index,
                      1.0,
                      curve: Curves.fastOutSlowIn,
                    ),
                  ),
                );
                animationController?.forward();
                return ServiceListView(
                  callback: () {},
                  serviceData: snapshot.data![index],
                  animation: animation,
                  animationController: animationController!,
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Erreur : ${snapshot.error}"));
          }
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
