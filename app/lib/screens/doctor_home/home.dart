import 'package:covmon/constants/colors.dart';
import 'package:covmon/constants/preferences.dart';
import 'package:covmon/constants/routes.dart';
import 'package:covmon/constants/socket.dart';
import 'package:covmon/constants/strings.dart';
import 'package:covmon/models/doctor.dart';
import 'package:covmon/models/patient.dart';
import 'package:covmon/provider/doctor.dart';
import 'package:covmon/provider/patient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'components/patient_vitals_list.dart';

class DoctorHomeScreen extends StatefulWidget {
  const DoctorHomeScreen({Key? key}) : super(key: key);

  @override
  _DoctorHomeScreenState createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  Map<String, Patient> patients = {};

  @override
  void initState() {
    SocketIO.connectToServer();
    super.initState();
  }

  @override
  void dispose() {
    SocketIO.socket.dispose();
    Token.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SocketIO.addEventListenerTo(
      context,
      Provider.of<Doctors>(context).currentDoctor.id,
    );
    patients = Provider.of<Patients>(context).patients;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(Strings.home),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              color: AppColors.grayWeb,
              onPressed: () {
                Token.reset();
                Doctor.currentDoctorId = Strings.empty;
                Navigator.pushReplacementNamed(context, Routes.select);
              },
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0.02.sw),
          child: patients.isEmpty
              ? const Text(Strings.noPatient)
              : ListView.builder(
                  itemCount: patients.length,
                  itemBuilder: (context, i) {
                    String patientId = patients.keys.elementAt(i);
                    return PatientVitals(patients[patientId]!);
                  },
                ),
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: Strings.patientSelect,
          backgroundColor: AppColors.primaryColor,
          onPressed: () {
            Navigator.pushNamed(context, Routes.patientSelect);
          },
          child: Icon(
            Icons.change_circle_outlined,
            size: 40.r,
            color: AppColors.backgroundColor,
          ),
        ),
      ),
    );
  }
}
