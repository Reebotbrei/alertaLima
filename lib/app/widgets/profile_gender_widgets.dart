import 'package:flutter/material.dart';
import 'package:alerta_lima/app/theme/app_colors.dart';
import 'package:alerta_lima/features/profile/viewmodel/profile_viewmodel.dart';

/// Widget para construir la sección de selección de género
class ProfileGenderSelection extends StatelessWidget {
  final ProfileViewmodel viewModel;
  const ProfileGenderSelection({Key? key, required this.viewModel})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Género *',
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(color: AppColors.text),
        ),
        const SizedBox(height: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const <Widget>[
            _ProfileGenderOption(gender: 'Masculino'),
            _ProfileGenderOption(gender: 'Femenino'),
          ],
        ),
      ],
    );
  }
}

class _ProfileGenderOption extends StatelessWidget {
  final String gender;
  const _ProfileGenderOption({Key? key, required this.gender})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel =
        (context.findAncestorWidgetOfExactType<ProfileGenderSelection>()
                as ProfileGenderSelection)
            .viewModel;
    return RadioListTile<String>(
      title: Text(
        gender,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: AppColors.text),
      ),
      value: gender,
      groupValue: viewModel.selectedGenero,
      onChanged: (String? value) {
        viewModel.selectedGenero = value;
      },
      activeColor: AppColors.primary,
      dense: true,
      contentPadding: EdgeInsets.zero,
    );
  }
}
