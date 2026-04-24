import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/lal_chip.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/tokens.dart';
import '../../../theme/typography.dart';

class AddPlaceScreen extends StatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  State<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  int _step = 0;
  final _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _next() {
    final steps = _buildSteps(AppLocalizations.of(context)!);
    if (_step < steps.length - 1) {
      setState(() => _step++);
      _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut);
    }
  }

  void _back() {
    if (_step > 0) {
      setState(() => _step--);
      _pageController.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut);
    } else {
      context.pop();
    }
  }

  List<String> _buildSteps(AppLocalizations t) => [
        t.addPlacePhotos,
        t.addPlaceBasics,
        t.addPlaceTips,
        t.addPlacePreview,
      ];

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final steps = _buildSteps(t);

    return Scaffold(
      backgroundColor: LALColors.bg,
      appBar: AppBar(
        title: Text(steps[_step]),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: _back,
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(t.buttonCancel),
          ),
        ],
      ),
      body: Column(
        children: [
          // Step indicator
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: Row(
              children: [
                for (var i = 0; i < steps.length; i++) ...[
                  Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 3,
                      decoration: BoxDecoration(
                        color: i <= _step ? LALColors.c900 : LALColors.c100,
                        borderRadius: LALRadii.pillBorder,
                      ),
                    ),
                  ),
                  if (i < steps.length - 1) const SizedBox(width: 6),
                ],
              ],
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                _PhotosStep(),
                _BasicsStep(),
                _TipsStep(),
                _PreviewStep(),
              ],
            ),
          ),
          // Bottom CTA
          Container(
            padding: EdgeInsets.fromLTRB(
                20, 12, 20, 12 + MediaQuery.of(context).padding.bottom),
            decoration: const BoxDecoration(
              color: LALColors.surface,
              border: Border(top: BorderSide(color: LALColors.c100)),
            ),
            child: ElevatedButton(
              onPressed: _step < steps.length - 1
                  ? _next
                  : () => context.pop(),
              child: Text(_step < steps.length - 1
                  ? t.addPlaceNext(steps[_step + 1])
                  : t.addPlacePublish),
            ),
          ),
        ],
      ),
    );
  }
}

class _PhotosStep extends StatelessWidget {
  const _PhotosStep();

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.addPlacePhotosTitle,
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 6),
          Text(t.addPlacePhotosHint, style: LALTypography.bodySmall),
          const SizedBox(height: 20),
          Row(
            children: [
              _AddPhotoTile(),
              const SizedBox(width: 10),
              _AddPhotoTile(placeholder: true),
              const SizedBox(width: 10),
              _AddPhotoTile(placeholder: true),
            ],
          ),
        ],
      ),
    );
  }
}

class _AddPhotoTile extends StatelessWidget {
  const _AddPhotoTile({this.placeholder = false});
  final bool placeholder;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            color: placeholder ? LALColors.c50 : LALColors.surfaceAlt,
            borderRadius: LALRadii.lgBorder,
            border: Border.all(
                color: placeholder ? LALColors.c100 : LALColors.c200,
                width: placeholder ? 1 : 1.5),
          ),
          child: placeholder
              ? const Center(
                  child: Icon(Icons.add_photo_alternate_outlined,
                      color: LALColors.c200, size: 24))
              : const Center(
                  child: Icon(Icons.add_a_photo_outlined,
                      color: LALColors.c500, size: 24)),
        ),
      ),
    );
  }
}

class _BasicsStep extends StatelessWidget {
  const _BasicsStep();

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.addPlaceDetailsTitle,
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 20),
          TextField(
              decoration: InputDecoration(labelText: t.addPlaceName)),
          const SizedBox(height: 16),
          TextField(
              decoration: InputDecoration(labelText: t.addPlaceNeighborhood)),
          const SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(labelText: t.addPlaceDescription),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          Text(t.addPlaceCategory, style: LALTypography.labelMedium),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final c in [
                t.categoryRestaurant,
                t.categoryCafe,
                t.categoryBar,
                t.categoryMarket,
                t.categoryViewpoint,
                t.categoryMuseum,
              ])
                LALChip(label: c),
            ],
          ),
        ],
      ),
    );
  }
}

class _TipsStep extends StatelessWidget {
  const _TipsStep();

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.addPlaceTips,
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 6),
          Text(t.addPlaceTipsSubtitle, style: LALTypography.bodySmall),
          const SizedBox(height: 20),
          TextField(
            decoration: InputDecoration(
              labelText: t.addPlaceTipLabel,
              hintText: t.addPlaceTipHint,
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add, size: 16),
            label: Text(t.addPlaceAddTip),
          ),
          const Divider(height: 32),
          Text(t.placeDishes, style: LALTypography.labelLarge),
          const SizedBox(height: 12),
          TextField(decoration: InputDecoration(labelText: t.addPlaceDishName)),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add, size: 16),
            label: Text(t.addPlaceAddDish),
          ),
        ],
      ),
    );
  }
}

class _PreviewStep extends StatelessWidget {
  const _PreviewStep();

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: LALColors.accentSoft,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_outline_rounded,
                  color: LALColors.accent, size: 36),
            ),
            const SizedBox(height: 20),
            Text(t.addPlaceReadyTitle,
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              t.addPlaceReadyBody,
              style: LALTypography.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
