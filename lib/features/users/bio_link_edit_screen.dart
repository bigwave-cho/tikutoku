import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tiktok/features/users/view_models/users_view_model.dart';

class BioLinkEditScreen extends ConsumerStatefulWidget {
  const BioLinkEditScreen({super.key});

  @override
  ConsumerState<BioLinkEditScreen> createState() => _BioLinkEditScreenState();
}

class _BioLinkEditScreenState extends ConsumerState<BioLinkEditScreen> {
  late final TextEditingController _bioController;
  late final TextEditingController _linkController;
  @override
  void initState() {
    super.initState();
    _bioController =
        TextEditingController(text: ref.read(usersProvider).value!.bio);
    _linkController =
        TextEditingController(text: ref.read(usersProvider).value!.link);
  }

  void _updateBioAndProfile() {
    ref.read(usersProvider.notifier).onUpdateBioAndLink(
        bio: _bioController.text, link: _linkController.text);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _bioController,
            decoration: const InputDecoration(labelText: "Bio"),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _linkController,
            decoration: const InputDecoration(labelText: "Link"),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: _updateBioAndProfile,
            child: ElevatedButton(
              onPressed: _updateBioAndProfile,
              child: const Text('편집완료'),
            ),
          ),
        ],
      ),
    );
  }
}
