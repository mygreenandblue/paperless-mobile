import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PaperlessLogo extends StatelessWidget {
  static const _paperlessGreen = Color(0xFF18541F);
  final double? height;
  final double? width;
  final Color _color;

  const PaperlessLogo.white({
    super.key,
    this.height,
    this.width,
  }) : _color = Colors.white;

  const PaperlessLogo.green({super.key, this.height, this.width})
      : _color = _paperlessGreen;

  const PaperlessLogo.black({super.key, this.height, this.width})
      : _color = Colors.black;

  const PaperlessLogo.colored(Color color, {super.key, this.height, this.width})
      : _color = color;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: height ?? Theme.of(context).iconTheme.size ?? 32,
        maxWidth: width ?? Theme.of(context).iconTheme.size ?? 32,
      ),
      padding: const EdgeInsets.only(right: 8),
      child: SvgPicture.asset(
        "assets/logos/paperless_logo_white.svg",
        color: _color,
      ),
    );
  }
}
