import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:client/features/service/widgets/services_theme.dart';
import 'package:client/model/service.dart';
import 'package:client/model/image.dart' as service_image;

class ServiceCardContent extends StatelessWidget {
  final List<service_image.Image> images;
  final Service? serviceData;
  final String apiUrl;

  const ServiceCardContent({
    Key? key,
    required this.images,
    required this.serviceData,
    required this.apiUrl,
  }) : super(key: key);

  String _getImagePath() {
    String defaultImage = '$apiUrl/uploads/presta.jpg';
    return (images.isNotEmpty && (images[0].path?.isNotEmpty ?? false))
        ? apiUrl + (images[0].path!.startsWith('/') ? images[0].path! : '/${images[0].path!}')
        : defaultImage;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AspectRatio(
          aspectRatio: 2,
          child: Image.network(_getImagePath(), fit: BoxFit.cover),
        ),
        Container(
          color: ServiceTheme.buildLightTheme().colorScheme.background,
          child: _buildServiceDetails(),
        ),
      ],
    );
  }

  Widget _buildServiceDetails() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildServiceInfo(),
        _buildPriceInfo(),
      ],
    );
  }

  Widget _buildServiceInfo() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(serviceData?.name ?? 'Service Name', textAlign: TextAlign.left, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 22)),
            Text(serviceData?.localisation ?? 'No localisation', style: TextStyle(fontSize: 14, color: Colors.grey.withOpacity(0.8))),
            _buildRatingBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingBar() {
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
          Text('5 notations', style: TextStyle(fontSize: 14, color: Colors.grey.withOpacity(0.8))),
        ],
      ),
    );
  }

  Widget _buildPriceInfo() {
    return Padding(
      padding: const EdgeInsets.only(right: 16, top: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text('${serviceData?.price.toString() ?? '0'} €', textAlign: TextAlign.left, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 22)),
          Text('prix d\'estimation', style: TextStyle(fontSize: 14, color: Colors.grey.withOpacity(0.8))),
        ],
      ),
    );
  }
}
