import 'package:cyber_map/core/config/theme/app_colors.dart';
import 'package:cyber_map/core/presentation/widgets/components/container/app_container.dart';
import 'package:flutter/widgets.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    required this.controller,
    required this.hintText,
    required this.onChanged,
    super.key,
  });

  final TextEditingController controller;
  final String hintText;
  final Function(String) onChanged;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      child: SizedBox(
        height: 50,
        child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Stack(
            alignment: AlignmentDirectional.centerStart,
            children: [
              if (widget.controller.text.isEmpty)
                Text(
                  widget.hintText,
                  style: const TextStyle(
                    color: AppColors.grey,
                    fontSize: 40,
                  ),
                ),
              EditableText(
                controller: widget.controller,
                focusNode: _focusNode,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 40,
                ),
                cursorColor: AppColors.primaryAccent,
                backgroundCursorColor: AppColors.primaryAccent,
                onChanged: (value) {
                  widget.onChanged(value);
                  setState(() {});
                },
                minLines: 1,
                keyboardType: TextInputType.text,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
