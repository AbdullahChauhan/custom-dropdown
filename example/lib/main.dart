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
  final List<String> list = ['Developer', 'Designer', 'Consultant', 'Student'];
  final jobRoleDropdownCtrl = TextEditingController(),
      jobRoleFormDropdownCtrl = TextEditingController(),
      jobRoleSearchDropdownCtrl = TextEditingController(),
      jobRoleSearchRequestDropdownCtrl = TextEditingController();

  Future<List<String>> getFakeRequestData(String query) async {
    List<String> data = ['Developer', 'Designer', 'Consultant', 'Student'];

    return await Future.delayed(const Duration(seconds: 1), () {
      return data.where((e) {
        return e.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  void dispose() {
    jobRoleDropdownCtrl.dispose();
    jobRoleFormDropdownCtrl.dispose();
    jobRoleSearchDropdownCtrl.dispose();
    jobRoleSearchRequestDropdownCtrl.dispose();
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
            hintText: 'Select job role',
            items: list,
            controller: jobRoleDropdownCtrl,
            excludeSelected: false,
          ),
          const SizedBox(height: 24),
          const Divider(height: 0),
          const SizedBox(height: 24),

          // dropdown having search field
          const Text('Job Roles Search Dropdown', style: _labelStyle),
          const SizedBox(height: 8),
          CustomDropdown.search(
            hintText: 'Select job role',
            controller: jobRoleSearchDropdownCtrl,
            items: list,
          ),
          const SizedBox(height: 24),
          const Divider(height: 0),
          const SizedBox(height: 24),

          // dropdown having search request field (making fake call)
          const Text('Job Roles Search Request Dropdown', style: _labelStyle),
          const SizedBox(height: 8),
          CustomDropdown.searchRequest(
            futureRequest: getFakeRequestData,
            hintText: 'Search job role',
            controller: jobRoleSearchRequestDropdownCtrl,
            // waits 3 seconds before start searching (before execute the 'futureRequest' function)
            futureRequestDelay: const Duration(seconds: 3),
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
                CustomDropdown(
                  hintText: 'Select job role',
                  items: list,
                  controller: jobRoleFormDropdownCtrl,
                  excludeSelected: false,
                  listItemBuilder: (context, result) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text(result), const Icon(Icons.person)],
                    );
                  },
                ),
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
