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
          SimpleDropDown(),
          const SizedBox(height: 24),
          const Divider(height: 0),
          const SizedBox(height: 24),

          // dropdown having search field
          const Text('Job Roles Search Dropdown', style: _labelStyle),
          const SizedBox(height: 8),
          SearchDropDown(),
          const SizedBox(height: 24),
          const Divider(height: 0),
          const SizedBox(height: 24),

          // dropdown having search request field (making fake call)
          const Text('Job Roles Search Request Dropdown', style: _labelStyle),
          const SizedBox(height: 8),
          SearchRequestDropDown(),
          const SizedBox(height: 24),
          const Divider(height: 0),
          const SizedBox(height: 24),

          const Text(
            'Job Roles Dropdown with Form validation',
            style: _labelStyle,
          ),
          const SizedBox(height: 8),
          ValidationDropDown(),
          const SizedBox(height: 24),
          const Divider(height: 0),
          const SizedBox(height: 24),

          const Text(
            'Awful, but fully customized search request with validation',
            style: _labelStyle,
          ),
          const SizedBox(height: 8),
          FullyCustomizedDropDown(),
          const SizedBox(height: 340),
        ],
      ),
    );
  }
}

//START --------- Simple example of the drop down ---------\\
class SimpleDropDown extends StatelessWidget {
  final List<String> list = [
    'Developer',
    'Designer',
    'Consultant',
    'Student',
  ];

  SimpleDropDown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<String>(
      hintText: 'Select job role',
      items: list,
      selectedItem: list[0],
      excludeSelected: false,
      onChanged: (value) {
        print('changing value to: $value');
      },
    );
  }
}

//END --------- Simple example of the drop down ---------\\
//START --------- Search example of the drop down ---------\\
class Job with CustomDropdownListFilter {
  String name;
  IconData icon;

  Job(this.name, this.icon);

  @override
  String toString() {
    return '$name';
  }

  @override
  bool test(String query) {
    return name.contains(query);
  }
}

class SearchDropDown extends StatelessWidget {
  final List<Job> list = [
    Job('Developer', Icons.developer_mode),
    Job('Designer', Icons.design_services),
    Job('Consultant', Icons.account_balance),
    Job('Student', Icons.school),
  ];

  SearchDropDown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<Job>.search(
      hintText: 'Select job role',
      items: list,
      onChanged: (value) {
        print('changing value to: $value');
      },
      excludeSelected: true,
    );
  }
}
//END --------- Search example of the drop down ---------\\

//START --------- Search with request query example of the drop down ---------\\
class Pair {
  String text;
  IconData icon;

  Pair(this.text, this.icon);

  @override
  String toString() {
    return text;
  }
}

class SearchRequestDropDown extends StatelessWidget {
  final List<Pair> list = [
    Pair('Developer', Icons.developer_board),
    Pair('Designer', Icons.deblur_sharp),
    Pair('Consultant', Icons.money_off),
    Pair('Student', Icons.edit),
  ];

  Future<List<Pair>> getFakeRequestData(String query) async {
    return await Future.delayed(const Duration(seconds: 1), () {
      return list.where((e) {
        return e.text.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  SearchRequestDropDown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<Pair>.searchRequest(
      futureRequest: getFakeRequestData,
      hintText: 'Search job role',
      excludeSelected: true,
      items: list,
      onChanged: (value) {
        print('changing value to: $value');
      },
    );
  }
}

//END --------- Search with request query example of the drop down ---------\\

//START --------- Simple example of the drop down with validation ---------\\
class ValidationDropDown extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  String? selected = null;

  final List<String> list = [
    'Developer',
    'Designer',
    'Consultant',
    'Student',
  ];

  ValidationDropDown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
        // using form for validation
        Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomDropdown<String>(
            selectedItem: selected,
            hintText: 'Select job role',
            items: list,
            excludeSelected: false,
            validateOnChange: true,
            onChanged: (value) {
              selected = value;
            },
            validator: (value) {
              if (value == null) {
                return "Must not be null";
              }
              return null;
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
    );
  }
}

//END --------- Simple example of the drop down with validation ---------\\

//START --------- Fully customized example ---------\\
class FullyCustomizedDropDown extends StatelessWidget {
  FullyCustomizedDropDown({Key? key}) : super(key: key);
  final formKey = GlobalKey<FormState>();

  Job? selected = null;

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
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomDropdown<Job>.searchRequest(
            //logic
            futureRequest: getFakeRequestData,
            items: list,
            futureRequestDelay: const Duration(milliseconds: 150),
            onChanged: (value) {
              selected = value;
              print('changing value to: $value');
            },
            //personalization
            closedSuffixIcon: const Icon(Icons.account_balance),
            expandedSuffixIcon: const Icon(Icons.access_alarm),
            hintText: 'Select job role',
            excludeSelected: false,
            closedFillColor: Colors.pink,
            expandedFillColor: Colors.red[900],
            closedBorder: Border.all(
              color: Colors.black,
              width: 5,
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
              width: 10,
            ),
            closedErrorBorderRadius: BorderRadius.circular(15),
            expandedErrorBorder: Border.all(
              color: Colors.cyan,
              width: 10,
            ),
            expandedErrorBorderRadius: BorderRadius.circular(15),
            errorStyle: const TextStyle(
              color: Colors.deepPurple,
              fontSize: 18,
            ),
            validateOnChange: true,
            validator: (value) {
              if (value == null) {
                return "Must not be null";
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
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
    );
  }
}

//END --------- Fully customized example ---------\\
