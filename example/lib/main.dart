import 'package:custom_dropdown/custom_dropdown.dart';
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

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final formKey = GlobalKey<FormState>();
  final List<String> list = ['Developer', 'Designer', 'Consultant', 'Student'];
  final jobRoleCtrl = TextEditingController();
  final jobRoleFormCtrl = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    jobRoleCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const label = Text(
      'Job Role',
      style: TextStyle(fontWeight: FontWeight.w600),
    );

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.white),
        backgroundColor: Colors.white,
        elevation: .25,
        title: const Text(
          'Custom Dropdown Example',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            label,
            const SizedBox(height: 8),
            CustomDropdown(
              hintText: 'Select job role',
              items: list,
              controller: jobRoleCtrl,
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
                  label,
                  const SizedBox(height: 8),
                  CustomDropdown(
                    hintText: 'Select job role',
                    items: list,
                    controller: jobRoleFormCtrl,
                    excludeSelected: false,
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
            )
          ],
        ),
      ),
    );
  }
}
