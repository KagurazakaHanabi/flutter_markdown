// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:io';

import 'package:flutter/widgets.dart';

typedef Widget ImageBuilder(Uri uri, String imageDirectory, double width, double height);

final ImageBuilder kDefaultImageBuilder = (
  Uri uri,
  String imageDirectory,
  double width,
  double height,
) {
  if (uri.scheme == 'http' || uri.scheme == 'https') {
    return Image.network(uri.toString(), width: width, height: height);
  } else if (uri.scheme == 'data') {
    return _handleDataSchemeUri(uri, width, height);
  } else if (uri.scheme == "resource") {
    return Image.asset(uri.path, width: width, height: height);
  } else {
    Uri fileUri = imageDirectory != null ? Uri.parse(imageDirectory + uri.toString()) : uri;
    if (fileUri.scheme == 'http' || fileUri.scheme == 'https') {
      return Image.network(fileUri.toString(), width: width, height: height);
    } else {
      return Image.file(File.fromUri(fileUri), width: width, height: height);
    }
  }
};

Widget _handleDataSchemeUri(Uri uri, final double width, final double height) {
  final String mimeType = uri.data.mimeType;
  if (mimeType.startsWith('image/')) {
    return Image.memory(
      uri.data.contentAsBytes(),
      width: width,
      height: height,
    );
  } else if (mimeType.startsWith('text/')) {
    return Text(uri.data.contentAsString());
  }
  return const SizedBox();
}