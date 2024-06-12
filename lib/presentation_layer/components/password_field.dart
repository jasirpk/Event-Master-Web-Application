import 'package:event_master_web/data_layer/auth_bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;

  const PasswordField({
    super.key,
    required this.controller,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        String? errorText;
        if (state is passwordInvalid) {
          errorText = state.message;
        }
        bool isPasswordVisible = false;
        if (state is PasswordVisibilityToggled) {
          isPasswordVisible = state.isVisible;
        }
        return TextFormField(
          onChanged: (text) {
            context
                .read<AuthBloc>()
                .add(TextFieldPasswordChanged(password: text));
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: controller,
          obscureText: !isPasswordVisible,
          decoration: InputDecoration(
              suffixIcon: IconButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(TogglePasswordVisiblility());
                  },
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  )),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              fillColor: Colors.grey.shade200,
              filled: true,
              hintText: hintText,
              errorText: errorText,
              hintStyle: TextStyle(color: Colors.grey[500])),
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
          validator: (_) {
            if (state is passwordInvalid) {
              return errorText;
            }
            return null;
          },
        );
      },
    );
  }
}
