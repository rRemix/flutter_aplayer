
import 'package:flutter/material.dart';

abstract class AbsLibrary extends StatefulWidget {
  const AbsLibrary({super.key});
}

abstract class AbsState<T extends AbsLibrary> extends State<T>{

  // @override
  // bool get wantKeepAlive => true;
}