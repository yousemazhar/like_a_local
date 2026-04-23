import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../theme/tokens.dart';

class SkeletonBox extends StatelessWidget {
  const SkeletonBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  final double width;
  final double height;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: LALColors.c100,
      highlightColor: LALColors.c50,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: LALColors.c100,
          borderRadius: borderRadius ?? LALRadii.mdBorder,
        ),
      ),
    );
  }
}

class SkeletonCard extends StatelessWidget {
  const SkeletonCard({
    super.key,
    this.width = 268,
    this.height = 360,
  });

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: LALColors.c100,
      highlightColor: LALColors.c50,
      child: Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(
          color: LALColors.c100,
          borderRadius: LALRadii.xlBorder,
        ),
      ),
    );
  }
}

class SkeletonList extends StatelessWidget {
  const SkeletonList({
    super.key,
    this.itemCount = 5,
    this.scrollDirection = Axis.vertical,
    this.padding,
    this.itemBuilder,
  });

  final int itemCount;
  final Axis scrollDirection;
  final EdgeInsets? padding;
  final NullableIndexedWidgetBuilder? itemBuilder;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: scrollDirection,
      padding: padding,
      shrinkWrap: scrollDirection == Axis.vertical,
      physics: scrollDirection == Axis.vertical
          ? const NeverScrollableScrollPhysics()
          : null,
      itemCount: itemCount,
      separatorBuilder: (_, __) => SizedBox(
        width: scrollDirection == Axis.horizontal ? 12 : 0,
        height: scrollDirection == Axis.vertical ? 12 : 0,
      ),
      itemBuilder: itemBuilder ?? (_, i) => const _SkeletonListItem(),
    );
  }
}

class _SkeletonListItem extends StatelessWidget {
  const _SkeletonListItem();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: LALColors.c100,
      highlightColor: LALColors.c50,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: LALSpacing.xl),
        child: Row(
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: LALColors.c100,
                borderRadius: LALRadii.mdBorder,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 16,
                    width: 140,
                    decoration: const BoxDecoration(
                      color: LALColors.c100,
                      borderRadius: LALRadii.smBorder,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 12,
                    width: 100,
                    decoration: const BoxDecoration(
                      color: LALColors.c100,
                      borderRadius: LALRadii.smBorder,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
