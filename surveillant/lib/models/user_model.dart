import 'package:flutter/material.dart';

@immutable
final class RdvModel {
  final String uid;
  final String username;
  final String phone;
  final String rdvID;
  final DateTime timestamp;
  final String description;

  const RdvModel({
    required this.uid,
    required this.username,
    required this.phone,
    required this.rdvID,
    required this.timestamp,
    required this.description,
  });

  factory RdvModel.fromJson(Map<String, dynamic> json) {
    return RdvModel(
      uid: json['uid'],
      username: json['username'],
      phone: json['phone'],
      rdvID: json['rdvID'],
      timestamp: json['timestamp'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'uid': uid,
        'username': username,
        'phone': phone,
        'rdvID': rdvID,
        'timestamp': timestamp.toIso8601String(),
        'description': description,
      };
}
