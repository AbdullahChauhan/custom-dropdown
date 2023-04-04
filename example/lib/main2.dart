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
      title: 'Fully customizable example',
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

class Job {
  String name;
  IconData icon;

  Job(this.name, this.icon);

  @override
  String toString() {
    return '$name';
  }
}

class _HomeState extends State<Home> {
  final formKey = GlobalKey<FormState>();

  final List<Job> list = [
    Job('Developer', Icons.developer_mode),
    Job('Designer', Icons.design_services),
    Job('Consultant', Icons.account_balance),
    Job('Student', Icons.school),
  ];

  final jobRoleSearchRequestDropdownCtrl = TextEditingController();

  Future<List<Job>> getFakeRequestData(String query) async {
    return await Future.delayed(const Duration(seconds: 1), () {
      return list.where((e) {
        return e.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  void dispose() {
    jobRoleSearchRequestDropdownCtrl.dispose();
    super.dispose();
  }

  //function to be called with every item how it's gona be sho in the dropdown list
  Widget listItemBuilder(BuildContext context, Job job) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(job.name),
        Icon(job.icon),
      ],
    );
  }

  //function to be called when a item is selected
  Widget selectedHeaderBuilder(BuildContext context, Job job) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(job.name),
      ],
    );
  }

  //function to be called when a item is selected
  Widget hintBuilder(BuildContext context, String hint) {
    return Row(
      children: [
        Text(hint),
        const Icon(Icons.question_mark),
      ],
    );
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
          'Fully customizable example',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // using form for validation
          Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Full customized', style: _labelStyle),
                const SizedBox(height: 8),
                CustomDropdown<Job>.search(
                  hintText: 'Select job role',
                  items: list,
                  onChanged: (value) {
                    print('changing value to: $value');
                  },
                  excludeSelected: false,
                  closedFillColor: Colors.pink,
                  expandedFillColor: Colors.red[900],
                  closedBorder: Border.all(
                    color: Colors.blue,
                    width: 2,
                  ),
                  closedBorderRadius: BorderRadius.circular(15),
                  expandedBorder: Border.all(
                    color: Colors.orangeAccent,
                    width: 5,
                  ),
                  expandedBorderRadius: BorderRadius.circular(5),
                  listItemBuilder: (context, result) => listItemBuilder(context, result),
                  headerBuilder: (context, result) => selectedHeaderBuilder(context, result),
                  hintBuilder: (context, result) => hintBuilder(context, result),
                  closedErrorBorder: Border.all(
                    color: Colors.blue,
                    width: 2,
                  ),
                  closedErrorBorderRadius: BorderRadius.circular(15),
                  expandedErrorBorder: Border.all(
                    color: Colors.blue,
                    width: 2,
                  ),
                  expandedErrorBorderRadius: BorderRadius.circular(15),
                  errorStyle: const TextStyle(
                    color: Colors.blue,
                    fontSize: 14,
                  ),
                  validateOnChange: false,
                  validator: (value) {
                    if (value == null) {
                      return "Must not be null";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                const Divider(height: 0),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      bool validation = formKey.currentState!.validate();
                      print('$validation');
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
