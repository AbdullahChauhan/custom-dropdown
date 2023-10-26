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
const List<String> _list = [
  'Developer',
  'Designer',
  'Consultant',
  'Student',
];
const List<Job> _jobItems = [
  Job('Developer', Icons.developer_mode),
  Job('Designer', Icons.design_services),
  Job('Consultant', Icons.account_balance),
  Job('Student', Icons.school),
];

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
          const SimpleDropDown(),
          const SizedBox(height: 24),
          const Divider(height: 0),
          const SizedBox(height: 24),

          // dropdown having search field
          const Text('Job Roles Search Dropdown', style: _labelStyle),
          const SizedBox(height: 8),
          const SearchDropDown(),
          const SizedBox(height: 24),
          const Divider(height: 0),
          const SizedBox(height: 24),

          // dropdown having search request field (making fake call)
          const Text('Job Roles Search Request Dropdown', style: _labelStyle),
          const SizedBox(height: 8),
          const SearchRequestDropDown(),
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

class SimpleDropDown extends StatelessWidget {
  const SimpleDropDown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<String>(
      hintText: 'Select job role',
      items: _list,
      initialItem: _list[0],
      excludeSelected: false,
      onChanged: debugPrint,
    );
  }
}

class Job with CustomDropdownListFilter {
  final String name;
  final IconData icon;

  const Job(this.name, this.icon);

  @override
  String toString() {
    return name;
  }

  @override
  bool test(String query) {
    return name.contains(query);
  }
}

class SearchDropDown extends StatelessWidget {
  const SearchDropDown({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<Job>.search(
      hintText: 'Select job role',
      items: _jobItems,
      excludeSelected: true,
      onChanged: (value) {
        debugPrint('changing value to: $value');
      },
    );
  }
}

class SearchRequestDropDown extends StatelessWidget {
  const SearchRequestDropDown({Key? key}) : super(key: key);

  Future<List<Job>> getFakeRequestData(String query) async {
    return await Future.delayed(const Duration(seconds: 1), () {
      return _jobItems.where((e) {
        return e.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<Job>.searchRequest(
      futureRequest: getFakeRequestData,
      hintText: 'Search job role',
      excludeSelected: true,
      items: _jobItems,
      onChanged: (value) {
        debugPrint('changing value to: $value');
      },
    );
  }
}

class ValidationDropDown extends StatelessWidget {
  ValidationDropDown({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomDropdown<String>(
            hintText: 'Select job role',
            items: _list,
            excludeSelected: false,
            validateOnChange: true,
            onChanged: debugPrint,
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
                if (!_formKey.currentState!.validate()) {
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

class FullyCustomizedDropDown extends StatelessWidget {
  FullyCustomizedDropDown({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  Future<List<Job>> _getFakeRequestData(String query) async {
    return await Future.delayed(const Duration(seconds: 1), () {
      return _jobItems.where((e) {
        return e.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  //function to be called with every item how it's gona be sho in the dropdown list
  Widget _listItemBuilder(BuildContext context, Job job) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [Text(job.name), Icon(job.icon)],
    );
  }

  //function to be called when a item is selected
  Widget _selectedHeaderBuilder(BuildContext context, Job job) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [Text(job.name)],
    );
  }

  //function to be called when a item is selected
  Widget _hintBuilder(BuildContext context, String hint) {
    return Row(
      children: [Text(hint), const Icon(Icons.question_mark)],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomDropdown<Job>.searchRequest(
            futureRequest: _getFakeRequestData,
            items: _jobItems,
            futureRequestDelay: const Duration(milliseconds: 150),
            onChanged: (value) {
              debugPrint('changing value to: $value');
            },
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
            listItemBuilder: _listItemBuilder,
            headerBuilder: _selectedHeaderBuilder,
            hintBuilder: _hintBuilder,
            closedErrorBorder: Border.all(color: Colors.blue, width: 10),
            closedErrorBorderRadius: BorderRadius.circular(15),
            expandedErrorBorder: Border.all(color: Colors.cyan, width: 10),
            expandedErrorBorderRadius: BorderRadius.circular(15),
            errorStyle: const TextStyle(color: Colors.deepPurple, fontSize: 18),
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
                if (!_formKey.currentState!.validate()) return;
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
