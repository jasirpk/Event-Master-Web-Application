import 'package:event_master_web/data_layer/auth_bloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController Controller;
  final String hintText;
  final bool obscureText;

  const TextFieldWidget({
    required this.Controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        String? errorText;
        if (state is TextInvalid) {
          errorText = state.message;
        }
        return TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onChanged: (text) {
            context.read<AuthBloc>().add(TextFieldTextChanged(text: text));
          },
          controller: Controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            enabledBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400)),
            fillColor: Colors.grey.shade200,
            filled: true,
            hintText: hintText,
            errorText: errorText,
            hintStyle: TextStyle(color: Colors.grey[500]),
          ),
          keyboardType: TextInputType.emailAddress,
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
          validator: (_) {
            if (state is TextInvalid) {
              return errorText;
            }
            return null;
          },
        );
      },
    );
  }
}
