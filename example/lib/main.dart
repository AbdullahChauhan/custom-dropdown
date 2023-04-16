import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Custom Dropdown App',
      home: Home(),
    );
  }
}

const _labelStyle = TextStyle(fontWeight: FontWeight.w600);

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final formKey = GlobalKey<FormState>();
  final List<Map<String, dynamic>> list = [
    {
      "id": 1,
      'name': {'ar': 'develperAr', 'en': 'develperEn'}
    },
    {
      "id": 2,
      'name': {'ar': 'enginnerAr', 'en': 'enginnerEn'}
    },
    {
      "id": 3,
      'name': {'ar': 'mechnaicAr', 'en': 'mechnaicEn'}
    },
    {
      "id": 4,
      'name': {'ar': 'driverAr', 'en': 'driverEn'}
    },
  ];
  final jobRoleDropdownCtrl = TextEditingController(),
      jobRoleFormDropdownCtrl = TextEditingController(),
      jobRoleSearchDropdownCtrl = TextEditingController();

  @override
  void dispose() {
    jobRoleDropdownCtrl.dispose();
    jobRoleFormDropdownCtrl.dispose();
    jobRoleSearchDropdownCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.white,
        ),
        backgroundColor: Colors.white,
        elevation: .25,
        title: const Text(
          'Custom Dropdown Example',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text('Job Roles Dropdown', style: _labelStyle),
          const SizedBox(height: 8),
          CustomDropdown(
            contentPadding: EdgeInsets.all(20),
            hintText: 'Select job role',
            hintStyle: TextStyle(fontSize: 20),
            excludeSelected: false,
            items: list,
            nameKey: "name",
            nameMapKey: 'en',
            onChanged: (value) {
              print('XXXXXXX${value}');
            },
            // excludeSelected: false,
          ),

          const SizedBox(height: 24),
          const Divider(height: 0),
          const SizedBox(height: 24),

          // dropdown having search field
          const Text('Job Roles Search Dropdown', style: _labelStyle),
          const SizedBox(height: 8),
          CustomDropdown.search(
            hintText: 'Select job role',
            excludeSelected: true,
            items: list,
            nameKey: "job",
            selectedValue: {"id": 3, 'job': 'Consultant'},
            onChanged: (value) {
              print('AAAAASASASASASASASASASASASSAS222${value}');
            },
          ),
          const SizedBox(height: 24),
          const Divider(height: 0),
          const SizedBox(height: 24),

          // using form for validation
          Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Job Roles Dropdown with Form validation',
                  style: _labelStyle,
                ),
                const SizedBox(height: 8),
                // CustomDropdown(
                //   hintText: 'Select job role',
                //   items: list,
                //   controller: jobRoleFormDropdownCtrl,
                //   excludeSelected: true,
                //   onChanged: (value) {
                //     print('AAAAASASASASASASASASASASASSAS3333333${value}');
                //   },
                // ),

                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (!formKey.currentState!.validate()) {
                        return;
                      }
                    },
                    child: const Text(
                      'Submit',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
