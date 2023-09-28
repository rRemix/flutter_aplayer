import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../abilities.dart';

abstract class AbsFragment extends StatelessWidget {
  const AbsFragment({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => Abilities(),
      child: Consumer<Abilities>(
        builder: (context, abilities, child) {
          return createChildWidget(abilities);
        },
      ),
    );
  }

  Widget createChildWidget(Abilities abilities);
}
