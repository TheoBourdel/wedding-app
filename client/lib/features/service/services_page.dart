import 'package:client/features/service/pages/service_form.dart';
import 'package:client/model/user.dart';
import 'package:client/repository/user_repository.dart';
import 'package:flutter/material.dart';
import 'package:client/repository/service_repository.dart';
import 'package:client/model/service.dart';
import '../../core/theme/app_colors.dart';
import 'services_list_view.dart';
import 'services_theme.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProviderServicesScreen extends StatefulWidget {
  @override
  _ProviderServicesScreenState createState() => _ProviderServicesScreenState();
}

class _ProviderServicesScreenState extends State<ProviderServicesScreen> with TickerProviderStateMixin {
  AnimationController? animationController;
  Future<List<Service>>? futureServiceList;
  final UserRepository userRepository = UserRepository();
  final ScrollController _scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();
  List<Service> filteredServices = [];

  void initState() {
    super.initState();
    animationController = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);
    getServices();
  }

  Future<String> getUser(int userId) async {
    try {
      User user = await userRepository.getUser(userId);
      return user.role;
    } catch (e) {
      print("Error fetching user: $e");
      return "Error fetching user";
    }
  }

  Widget buildSearchBar() {
    return Padding(
      padding: EdgeInsets.all(8),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          labelText: 'Search',
          hintText: 'Enter service name',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
        ),
        onChanged: (value) => filterSearchResults(value),
      ),
    );
  }

  void filterSearchResults(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredServices = [];
      });
      return;
    }

    List<Service> dummyListData = [];
    futureServiceList?.then((serviceList) {
      dummyListData.addAll(
          serviceList!.where((item) =>
          (item.name?.toLowerCase().contains(query.toLowerCase())) ?? false
          )
      );
      setState(() {
        filteredServices = dummyListData;
      });
    });
  }

  void getServices({String searchQuery = ''}) {
    SharedPreferences.getInstance().then((prefs) async {
      final String token = prefs.getString('token')!;
      final int userId = JwtDecoder.decode(token)['sub'];
      var role = await getUser(userId);
      setState(() {
        if(role == "provider"){
          futureServiceList = ServiceRepository().getServicesByUserID(userId).then((services) {
            return services.where((service) => service.name?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false).toList();
          });
        }else if(role == "marry"){
          futureServiceList = ServiceRepository().getServices().then((services) {
            return services.where((service) => service.name?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false).toList();
          });
        }else{
          print("error no services found");
        }
      });
    });
  }



  /*void getServices() {
    SharedPreferences.getInstance().then((prefs) async {
      final String token = prefs.getString('token')!;
      final int userId = JwtDecoder.decode(token)['sub'];
      var role = await getUser(userId);
      setState(() {
        if(role == "provider"){
          futureServiceList = ServiceRepository().getServicesByUserID(userId);
        }else if(role == "marry"){
          futureServiceList = ServiceRepository().getServices();
        }else{
          print("error no services found");
        }
      });
    });
  }*/

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
        body: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[];
          },
          body: FutureBuilder<List<Service>>(
            future: futureServiceList,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      buildSearchBar(),
                      if (filteredServices.isNotEmpty)
                        Expanded(child: buildServiceList(filteredServices))
                      else
                        Expanded(child: buildServiceList(snapshot.data!)),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text("Erreur : ${snapshot.error}"));
                }
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ServiceForm()),
            ).then((currentService) {
              if (currentService != null) {
                getServices();
              }
            });
          },
          backgroundColor: AppColors.pink,
          child: Icon(Icons.add, color: Colors.white),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      ),
    );
  }

  Widget buildServiceList(List<Service> services) {
    return ListView.builder(
      itemCount: services.length,
      padding: const EdgeInsets.only(top: 8),
      scrollDirection: Axis.vertical,
      itemBuilder: (BuildContext context, int index) {
        final int count = services.length > 10 ? 10 : services.length;
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
          serviceData: services[index],
          animation: animation,
          animationController: animationController!,
        );
      },
    );
  }

  Widget getFilterBarUI(int serviceCount) {
    return Container(
      color: ServiceTheme.buildLightTheme().backgroundColor,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 4),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '$serviceCount services found',
                  style: TextStyle(
                    fontWeight: FontWeight.w100,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                focusColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                splashColor: Colors.grey.withOpacity(0.2),
                borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'Filter',
                        style: TextStyle(
                          fontWeight: FontWeight.w100,
                          fontSize: 16,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.sort, color: ServiceTheme.buildLightTheme().primaryColor),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ContestTabHeader extends SliverPersistentHeaderDelegate {
  final Widget searchUI;
  ContestTabHeader(this.searchUI);

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return searchUI;
  }

  @override
  double get maxExtent => 52.0;

  @override
  double get minExtent => 52.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
