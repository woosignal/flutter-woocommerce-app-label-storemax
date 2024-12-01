import 'package:flutter/material.dart';
import '/bootstrap/app_helper.dart';
import '/resources/widgets/cached_image_widget.dart';

class StoreLogo extends StatelessWidget {
  const StoreLogo(
      {super.key,
      this.height = 100,
      this.width = 100,
      this.placeholder = const CircularProgressIndicator(),
      this.fit = BoxFit.contain,
      this.showBgWhite = true});

  final bool showBgWhite;
  final double height;
  final double width;
  final Widget placeholder;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
            color: showBgWhite ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(5)),
        child: CachedImageWidget(
          image: AppHelper.instance.appConfig!.appLogo,
          height: height,
          placeholder: SizedBox(height: height, width: width),
        ),
      );
}
