import 'package:animated_custom_dropdown_example/widgets/animated_dropdown.dart';
import 'package:animated_custom_dropdown_example/widgets/controller_validation_dropdown.dart';
import 'package:animated_custom_dropdown_example/widgets/feature_dropdowns.dart';
import 'package:animated_custom_dropdown_example/widgets/multi_select_controller_dropdown.dart';
import 'package:animated_custom_dropdown_example/widgets/decorated_dropdown.dart';
import 'package:animated_custom_dropdown_example/widgets/multi_select_dropdown.dart';
import 'package:animated_custom_dropdown_example/widgets/paginated_search_dropdown.dart';
import 'package:animated_custom_dropdown_example/widgets/search_dropdown.dart';
import 'package:animated_custom_dropdown_example/widgets/search_request_dropdown.dart';
import 'package:animated_custom_dropdown_example/widgets/simple_dropdown.dart';
import 'package:animated_custom_dropdown_example/widgets/validation_dropdown.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Custom Dropdown App',
      home: const Home(),
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.light,
          seedColor: Colors.blue,
          background: Colors.grey[200],
        ),
      ),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: const Text(
            'Custom Dropdown Example',
            style: TextStyle(color: Colors.white),
          ),
          bottom: const TabBar(
            isScrollable: true,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            labelStyle: TextStyle(fontSize: 18),
            unselectedLabelStyle: TextStyle(fontSize: 18),
            padding: EdgeInsets.all(2),
            tabs: [
              Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'Single selection',
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text('Multi selection'),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text("What's new (4.0.0)"),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                const SimpleDropdown(),
                const SizedBox(height: 16),
                const SearchDropdown(),
                const SizedBox(height: 16),
                const SearchRequestDropdown(),
                const SizedBox(height: 16),
                const DecoratedDropdown(),
                const SizedBox(height: 16),
                ValidationDropdown(),
                const SizedBox(height: 16),
                const ControllerValidationDropdown(),
              ],
            ),
            ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                const MultiSelectDropdown(),
                const SizedBox(height: 16),
                const MultiSelectSearchDropdown(),
                const SizedBox(height: 16),
                const MultiSelectSearchRequestDropdown(),
                const SizedBox(height: 16),
                const MultiSelectDecoratedDropdown(),
                const SizedBox(height: 16),
                MultiSelectValidationDropdown(),
                const SizedBox(height: 16),
                const MultiSelectControllerDropdown()
              ],
            ),
            ListView(
              padding: const EdgeInsets.all(16.0),
              children: const [
                _SectionLabel('Overlay animations'),
                AnimatedDropdown(),
                SizedBox(height: 16),
                _SectionLabel('Infinite scroll (pagination)'),
                PaginatedSearchDropdown(),
                SizedBox(height: 16),
                _SectionLabel('Floating label + clear'),
                LabelClearDropdown(),
                SizedBox(height: 16),
                _SectionLabel('Forced overlay direction'),
                DirectionDropdown(),
                SizedBox(height: 16),
                _SectionLabel('Text align'),
                AlignedDropdown(),
                SizedBox(height: 400),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      ),
    );
  }
}
