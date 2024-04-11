import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surveillant/utils/shared.dart';
import 'package:toastification/toastification.dart';

void showToast(BuildContext context, String message, {Color color = blueColor}) {
  toastification.show(
    context: context,
    description: Text(message, style: GoogleFonts.itim(fontSize: 14, fontWeight: FontWeight.w500, color: color)),
    title: Text("Notification", style: GoogleFonts.itim(fontSize: 16, fontWeight: FontWeight.w500, color: color)),
    autoCloseDuration: 3.seconds,
  );
}
