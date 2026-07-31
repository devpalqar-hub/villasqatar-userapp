import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:villas_qatar/Core/constants/app_colors.dart';

/// A hero valuation card for Villas Qatar: image banner, headline, stats,
/// and a call-to-action to start an AI estimate.
class VillaValuationCard extends StatelessWidget {
  VillaValuationCard({
    super.key,
    required this.onGetEstimate,
    this.imageUrl =
        'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80',
    this.brandLabel = 'VILLAS QATAR',
    this.titleLine1 = "What's your",
    this.titleLine2 = 'villa worth?',
    this.subtitle = 'Find out in 30 seconds with our AI-powered valuation.',

    this.ctaLabel = 'Get my free estimate',
  });

  final VoidCallback onGetEstimate;
  final String imageUrl;
  final String brandLabel;
  final String titleLine1;
  final String titleLine2;
  final String subtitle;
  final String ctaLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 390.w,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(24),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: _Headline(line1: titleLine1, line2: titleLine2),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: _Subtitle(text: subtitle),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            child: _ValuationPanel(
              ctaLabel: ctaLabel,
              onGetEstimate: onGetEstimate,
            ),
          ),
        ],
      ),
    );
  }
}

class ValuationStat {
  const ValuationStat({
    required this.icon,
    required this.value,
    required this.label,
  });
  final IconData icon;
  final String value;
  final String label;
}

class _HeroImage extends StatelessWidget {
  const _HeroImage({required this.imageUrl});
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) => progress == null
          ? child
          : Container(
              color: AppColors.divider,
              alignment: Alignment.center,
              child: const CircularProgressIndicator(strokeWidth: 2),
            ),
      errorBuilder: (context, error, stackTrace) => Container(
        color: AppColors.divider,
        alignment: Alignment.center,
        child: const Icon(
          Icons.image_not_supported_outlined,
          color: AppColors.textHint,
        ),
      ),
    );
  }
}

class _Headline extends StatelessWidget {
  const _Headline({required this.line1, required this.line2});
  final String line1;
  final String line2;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontFamily: 'Rubik',
          fontSize: 32,
          fontWeight: FontWeight.w700,
          height: 1.1,
          color: AppColors.textPrimary,
        ),
        children: [
          TextSpan(text: '$line1\n'),
          TextSpan(
            text: line2,
            style: const TextStyle(color: AppColors.secondary),
          ),
        ],
      ),
    );
  }
}

class _Subtitle extends StatelessWidget {
  const _Subtitle({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(width: 3, height: 39, color: AppColors.secondary),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'Rubik',
              fontSize: 15,
              height: 1.5,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

class _ValuationPanel extends StatelessWidget {
  const _ValuationPanel({required this.ctaLabel, required this.onGetEstimate});

  final String ctaLabel;
  final VoidCallback onGetEstimate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.08),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _GradientCta(label: ctaLabel, onPressed: onGetEstimate),
          const SizedBox(height: 16),
          const _TrustBadgeRow(),
        ],
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  const _StatColumn({required this.stat});
  final ValuationStat stat;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            color: AppColors.featured,
            shape: BoxShape.circle,
          ),
          child: Icon(stat.icon, color: AppColors.secondary, size: 20),
        ),
        const SizedBox(height: 10),
        Text(
          stat.value,
          style: const TextStyle(
            fontFamily: 'Rubik',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          stat.label,
          style: const TextStyle(
            fontFamily: 'Rubik',
            fontSize: 11,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _GradientCta extends StatelessWidget {
  const _GradientCta({required this.label, required this.onPressed});
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: DecoratedBox(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        child: Material(
          color: AppColors.secondary,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onPressed,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.auto_awesome, color: Colors.amber, size: 20),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontFamily: 'Rubik',
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(
                  Icons.arrow_forward,
                  color: AppColors.white,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TrustBadgeRow extends StatelessWidget {
  const _TrustBadgeRow();

  static const _badges = [
    (icon: Icons.verified_user_outlined, label: '100% secure'),
    (icon: Icons.check_circle, label: 'AI-powered valuation'),
    (icon: Icons.bar_chart, label: 'Real market insights'),
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 12,
      runSpacing: 8,
      children: [
        for (final badge in _badges)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(badge.icon, size: 16, color: AppColors.secondary),
              const SizedBox(width: 8),
              Text(
                badge.label,
                style: const TextStyle(
                  fontFamily: 'Rubik',
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
