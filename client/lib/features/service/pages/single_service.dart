import 'dart:developer';
import 'package:client/core/constant/constant.dart';
import 'package:client/model/service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:client/features/service/widgets/details/single_service_details.dart';
import 'package:unicons/unicons.dart';
import 'package:client/model/image.dart' as serviceImage;
import '../../../repository/image_repository.dart';
import '../widgets/details/single_service_details.dart';

class DetailsPage extends StatefulWidget {
  final Size size;
  final Service serviceData;

  const DetailsPage({
    Key? key,
    required this.size,
    required this.serviceData,
  }) : super(key: key);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  bool extendDetails = true;
  List<serviceImage.Image> images = [];
  bool _isImagesLoaded = false;

  @override
  void initState() {
    super.initState();
    print("Service ID: ${widget.serviceData.UserID}");
    _loadImages();
  }

  void _loadImages() async {
    if (!_isImagesLoaded) {
      var serviceId = widget.serviceData?.id;
      if (serviceId != null) {
        List<serviceImage.Image> loadedImages = await ImageRepository().getServiceImages(serviceId);
        setState(() {
          images = loadedImages;
          _isImagesLoaded = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness ==
        Brightness.dark;
    Color defaultColor = isDarkMode ? Colors.white : Colors.black;
    Color secondColor = isDarkMode ? Colors.black : Colors.white;

    Service service = widget.serviceData;
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
              buildHotelDetails(
                service.name,
                service.description,
                service.price,
                service.localisation,
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
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: defaultColor.withOpacity(0.5),
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
          print(imagePath);
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



  Widget buildImage(
      Map hotel, Size size, Color defaultColor, Color secondColor) {
    double paddingTop = MediaQuery.of(context).padding.top;

    return Stack(
      children: [
        InkWell(
          onTap: () => setState(() {
            extendDetails = !extendDetails;
          }),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              hotel['img'],
              fit: BoxFit.fill,
              height: size.height * 0.35,
              width: size.width,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return Container(
                  height: size.height * 0.35,
                  width: size.width,
                  decoration: BoxDecoration(
                    color: defaultColor.withOpacity(0.1),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: SizedBox(
                    width: size.width * 0.7,
                    height: size.height * 0.3,
                    child: Align(
                      child: CircularProgressIndicator(
                        color: defaultColor,
                      ),
                    ),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: size.height * 0.35,
                  width: size.width,
                  decoration: BoxDecoration(
                    color: defaultColor.withOpacity(0.1),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: SizedBox(
                    width: size.width * 0.7,
                    height: size.height * 0.3,
                    child: Align(
                      child: CircularProgressIndicator(
                        color: defaultColor,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(
              top: paddingTop,
              left: size.width * 0.05,
            ),
            child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: defaultColor,
                ),
                child: Icon(
                  UniconsLine.arrow_left,
                  color: secondColor,
                  size: size.height * 0.035,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
