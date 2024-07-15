import 'dart:async';
import 'package:client/features/service/widgets/service_form.dart';
import 'package:client/model/user.dart';
import 'package:client/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:client/repository/service_repository.dart';
import 'package:client/model/service.dart';
import '../../../core/theme/app_colors.dart';
import '../../../model/category.dart';
import '../../../repository/category_repository.dart';
import '../widgets/services_theme.dart';
import '../widgets/services_list_view.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyFavoritePage extends StatefulWidget {
  const MyFavoritePage({super.key});

  @override
  _MyFavoritePageState createState() => _MyFavoritePageState();
}

class _MyFavoritePageState extends State<MyFavoritePage> with TickerProviderStateMixin {
  AnimationController? animationController;
  TextEditingController searchController = TextEditingController();
  List<Category> categories = [];
  int? selectedCategoryId;
  late Future<String> role;
  List<Service> favoriteServices = [];

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);
    _loadCategories();
    role = _getUserRole();
    _loadFavoriteServices();
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
      return "Error fetching user";
    }
  }

  void _loadCategories() async {
    categories = await CategoryRepository().getCategorys();
    selectedCategoryId = null;
    setState(() {});
  }

  void _loadFavoriteServices() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token')!;
    final int userId = JwtDecoder.decode(token)['sub'];
    favoriteServices = await ServiceRepository.getFavoritesServicesByUserId(userId);
    setState(() {});
  }

  void _removeFavoriteService(int serviceId) {
    setState(() {
      favoriteServices.removeWhere((service) => service.id == serviceId);
    });
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ServiceTheme.buildLightTheme(),
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Mes Prestations",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "Liste des prestations",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4.0),
            child: Container(
              color: Colors.grey[300],
              height: 1.0,
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: favoriteServices.length,
                padding: const EdgeInsets.only(top: 8),
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  final int count = favoriteServices.length > 10 ? 10 : favoriteServices.length;
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
                    serviceData: favoriteServices[index],
                    animation: animation,
                    animationController: animationController!,
                    onFavoriteToggled: _removeFavoriteService,
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FutureBuilder<String>(
          future: role,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container();
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
