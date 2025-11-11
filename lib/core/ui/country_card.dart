import 'package:amicons/amicons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:wanderly/core/ui/custom_text.dart';

class CountryCard extends StatelessWidget {
  const CountryCard({
    super.key,
    required this.backgroundColor,
    required this.borderColor,
    required this.countryName,
    required this.flagUrl,
    required this.region,
    required this.briefInfo,
    required this.isFavorite,
    required this.onFavorite,
    this.includeFavoriteIcon = true,
    required this.source,
  });

  final Color backgroundColor;
  final Color borderColor;
  final String countryName;
  final String flagUrl;
  final String region;
  final String briefInfo;
  final bool isFavorite;
  final VoidCallback onFavorite;
  final bool includeFavoriteIcon;
  final String source;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Hero(
              tag: '${source}_country_flag_$flagUrl',
              child: AspectRatio(
                aspectRatio: 3 / 2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final ratio = MediaQuery.of(context).devicePixelRatio;
                      final width = (constraints.maxWidth * ratio).round();
                      return CachedNetworkImage(
                        imageUrl: flagUrl,
                        fit: BoxFit.cover,
                        memCacheWidth: width.toInt(),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  countryName,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                Row(
                  children: [
                    const Icon(
                      Amicons.remix_global,
                      size: 14,
                      color: Color(0xFF717171),
                    ),
                    Expanded(
                      child: CustomText(
                        ' $region',
                        fontSize: 14,
                        color: const Color(0xFF717171),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ],
                ),
                CustomText(
                  briefInfo,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  fontSize: 14,
                  color: const Color(0xFF717171),
                ),
              ],
            ),
          ),

          if (includeFavoriteIcon)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: onFavorite,
                    child: Animate(
                      key: ValueKey(isFavorite),
                      effects: [
                        ScaleEffect(
                          duration: 200.ms,
                          curve: Curves.easeInOut,
                          begin: const Offset(0.9, 0.9),
                        ),
                        FadeEffect(
                          duration: 200.ms,
                          curve: Curves.easeInOut,
                          begin: 0.8,
                        ),
                      ],
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFFEBEBEB)),
                        ),
                        child: Icon(
                          isFavorite
                              ? Amicons.remix_heart_fill
                              : Amicons.remix_heart,
                          color: isFavorite ? Colors.red : Colors.grey,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
