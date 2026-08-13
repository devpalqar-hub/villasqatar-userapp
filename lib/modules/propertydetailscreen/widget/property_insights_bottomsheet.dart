import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:villas_qatar/modules/propertylist/model/myproperty_model.dart';

/// Property Insights panel - app-native version of the web
/// "Property Insights" dashboard: lifetime totals, a this-period
/// summary with a views comparison, and a views-over-time chart.
///
/// Shown from the "Insights" action next to "Boost Property" on the
/// property details screen. Only "Views" (`property.insights`) is
/// guaranteed to be live data today - the other metric tiles read
/// through [PropertyInsightsMetrics]'s tolerant JSON parsing and
/// will populate automatically once the backend sends them.
class PropertyInsightsBottomSheet extends StatelessWidget {
  final String propertyId;
  final PropertyInsights insights;

  const PropertyInsightsBottomSheet({
    super.key,
    required this.propertyId,
    this.insights = const PropertyInsights.empty(),
  });

  static const Color primaryColor = Color(0xff8A1538);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: const Color(0xffF7F7F8),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // =====================================================
          // DRAG HANDLE
          // =====================================================
          SizedBox(height: 10.h),

          Container(
            width: 42.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: const Color(0xffD5D5D5),
              borderRadius: BorderRadius.circular(20.r),
            ),
          ),

          // =====================================================
          // HEADER
          // =====================================================
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 10.w, 14.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40.w,
                      height: 40.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(.08),
                        borderRadius: BorderRadius.circular(11.r),
                      ),
                      child: Icon(
                        Icons.bar_chart_rounded,
                        size: 20.sp,
                        color: primaryColor,
                      ),
                    ),

                    SizedBox(width: 11.w),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Property Insights".tr,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xff1F1F1F),
                            ),
                          ),

                          SizedBox(height: 2.h),

                          Text(
                            "Track how people are discovering and engaging with your property."
                                .tr,
                            style: TextStyle(
                              fontSize: 9.5.sp,
                              color: const Color(0xff888888),
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),

                    InkWell(
                      onTap: Get.back,
                      customBorder: const CircleBorder(),
                      child: Padding(
                        padding: EdgeInsets.all(4.w),
                        child: Icon(
                          Icons.close_rounded,
                          size: 20.sp,
                          color: const Color(0xff333333),
                        ),
                      ),
                    ),
                  ],
                ),

                if (insights.formattedTrendRange.isNotEmpty) ...[
                  SizedBox(height: 12.h),

                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 9.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xffF7F7F8),
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: const Color(0xffEBEBEF)),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 13.sp,
                          color: const Color(0xff555555),
                        ),

                        SizedBox(width: 8.w),

                        Expanded(
                          child: Text(
                            insights.formattedTrendRange,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11.5.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xff222222),
                            ),
                          ),
                        ),

                        Text(
                          '${"Last".tr} ${insights.viewsTrend.length} '
                          '${"days".tr}',
                          style: TextStyle(
                            fontSize: 9.5.sp,
                            color: const Color(0xff888888),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          // =====================================================
          // CONTENT
          // =====================================================
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ======================================
                  // TOTALS (ALL TIME)
                  // ======================================

                  _sectionCard(
                    title: "Totals".tr,
                    caption: "(${"All Time".tr})",
                    child: _metricsGrid(insights.allTime),
                  ),

                  SizedBox(height: 14.h),

                  // ======================================
                  // THIS PERIOD SUMMARY
                  // ======================================

                  _sectionCard(
                    title: "This Period Summary".tr,
                    caption: insights.formattedTrendRange.isNotEmpty
                        ? '(${insights.formattedTrendRange})'
                        : null,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _metricsGrid(
                          insights.period,
                          highlightViews: true,
                        ),

                        if (insights.previousPeriodViews != null) ...[
                          SizedBox(height: 12.h),

                          _comparisonBanner(),
                        ],
                      ],
                    ),
                  ),

                  SizedBox(height: 14.h),

                  // ======================================
                  // VIEWS OVER TIME
                  // ======================================

                  if (insights.viewsTrend.isNotEmpty)
                    _viewsOverTimeCard()
                  else
                    _emptyStateBanner(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SECTION CARD WRAPPER
  // ============================================================

  Widget _sectionCard({
    required String title,
    String? caption,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xffEAEAEA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xff1F1F1F),
                ),
              ),

              if (caption != null) ...[
                SizedBox(width: 6.w),

                Expanded(
                  child: Text(
                    caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 9.5.sp,
                      color: const Color(0xff999999),
                    ),
                  ),
                ),
              ],
            ],
          ),

          SizedBox(height: 12.h),

          child,
        ],
      ),
    );
  }

  // ============================================================
  // METRICS GRID (VIEWS / REACH / IMPRESSIONS / WHATSAPP CLICKS /
  // MESSAGES STARTED / USERS ENGAGED / VISIT REQUESTS)
  // ============================================================

  Widget _metricsGrid(
    PropertyInsightsMetrics metrics, {
    bool highlightViews = false,
  }) {
    final tiles = <Widget>[
      _metricTile(
        icon: Icons.visibility_outlined,
        iconColor: const Color(0xffC22B4E),
        bgColor: const Color(0xffFBE3E9),
        label: "Views".tr,
        value: metrics.views,
        highlighted: highlightViews,
      ),
      _metricTile(
        icon: Icons.groups_outlined,
        iconColor: const Color(0xffC77A2E),
        bgColor: const Color(0xffFCEBD9),
        label: "Reach".tr,
        value: metrics.reach,
      ),
      _metricTile(
        icon: Icons.campaign_outlined,
        iconColor: const Color(0xff1F9D66),
        bgColor: const Color(0xffDEF5E9),
        label: "Impressions".tr,
        value: metrics.impressions,
      ),
      _metricTile(
        iconWidget: FaIcon(
          FontAwesomeIcons.whatsapp,
          size: 14.sp,
          color: const Color(0xff2FA84F),
        ),
        bgColor: const Color(0xffE1F6E4),
        label: "WhatsApp Clicks".tr,
        value: metrics.whatsappClicks,
      ),
      _metricTile(
        icon: Icons.chat_bubble_outline_rounded,
        iconColor: const Color(0xff3573D6),
        bgColor: const Color(0xffE1EBFB),
        label: "Messages Started".tr,
        value: metrics.messagesStarted,
      ),
      _metricTile(
        icon: Icons.people_outline_rounded,
        iconColor: const Color(0xff7D4FC2),
        bgColor: const Color(0xffEBE1FA),
        label: "Users Engaged".tr,
        value: metrics.usersEngaged,
      ),
      _metricTile(
        icon: Icons.event_available_outlined,
        iconColor: const Color(0xffB4901A),
        bgColor: const Color(0xffFAF0D6),
        label: "Visit Requests".tr,
        value: metrics.visitRequests,
      ),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10.h,
      crossAxisSpacing: 10.w,
      childAspectRatio: 2.05,
      children: tiles,
    );
  }

  Widget _metricTile({
    IconData? icon,
    Color? iconColor,
    Widget? iconWidget,
    required Color bgColor,
    required String label,
    required int value,
    bool highlighted = false,
  }) {
    assert(
      iconWidget != null || (icon != null && iconColor != null),
      'Provide either iconWidget, or both icon and iconColor.'.tr,
    );

    final Widget glyph =
        iconWidget ?? Icon(icon, size: 14.sp, color: iconColor);

    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: highlighted ? primaryColor.withOpacity(.06) : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: highlighted
              ? primaryColor.withOpacity(.25)
              : const Color(0xffEDEDED),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 30.w,
            height: 30.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: glyph,
          ),

          SizedBox(width: 8.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 8.5.sp,
                    color: const Color(0xff888888),
                  ),
                ),

                Text(
                  value.toString(),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xff202020),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // VIEWS-VS-PREVIOUS-PERIOD COMPARISON BANNER
  // ============================================================

  Widget _comparisonBanner() {
    final int previous = insights.previousPeriodViews ?? 0;
    final int current = insights.period.views;
    final int delta = current - previous;
    final double? percent = insights.viewsChangePercent;

    final bool isUp = delta >= 0;
    final Color changeColor =
        isUp ? const Color(0xff16A34A) : const Color(0xffDC2626);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: changeColor.withOpacity(.06),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isUp
                ? Icons.trending_up_rounded
                : Icons.trending_down_rounded,
            size: 15.sp,
            color: changeColor,
          ),

          SizedBox(width: 8.w),

          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 10.5.sp,
                  color: const Color(0xff444444),
                  height: 1.35,
                ),
                children: [
                  TextSpan(
                    text: "You received ".tr,
                  ),
                  TextSpan(
                    text:
                        '${delta.abs()} ${delta >= 0 ? "more".tr : "fewer".tr} views ',
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  TextSpan(
                    text: "than the previous period.".tr,
                  ),
                  if (percent != null)
                    TextSpan(
                      text: '  (${percent >= 0 ? "+" : ""}'
                          '${percent.toStringAsFixed(0)}%)',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: changeColor,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // VIEWS OVER TIME CHART
  // ============================================================

  Widget _viewsOverTimeCard() {
    final List<InsightPoint> points = insights.viewsTrend;

    final int maxViews = points
        .map((p) => p.views)
        .fold<int>(0, (max, v) => v > max ? v : max);

    final double maxY = maxViews == 0 ? 5 : (maxViews * 1.25);

    final int labelStep = (points.length / 5).ceil().clamp(1, 999);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(10.w, 14.h, 16.w, 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xffEAEAEA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: Text(
              "Views Over Time".tr,
              style: TextStyle(
                fontSize: 12.5.sp,
                fontWeight: FontWeight.w800,
                color: const Color(0xff1F1F1F),
              ),
            ),
          ),

          SizedBox(height: 14.h),

          SizedBox(
            height: 170.h,
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: (points.length - 1).clamp(0, 999999).toDouble(),
                minY: 0,
                maxY: maxY,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: (maxY / 4).clamp(1, double.infinity),
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: const Color(0xffEFEFEF),
                    strokeWidth: 1,
                  ),
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 26.w,
                      interval: (maxY / 4).clamp(1, double.infinity),
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(
                            fontSize: 8.5.sp,
                            color: const Color(0xff9A9A9A),
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22.h,
                      interval: labelStep.toDouble(),
                      getTitlesWidget: (value, meta) {
                        final int index = value.round();

                        if (index < 0 || index >= points.length) {
                          return const SizedBox.shrink();
                        }

                        return Padding(
                          padding: EdgeInsets.only(top: 6.h),
                          child: Text(
                            points[index].formattedPeriod,
                            style: TextStyle(
                              fontSize: 8.sp,
                              color: const Color(0xff9A9A9A),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (_) => primaryColor,
                    getTooltipItems: (spots) {
                      return spots.map((spot) {
                        final int index = spot.x.round();

                        final String period =
                            index >= 0 && index < points.length
                                ? points[index].formattedPeriod
                                : '';

                        return LineTooltipItem(
                          '$period\n${spot.y.toInt()} '
                          '${"views".tr}',
                          const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: points
                        .asMap()
                        .entries
                        .map(
                          (e) => FlSpot(
                            e.key.toDouble(),
                            e.value.views.toDouble(),
                          ),
                        )
                        .toList(),
                    isCurved: true,
                    curveSmoothness: .3,
                    color: primaryColor,
                    barWidth: 2.5,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          primaryColor.withOpacity(.22),
                          primaryColor.withOpacity(.02),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 6.h),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 11.sp,
                  color: const Color(0xffAAAAAA),
                ),

                SizedBox(width: 5.w),

                Expanded(
                  child: Text(
                    "Data is updated daily. All times are in your local timezone."
                        .tr,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 8.5.sp,
                      color: const Color(0xffAAAAAA),
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

  // ============================================================
  // EMPTY STATE
  // ============================================================

  Widget _emptyStateBanner() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(.06),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.insights_rounded,
            size: 16.sp,
            color: primaryColor,
          ),

          SizedBox(width: 10.w),

          Expanded(
            child: Text(
              "Insights will start appearing here once your property gets activity."
                  .tr,
              style: TextStyle(
                fontSize: 10.sp,
                color: const Color(0xff555555),
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
