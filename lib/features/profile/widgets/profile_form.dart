import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iot_flutter/features/profile/cubit/profile_cubit.dart';
import 'package:iot_flutter/features/profile/cubit/profile_state.dart';
import 'package:iot_flutter/features/profile/utils/dialog_utils.dart';

class ProfileForm extends StatefulWidget {
  const ProfileForm({super.key});

  @override
  State<ProfileForm> createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        } else if (state is ProfileLogoutSuccess) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      },
      builder: (context, state) {
        if (state is ProfileLoading || state is ProfileInitial) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is ProfileLoaded) {
          final user = state.user;
          if (_nameController.text != user.name) {
            _nameController.text = user.name;
          }
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.account_circle, size: 100),
                const SizedBox(height: 20),
                if (state.isEditing) ...[
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) {
                      context.read<ProfileCubit>()
                          .updateUserName(_nameController.text);
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          context.read<ProfileCubit>()
                              .updateUserName(_nameController.text);
                        },
                        child: const Text('Save'),
                      ),
                      const SizedBox(width: 10),
                      TextButton(
                        onPressed: () {
                          _nameController.text = user.name;
                          context.read<ProfileCubit>().toggleEdit(false);
                        },
                        child: const Text('Cancel'),
                      ),
                    ],
                  ),
                ] else ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Name: ${user.name}',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, size: 20),
                        onPressed: () {
                          context.read<ProfileCubit>().toggleEdit(true);
                        },
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 10),
                Text('Email: ${user.email}',
                    style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, '/home'),
                  child: Text('Go to Home Page',
                      style: Theme.of(context).textTheme.bodyMedium),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => showLogoutConfirmationDialog(context),
                  style: ElevatedButton
                      .styleFrom(backgroundColor: Colors.red.shade200),
                  child: Text('Logout',
                      style: Theme.of(context).textTheme.bodyMedium),
                ),
              ],
            ),
          );
        }
        if (state is ProfileError) {
          return Center(child: Text(state.message));
        }
        return const Center(child: Text('Unexpected error'));
      },
    );
  }
}
