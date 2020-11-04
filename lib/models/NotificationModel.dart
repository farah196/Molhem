
import 'package:flutter/material.dart';

@immutable
class NotificationModel {
  final String title;
  final String body;

  const NotificationModel({
    @required this.title,
    @required this.body,
  });
}