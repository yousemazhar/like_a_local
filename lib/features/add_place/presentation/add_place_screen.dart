import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/lal_chip.dart';
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

  static const _steps = ['Photos', 'Basics', 'Tips & Dishes', 'Preview'];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _next() {
    if (_step < _steps.length - 1) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LALColors.bg,
      appBar: AppBar(
        title: Text(_steps[_step]),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: _back,
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Cancel'),
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
                for (var i = 0; i < _steps.length; i++) ...[
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
                  if (i < _steps.length - 1) const SizedBox(width: 6),
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
              onPressed: _step < _steps.length - 1
                  ? _next
                  : () => context.pop(),
              child: Text(_step < _steps.length - 1
                  ? 'Next: ${_steps[_step + 1]}'
                  : 'Publish Place'),
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Add photos', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 6),
          const Text('At least 1 photo required.',
              style: LALTypography.bodySmall),
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Place details',
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 20),
          const TextField(
              decoration: InputDecoration(labelText: 'Place name')),
          const SizedBox(height: 16),
          const TextField(
              decoration: InputDecoration(labelText: 'Neighborhood')),
          const SizedBox(height: 16),
          const TextField(
            decoration: InputDecoration(labelText: 'Description'),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          const Text('Category', style: LALTypography.labelMedium),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final c in [
                'Restaurant', 'Café', 'Bar', 'Market', 'Viewpoint', 'Museum',
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Tips & Dishes',
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 6),
          const Text('Add up to 5 local tips.',
              style: LALTypography.bodySmall),
          const SizedBox(height: 20),
          const TextField(
            decoration: InputDecoration(
              labelText: 'Tip 1',
              hintText: 'What should visitors know?',
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add, size: 16),
            label: const Text('Add another tip'),
          ),
          const Divider(height: 32),
          const Text('Must-Try Dishes', style: LALTypography.labelLarge),
          const SizedBox(height: 12),
          const TextField(
              decoration: InputDecoration(labelText: 'Dish name')),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add, size: 16),
            label: const Text('Add a dish'),
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
            Text('Ready to publish?',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            const Text(
              'Your place will be visible to everyone once published.',
              style: LALTypography.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
