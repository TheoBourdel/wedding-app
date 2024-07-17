import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:client/features/service/widgets/services_theme.dart';
import 'package:client/model/service.dart';
import 'package:client/repository/image_repository.dart';
import 'package:client/model/image.dart' as service_image;
import 'package:client/core/constant/constant.dart';
import 'package:client/features/service/pages/single_service_page.dart';
import 'package:client/features/service/widgets/card/service_card.dart';
import 'package:client/features/service/widgets/card/service_card_content.dart';

class MyServiceListView extends StatefulWidget {
  final VoidCallback? callback;
  final Service? serviceData;
  final AnimationController? animationController;
  final Animation<double>? animation;

  const MyServiceListView({
    super.key,
    this.serviceData,
    this.animationController,
    this.animation,
    this.callback,
  });

  @override
  // ignore: library_private_types_in_public_api
  _MyServiceListViewState createState() => _MyServiceListViewState();
}

class _MyServiceListViewState extends State<MyServiceListView> {
  List<service_image.Image> images = [];
  bool _isImagesLoaded = false;

  @override
  void didUpdateWidget(covariant MyServiceListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.serviceData != oldWidget.serviceData) {
      _isImagesLoaded = false;
      _loadImages();
    }
  }

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  void _loadImages() async {
    if (!_isImagesLoaded) {
      var serviceId = widget.serviceData?.id;
      if (serviceId != null) {
        List<service_image.Image> loadedImages = await ImageRepository().getServiceImages(serviceId);
        setState(() {
          images = loadedImages;
          _isImagesLoaded = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.animation!,
          child: Transform(
            transform: Matrix4.translationValues(0.0, 50 * (1.0 - widget.animation!.value), 0.0),
            child: Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 16),
              child: InkWell(
                onTap: () {
                  if (widget.serviceData?.id != null) {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => DetailsPage(
                        size: MediaQuery.of(context).size,
                        serviceData: widget.serviceData!,
                      ),
                    ));
                  }
                },
                child: ServiceCard(
                loadImages: _loadImages,
                  serviceCardContent: ServiceCardContent(
                    images: images,
                    serviceData: widget.serviceData,
                    apiUrl: apiUrl,
                  ),
              ),
              ),
            ),
          ),
        );
      },
    );
  }
}
