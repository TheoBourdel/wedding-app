import 'package:client/core/constant/constant.dart';
import 'package:client/model/service.dart';
import 'package:flutter/material.dart';
import 'package:client/features/service/widgets/details/single_service_details.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unicons/unicons.dart';
import 'package:client/model/image.dart' as serviceImage;
import '../../../core/theme/app_colors.dart';
import '../../../repository/image_repository.dart';
import '../../message/bloc_room/room_bloc.dart';
import '../widgets/service_form.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailsPage extends StatefulWidget {
  final Size size;
  Service serviceData;

  DetailsPage({
    super.key,
    required this.size,
    required this.serviceData,
  });

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  bool extendDetails = true;
  List<serviceImage.Image> images = [];
  bool _isImagesLoaded = false;
  late Service localServiceData;
  late Future<String> role;
  late Future<int> userId;

  @override
  void initState() {
    super.initState();
    _loadImages();
    localServiceData = widget.serviceData;
    role = _getUserRole();
    userId = _getUserId();
  }

  void _loadImages() async {
    if (!_isImagesLoaded) {
      var serviceId = widget.serviceData.id;
      if (serviceId != null) {
        List<serviceImage.Image> loadedImages = await ImageRepository().getServiceImages(serviceId);
        setState(() {
          images = loadedImages;
          _isImagesLoaded = true;
        });
      }
    }
  }

  Future<String> _getUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token')!;
    final Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    print("le rolee");
    print(decodedToken["role"]);
    return decodedToken['role'] ?? 'unknown';
  }

  Future<int> _getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token')!;
    final Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    print("le suub");
    print(decodedToken["sub"]);
    return decodedToken['sub'] ?? 'unknown';
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    Color defaultColor = isDarkMode ? Colors.white : Colors.black;
    Color secondColor = isDarkMode ? Colors.black : Colors.white;
    Service service = localServiceData;
    return Scaffold(
      body: Center(
        child: Container(
          height: size.height,
          width: size.width,
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xff06090d) : const Color(0xfff8f8f8),
          ),
          child: Stack(
            children: [
              buildImageCarousel(size, defaultColor, secondColor),
              buildServiceDetails(
                service,
                defaultColor,
                secondColor,
                extendDetails,
                size,
                service.id!,
              ),
              Positioned(
                top: MediaQuery.of(context).padding.top + 10,
                left: 10,
                child: InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: AppColors.pink,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      UniconsLine.arrow_left,
                      color: secondColor,
                      size: 24,
                    ),
                  ),
                ),
              ),
              FutureBuilder<String>(
                future: role,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container();
                  }
                  if (snapshot.hasData) {
                    List<Widget> actionButtons = [];
                    if (snapshot.data == "provider") {
                      actionButtons.add(
                        Positioned(
                          top: MediaQuery.of(context).padding.top + 10,
                          right: 10,
                          child: InkWell(
                            onTap: _openEditForm,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: AppColors.pink,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                UniconsLine.edit,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                    if (snapshot.data == "marry") {
                      actionButtons.add(
                        Positioned(
                          top: MediaQuery.of(context).padding.top + 10,
                          right: 10,
                          child: InkWell(
                            onTap: () {
                              userId.then((id) {
                                if (id != 0) {
                                  BlocProvider.of<RoomBloc>(context).add(CreateRoomEvent(
                                    widget.serviceData.name ?? 'No Name',
                                    userId: id,
                                    otherUser: widget.serviceData.UserID,
                                  ));
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('User ID is not available')),
                                  );
                                }
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: AppColors.pink,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                UniconsLine.message,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                    return Stack(children: actionButtons);
                  } else {
                    return Container();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildImageCarousel(Size size, Color defaultColor, Color secondColor) {
    double paddingTop = MediaQuery.of(context).padding.top;

    if (images.isEmpty) {
      return Center(child: CircularProgressIndicator(color: defaultColor));
    }

    return Positioned(
      top: paddingTop,
      height: size.height * 0.35,
      width: size.width,
      child: PageView.builder(
        itemCount: images.length,
        itemBuilder: (context, index) {
          var img = images[index];
          var imagePath = apiUrl + (img.path!.startsWith('/') ? img.path! : '/${img.path!}');
          return ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              imagePath,
              fit: BoxFit.cover,
              height: size.height * 0.35,
              width: size.width,
            ),
          );
        },
      ),
    );
  }

  void _openEditForm() async {
    final updatedService = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ServiceForm(currentService: localServiceData),
      ),
    );

    if (updatedService != null) {
      setState(() {
        localServiceData = updatedService;
        _isImagesLoaded = false;
        _loadImages();
      });
    }
  }
}
