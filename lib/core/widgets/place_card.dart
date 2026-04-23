import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../theme/tokens.dart';
import '../../theme/typography.dart';
import 'lal_chip.dart';

enum PlaceCardVariant { featured, trending, searchResult }

class PlaceCard extends StatelessWidget {
  const PlaceCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.neighborhood,
    this.category,
    this.rating,
    this.isSaved = false,
    this.onTap,
    this.onSave,
    this.variant = PlaceCardVariant.featured,
  });

  final String imageUrl;
  final String title;
  final String neighborhood;
  final String? category;
  final double? rating;
  final bool isSaved;
  final VoidCallback? onTap;
  final VoidCallback? onSave;
  final PlaceCardVariant variant;

  @override
  Widget build(BuildContext context) => switch (variant) {
        PlaceCardVariant.featured => _FeaturedCard(card: this),
        PlaceCardVariant.trending => _TrendingCard(card: this),
        PlaceCardVariant.searchResult => _SearchResultCard(card: this),
      };
}

// ── Featured (268 × 360) ──────────────────────────────────────────────────────

class _FeaturedCard extends StatelessWidget {
  const _FeaturedCard({required this.card});
  final PlaceCard card;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: card.onTap,
      child: ClipRRect(
        borderRadius: LALRadii.xlBorder,
        child: SizedBox(
          width: 268,
          height: 360,
          child: Stack(
            fit: StackFit.expand,
            children: [
              _PlaceImage(imageUrl: card.imageUrl),
              const _GradientOverlay(),
              if (card.category != null)
                Positioned(
                  top: 14,
                  left: 14,
                  child: FloatChip(label: card.category!),
                ),
              Positioned(
                top: 8,
                right: 8,
                child: _HeartButton(isSaved: card.isSaved, onTap: card.onSave),
              ),
              Positioned(
                bottom: 20,
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      card.title,
                      style: LALTypography.headlineMedium.copyWith(
                        color: Colors.white,
                        fontSize: 26,
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      card.neighborhood,
                      style: LALTypography.bodySmall
                          .copyWith(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Trending (168 × 168) ──────────────────────────────────────────────────────

class _TrendingCard extends StatelessWidget {
  const _TrendingCard({required this.card});
  final PlaceCard card;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: card.onTap,
      child: ClipRRect(
        borderRadius: LALRadii.lgBorder,
        child: SizedBox(
          width: 168,
          height: 168,
          child: Stack(
            fit: StackFit.expand,
            children: [
              _PlaceImage(imageUrl: card.imageUrl),
              const _GradientOverlay(),
              Positioned(
                bottom: 12,
                left: 12,
                right: 12,
                child: Text(
                  card.title,
                  style: LALTypography.labelLarge
                      .copyWith(color: Colors.white),
                  maxLines: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Search result (list row) ──────────────────────────────────────────────────

class _SearchResultCard extends StatelessWidget {
  const _SearchResultCard({required this.card});
  final PlaceCard card;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: card.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: LALSpacing.md, horizontal: LALSpacing.xl),
        decoration: const BoxDecoration(
          color: LALColors.surface,
          border: Border(bottom: BorderSide(color: LALColors.c50)),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: LALRadii.mdBorder,
              child: _PlaceImage(
                imageUrl: card.imageUrl,
                width: 72,
                height: 72,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(card.title, style: LALTypography.labelLarge),
                  const SizedBox(height: 2),
                  Text(card.neighborhood, style: LALTypography.bodySmall),
                  if (card.rating != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded,
                            size: 12, color: LALColors.accent),
                        const SizedBox(width: 2),
                        Text(
                          card.rating!.toStringAsFixed(1),
                          style: LALTypography.labelSmall,
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            IconButton(
              onPressed: card.onSave,
              icon: Icon(
                card.isSaved ? Icons.bookmark : Icons.bookmark_border,
                color: card.isSaved ? LALColors.accent : LALColors.c400,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Shared primitives ─────────────────────────────────────────────────────────

class _PlaceImage extends StatelessWidget {
  const _PlaceImage({
    required this.imageUrl,
    this.width,
    this.height,
  });

  final String imageUrl;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: BoxFit.cover,
      placeholder: (_, __) => const ColoredBox(color: LALColors.c100),
      errorWidget: (_, __, ___) => const ColoredBox(
        color: LALColors.surfaceAlt,
        child: Center(
          child: Icon(Icons.image_not_supported_outlined,
              color: LALColors.c300),
        ),
      ),
    );
  }
}

class _GradientOverlay extends StatelessWidget {
  const _GradientOverlay();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withValues(alpha: 0.65),
          ],
          stops: const [0.45, 1.0],
        ),
      ),
    );
  }
}

class _HeartButton extends StatelessWidget {
  const _HeartButton({required this.isSaved, this.onTap});

  final bool isSaved;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(
          isSaved ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          color: isSaved ? LALColors.accent : LALColors.c400,
          size: 18,
        ),
      ),
    );
  }
}
