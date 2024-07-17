import 'package:flutter/material.dart';
import 'package:client/model/service.dart';
import 'package:client/repository/image_repository.dart';
import 'package:client/model/image.dart' as service_image;
import 'package:client/core/constant/constant.dart';
import 'package:client/features/service/pages/single_service_page.dart';
import 'package:client/repository/favorite_repository.dart';
import 'package:client/model/favorite.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:client/features/service/widgets/card/service_card.dart';
import 'package:client/features/service/widgets/card/service_card_content.dart';

class ServiceListView extends StatefulWidget {
  final VoidCallback? callback;
  final Service? serviceData;
  final AnimationController? animationController;
  final Animation<double>? animation;
  final Function(int)? onFavoriteToggled;

  const ServiceListView({
    super.key,
    this.serviceData,
    this.animationController,
    this.animation,
    this.callback,
    this.onFavoriteToggled,
  });

  @override
  _ServiceListViewState createState() => _ServiceListViewState();
}

class _ServiceListViewState extends State<ServiceListView> with SingleTickerProviderStateMixin {
  List<service_image.Image> images = [];
  bool _isImagesLoaded = false;
  bool _isFavorite = false;
  int? _favoriteId;
  late AnimationController _opacityController;
  late Animation<double> _opacityAnimation;

  @override
  void didUpdateWidget(covariant ServiceListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.serviceData != oldWidget.serviceData) {
      _isImagesLoaded = false;
      _loadImages();
      _checkIfFavorite();
    }
  }

  @override
  void initState() {
    super.initState();
    _loadImages();
    _checkIfFavorite();
    _opacityController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(_opacityController);
  }

  @override
  void dispose() {
    _opacityController.dispose();
    super.dispose();
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

  void _checkIfFavorite() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String token = prefs.getString('token')!;
      final int userId = JwtDecoder.decode(token)['sub'];
      List<Favorite> favorites = await FavoriteRepository.getFavoritesByUserId(userId);
      for (var favorite in favorites) {
        if (favorite.ServiceID == widget.serviceData?.id) {
          setState(() {
            _isFavorite = true;
            _favoriteId = favorite.id;
          });
          break;
        }
      }
    } catch (e) {
      print('Failed to load favorites: $e');
    }
  }

  void _toggleFavorite() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String token = prefs.getString('token')!;
      final int userId = JwtDecoder.decode(token)['sub'];
      int? serviceId = widget.serviceData!.id;

      if (_isFavorite) {
        await FavoriteRepository().deleteFavorite(_favoriteId!);
        setState(() {
          _isFavorite = false;
          _favoriteId = null;
        });
        if (widget.onFavoriteToggled != null) {
          _opacityController.forward().then((_) => widget.onFavoriteToggled!(serviceId!));
        }
      } else {
        Favorite favorite = Favorite(UserID: userId, ServiceID: serviceId);
        Favorite newFavorite = await FavoriteRepository().createFavorite(favorite);
        setState(() {
          _isFavorite = true;
          _favoriteId = newFavorite.id;
        });
      }
    } catch (e) {
      print('Failed to toggle favorite: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _opacityAnimation.value,
      duration: const Duration(milliseconds: 300),
      child: AnimatedBuilder(
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
                    isFavorite: _isFavorite,
                    onToggleFavorite: _toggleFavorite,
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
      ),
    );
  }
}
