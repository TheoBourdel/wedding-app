import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:client/features/service/widgets/services_theme.dart';
import 'package:client/model/service.dart';
import 'package:client/repository/image_repository.dart';
import 'package:client/model/image.dart' as service_image;
import 'package:client/core/constant/constant.dart';
import 'package:client/features/service/pages/single_service_page.dart';

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
                child: serviceCard(context),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget serviceCard(BuildContext context) {
    _loadImages();
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.6), offset: const Offset(4, 4), blurRadius: 16),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        child: Stack(
          children: [
            serviceCardContent(),
          ],
        ),
      ),
    );
  }

  Widget serviceCardContent() {
    String defaultImage = '$apiUrl/uploads/presta.jpg';

    String imagePath = (images.isNotEmpty && (images[0].path?.isNotEmpty ?? false))
        ? apiUrl + (images[0].path!.startsWith('/') ? images[0].path! : '/${images[0].path!}')
        : defaultImage;

    return Column(
      children: [
        AspectRatio(
          aspectRatio: 2,
          child: Image.network(imagePath, fit: BoxFit.cover),
        ),
        Container(
          color: ServiceTheme.buildLightTheme().colorScheme.background,
          child: serviceDetails(),
        ),
      ],
    );
  }

  Widget serviceDetails() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        serviceInfo(),
        priceInfo(),
      ],
    );
  }

  Widget serviceInfo() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.serviceData?.name ?? 'Service Name', textAlign: TextAlign.left, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 22)),
            Text(widget.serviceData?.localisation ?? 'No localisation', style: TextStyle(fontSize: 14, color: Colors.grey.withOpacity(0.8))),
            ratingBar(),
          ],
        ),
      ),
    );
  }

  Widget ratingBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          RatingBar(
            initialRating: 4.0,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemSize: 24,
            ratingWidget: RatingWidget(
              full: Icon(Icons.star_rate_rounded, color: ServiceTheme.buildLightTheme().primaryColor),
              half: Icon(Icons.star_half_rounded, color: ServiceTheme.buildLightTheme().primaryColor),
              empty: Icon(Icons.star_border_rounded, color: ServiceTheme.buildLightTheme().primaryColor),
            ),
            itemPadding: EdgeInsets.zero,
            onRatingUpdate: (rating) {},
          ),
          Text('5 Reviews', style: TextStyle(fontSize: 14, color: Colors.grey.withOpacity(0.8))),
        ],
      ),
    );
  }

  Widget priceInfo() {
    return Padding(
      padding: const EdgeInsets.only(right: 16, top: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text('${widget.serviceData?.price.toString() ?? '0'} €', textAlign: TextAlign.left, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 22)),
          Text('prix d\'estimation', style: TextStyle(fontSize: 14, color: Colors.grey.withOpacity(0.8))),
        ],
      ),
    );
  }
}