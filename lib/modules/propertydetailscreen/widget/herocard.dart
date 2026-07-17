import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:villas_qatar/modules/propertylist/model/myproperty_model.dart';

class HeroImageCard extends StatefulWidget {
  final Property property;

  const HeroImageCard({super.key, required this.property});

  @override
  State<HeroImageCard> createState() => _HeroImageCardState();
}

class _HeroImageCardState extends State<HeroImageCard> {
  final PageController _pageController = PageController();

  int currentPage = 0;
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final images = widget.property.photos;
    return Column(
      children: [
        SizedBox(
          height: 200.h,
          child: Stack(
            children: [
              /// PROPERTY IMAGE SLIDER
              ClipRRect(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: images.isEmpty ? 1 : images.length,
                  onPageChanged: (index) {
                    setState(() {
                      currentPage = index;
                    });
                  },
                  itemBuilder: (_, index) {
                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        images.isEmpty
                            ? Image.asset("assets/villa.jpg", fit: BoxFit.cover)
                            : Image.network(
                                images[index].url,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) {
                                  return Image.asset(
                                    "assets/villa.jpg",
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(.35),
                                Colors.transparent,
                                Colors.transparent,
                                Colors.black.withOpacity(.45),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              /// TOP BUTTONS
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 14.h,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _circleButton(
                        Icons.arrow_back_ios_new_rounded,
                        () => Navigator.pop(context),
                      ),

                      Row(
                        children: [
                          _circleButton(Icons.share_outlined, () {}),
                          SizedBox(width: 10.w),
                          _circleButton(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            () {
                              setState(() {
                                isFavorite = !isFavorite;
                              });
                            },
                            color: isFavorite ? Colors.red : Colors.white,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              /// Featured Badge
              Positioned(
                left: 15.w,
                top: 50.h,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xff8E123E),
                    borderRadius: BorderRadius.circular(30.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.15),
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.workspace_premium_rounded,
                        color: Colors.white,
                        size: 14.sp,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        "Featured",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// Image Counter
              Positioned(
                right: 20.w,
                bottom: 10.h,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(.55),
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.photo_library_outlined,
                        color: Colors.white,
                        size: 12.sp,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                       "${currentPage + 1}/${images.isEmpty ? 1 : images.length}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// Page Indicator
            ],
          ),
        ),
      ],
    );
  }

  Widget _circleButton(
    IconData icon,
    VoidCallback onTap, {
    Color color = Colors.black,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(30.r),
      onTap: onTap,
      child: Container(
        width: 30.w,
        height: 30.w,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(.20)),
        ),
        child: Icon(icon, color: color, size: 15.sp),
      ),
    );
  }
}
