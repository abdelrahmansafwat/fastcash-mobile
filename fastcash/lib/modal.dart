import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ModalInsideModal extends StatelessWidget {
  final ScrollController scrollController;

  const ModalInsideModal({Key key, this.scrollController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        child: CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
          leading: Container(), middle: Text('Recent Transactions', style: TextStyle(color: Colors.white),), backgroundColor: Color.fromRGBO(30, 50, 250, 1),),
      child: SafeArea(
        bottom: false,
        child: ListView(
          shrinkWrap: true,
          controller: scrollController,
          physics: BouncingScrollPhysics(),
          children: ListTile.divideTiles(
              context: context,
              tiles: List.generate(
                5,
                (index) => ListTile(
                    title: Text('Item'),
                    onTap: () => showCupertinoModalBottomSheet(
                          expand: true,
                          isDismissible: false,
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder: (context, scrollController) =>
                              ModalInsideModal(
                                  scrollController: scrollController),
                        )),
              )).toList(),
        ),
      ),
    ));
  }
}