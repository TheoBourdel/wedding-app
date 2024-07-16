import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:client/features/service/widgets/services_theme.dart';
import 'package:client/model/service.dart';
import 'package:client/repository/image_repository.dart';
import 'package:client/model/image.dart' as service_image;
import 'package:client/core/constant/constant.dart';
import 'package:client/features/service/pages/single_service_page.dart';
import 'package:iconsax/iconsax.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../model/favorite.dart';
import '../../../../repository/favorite_repository.dart';

class FavoriteServiceListView extends StatefulWidget {
  final VoidCallback? callback;
  final List<Service> services;
  final AnimationController? animationController;
  final Animation<double>? animation;
  final Function(int)? onFavoriteToggled;

  const FavoriteServiceListView({
    super.key,
    required this.services,
    this.animationController,
    this.animation,
    this.callback,
    this.onFavoriteToggled,
  });

  @override
  _FavoriteServiceListViewState createState() => _FavoriteServiceListViewState();
}

class _FavoriteServiceListViewState extends State<FavoriteServiceListView> with SingleTickerProviderStateMixin {
  List<Service> displayedServices = [];
  late AnimationController _opacityController;

  @override
  void initState() {
    super.initState();
    displayedServices = widget.services;
    _opacityController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _opacityController.dispose();
    super.dispose();
  }

  void _toggleFavorite(int serviceId) {
    setState(() {
      displayedServices.removeWhere((service) => service.id == serviceId);
    });

    if (widget.onFavoriteToggled != null) {
      widget.onFavoriteToggled!(serviceId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: displayedServices.length,
      itemBuilder: (context, index) {
        return ServiceItem(
          serviceData: displayedServices[index],
          onFavoriteToggled: _toggleFavorite,
          animationController: _opacityController,
        );
      },
    );
  }
}

class ServiceItem extends StatefulWidget {
  final Service serviceData;
  final Function(int) onFavoriteToggled;
  final AnimationController animationController;

  const ServiceItem({
    super.key,
    required this.serviceData,
    required this.onFavoriteToggled,
    required this.animationController,
  });

  @override
  _ServiceItemState createState() => _ServiceItemState();
}

class _ServiceItemState extends State<ServiceItem> with SingleTickerProviderStateMixin {
  List<service_image.Image> images = [];
  bool _isFavorite = false;
  late Animation<double> _opacityAnimation;
  bool _isImagesLoaded = false;

  @override
  void initState() {
    super.initState();
    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(widget.animationController);
    _loadImages();
    _checkIfFavorite();
  }

  void _checkIfFavorite() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String token = prefs.getString('token')!;
      final int userId = JwtDecoder.decode(token)['sub'];
      List<Favorite> favorites = await FavoriteRepository.getFavoritesByUserId(userId);
      for (var favorite in favorites) {
        if (favorite.ServiceID == widget.serviceData.id) {
          setState(() {
            _isFavorite = true;
          });
          break;
        }
      }
    } catch (e) {
      print('Failed to load favorites: $e');
    }
  }

  void _loadImages() async {
    if (!_isImagesLoaded) {
      var serviceId = widget.serviceData.id;
      if (serviceId != null) {
        List<service_image.Image> loadedImages = await ImageRepository().getServiceImages(serviceId);
        setState(() {
          images = loadedImages;
          _isImagesLoaded = true;
        });
      }
    }
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
      if (!_isFavorite) {
        widget.animationController.reverse().then((_) {
          if (widget.serviceData.id != null) {
            widget.onFavoriteToggled(widget.serviceData.id!);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: _opacityAnimation,
      axis: Axis.vertical,
      child: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 16),
        child: InkWell(
          onTap: () {
            if (widget.serviceData.id != null) {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => DetailsPage(
                  size: MediaQuery.of(context).size,
                  serviceData: widget.serviceData,
                ),
              ));
            }
          },
          child: serviceCard(context),
        ),
      ),
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
            //favoriteButton(),
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
            Text(widget.serviceData.name ?? 'Service Name', textAlign: TextAlign.left, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 22)),
            Text(widget.serviceData.localisation ?? 'No localisation', style: TextStyle(fontSize: 14, color: Colors.grey.withOpacity(0.8))),
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
          Text('${widget.serviceData.price.toString()} €', textAlign: TextAlign.left, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 22)),
          Text('prix d\'estimation', style: TextStyle(fontSize: 14, color: Colors.grey.withOpacity(0.8))),
        ],
      ),
    );
  }

  Widget favoriteButton() {
    return Positioned(
      top: 8,
      right: 8,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _toggleFavorite,
          borderRadius: const BorderRadius.all(Radius.circular(32.0)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return RotationTransition(
                  turns: child.key == ValueKey<bool>(_isFavorite) ? Tween<double>(begin: 0.75, end: 1.0).animate(animation) : Tween<double>(begin: 1.0, end: 0.75).animate(animation),
                  child: ScaleTransition(scale: animation, child: child),
                );
              },
              child: _isFavorite
                  ? Icon(Iconsax.archive_tick1, color: AppColors.pink500, size: 35.0, key: ValueKey<bool>(_isFavorite))
                  : Icon(Iconsax.archive_add, size: 35.0, color: ServiceTheme.buildLightTheme().primaryColor, key: ValueKey<bool>(_isFavorite)),
            ),
          ),
        ),
      ),
    );
  }
}