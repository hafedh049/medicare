import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:table_calendar/table_calendar.dart';

import '../utils/shared.dart';

class RendezVous extends StatefulWidget {
  const RendezVous({super.key});

  @override
  State<RendezVous> createState() => _RendezVousState();
}

class _RendezVousState extends State<RendezVous> {
  final TextEditingController _reasonController = TextEditingController();

  // ignore: unused_field
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDate = DateTime.now();

  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: scaffoldColor,
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 20),
              Row(
                children: <Widget>[
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(FontAwesome.chevron_left_solid, size: 20, color: blueColor)),
                  Text("Reclamation", style: GoogleFonts.itim(fontSize: 35, fontWeight: FontWeight.w500, color: blueColor)),
                ],
              ),
              const SizedBox(height: 20),
              TextField(controller: _reasonController, decoration: const InputDecoration(labelText: "Reason", hintText: "Why?")),
              const SizedBox(height: 20),
              Expanded(
                child: StatefulBuilder(
                  builder: (BuildContext context, void Function(void Function()) _) {
                    return TableCalendar(
                      selectedDayPredicate: (DateTime day) => isSameDay(_selectedDate, day),
                      onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
                        _(() {
                          _selectedDate = selectedDay;
                          _focusedDate = focusedDay;
                        });
                      },
                      calendarFormat: _calendarFormat,
                      onFormatChanged: (CalendarFormat format) => _(() => _calendarFormat = format),
                      onPageChanged: (DateTime focusedDay) => _(() => _focusedDate = focusedDay),
                      pageJumpingEnabled: true,
                      shouldFillViewport: true,
                      weekNumbersVisible: true,
                      focusedDay: DateTime.now(),
                      firstDay: DateTime(1960),
                      lastDay: DateTime(4000),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  width: MediaQuery.sizeOf(context).width * .6,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: blueColor),
                  child: Text("Demander", style: GoogleFonts.itim(fontSize: 18, fontWeight: FontWeight.w500, color: whiteColor)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
