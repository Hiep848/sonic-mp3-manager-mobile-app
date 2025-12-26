import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class CustomTextField extends HookWidget {
  final TextEditingController controller;
  final String label;
  final IconData? prefixIcon;
  final bool isPassword; // Thay obscureText bằng biến này để định danh
  final TextInputType keyboardType;
  final String? Function(String?)? validator; // Hàm kiểm tra lỗi
  final ValueChanged<String>? onChanged; // Để báo ra ngoài khi gõ

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.prefixIcon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // State để quản lý ẩn/hiện mật khẩu (chỉ dùng nội bộ widget này)
    final isObscure = useState(isPassword);

    return TextFormField(
      controller: controller,
      obscureText: isObscure.value,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  isObscure.value ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: () {
                  isObscure.value = !isObscure.value;
                },
              )
            : null,
      ),
    );
  }
}
