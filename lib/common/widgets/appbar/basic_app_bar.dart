import 'package:flutter/material.dart';
import 'package:notspotify/common/helpers/is_dark_mode.dart';

class BasicAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final bool hideBack;
  final VoidCallback? onBack;

  const BasicAppBar({
    super.key,
    this.hideBack = false,
    this.title,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: title ?? const Text(''),
      automaticallyImplyLeading: false, // vì ta tự custom leading
      leading:
          hideBack
              ? null
              : IconButton(
                onPressed: onBack ?? () => Navigator.pop(context),
                icon: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color:
                        context.isDarkMode
                            ? Colors.white.withOpacity(0.03)
                            : Colors.black.withOpacity(0.04),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    size: 15,
                    color: context.isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
