import 'dart:convert';
import 'dart:typed_data';

import 'package:cermath_app/common/style/style_text.dart';
import 'package:cermath_app/models/model_materi.dart';
import 'package:flutter/material.dart';

class HomepageDashboardWidget {
  StyleText styleText = new StyleText();

  Widget materi({required ModelMateri mteri, required BuildContext context}) {
    return (InkWell(
        onTap: () {
          if (mteri.namaMateri != "") {
            Navigator.pushNamed(
              context,
              '/listMateri',
              arguments: {
                'lessonId': mteri.idMateri,
                'lessonName': mteri.namaMateri
              },
            );
          }
        },
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 90,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.transparent),
              child: base64ToImage(base64: mteri.imageMateri),
            ),
            Container(
              alignment: Alignment.center,
              height: 50,
              child: Text(
                mteri.namaMateri,
                textAlign: TextAlign.center,
                style: styleText.openSansBold(
                    color: Colors.black87, size: 13.0, weightfont: false),
              ),
            )
          ],
        )));
  }

  Widget base64ToImage({required String base64}) {
    if (base64 != "") {
      final splitted = base64.split(',');
      Uint8List bytes = Base64Decoder().convert(splitted[1]);
      return Image.memory(bytes);
    } else {
      return Container();
    }
  }

  Widget splitMateri(
      {required List<ModelMateri> temp, required BuildContext context}) {
    return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: temp
            .map(
              (mteri) => Container(
                width: 90,
                height: 140,
                child: materi(mteri: mteri, context: context),
              ),
            )
            .toList());
  }

  Widget kategoriMateri(
      {required List<ModelMateri> listMateri, required BuildContext context}) {
    var tempMateri = [];
    var chunkSize = 3;
    for (var i = 0; i < listMateri.length; i += 3) {
      tempMateri.add(listMateri.sublist(
          i,
          i + chunkSize > listMateri.length
              ? listMateri.length
              : i + chunkSize));
    }

    return Container(
        child: Column(
            mainAxisSize: MainAxisSize.max,
            children: tempMateri
                .map((e) => Container(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: splitMateri(temp: e, context: context),
                    ))
                .toList()));
  }
}
