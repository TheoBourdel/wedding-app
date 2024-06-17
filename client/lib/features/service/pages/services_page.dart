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

class ProviderServicesScreen extends StatefulWidget {
  @override
  _ProviderServicesScreenState createState() => _ProviderServicesScreenState();
}

class _ProviderServicesScreenState extends State<ProviderServicesScreen> with TickerProviderStateMixin {
  AnimationController? animationController;
  final UserRepository userRepository = UserRepository();
  final ScrollController _scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();
  List<Category> categories = [];
  int? selectedCategoryId;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);
    _loadCategories();
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ServiceForm()),
            ).then((value) {
              // Re-fetch services to update the list after adding a new service
              setState(() {});
            });
          },
          backgroundColor: AppColors.pink,
          child: Icon(Icons.add, color: Colors.white),
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

  ServiceList({required this.searchQuery, required this.selectedCategoryId, this.animationController});

  Future<List<Service>> getServices() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token')!;
    final int userId = JwtDecoder.decode(token)['sub'];

    return ServiceRepository().getServices().then((services) {
      return services.where((service) {
        bool categoryMatch = selectedCategoryId == null || service.CategoryID == selectedCategoryId;
        bool nameMatch = searchQuery.isEmpty || service.name!.toLowerCase().contains(searchQuery.toLowerCase());
        return categoryMatch && nameMatch;
      }).toList();
    });
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
