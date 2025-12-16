// lib/pages/cgpa_calculator_page.dart
import 'package:flutter/material.dart';

// Mapping Letter Grade to Grade Point (GP)
const Map<String, double> gradePoints = {
  'A': 4.00,
  'A-': 3.70,
  'B+': 3.30,
  'B': 3.00,
  'B-': 2.70,
  'C+': 2.30,
  'C': 2.00,
  'C-': 1.70,
  'D+': 1.30,
  'D': 1.00,
  'F': 0.00,
  'W': 0.00, // Withdraw/Incomplete are typically non-GPA factors
  'I': 0.00,
};

class Course {
  String name;
  int creditHours;
  String grade;
  double gradePoint;

  Course(this.name, this.creditHours, this.grade, this.gradePoint);
}

class CGPACalculatorPage extends StatefulWidget {
  const CGPACalculatorPage({super.key});

  @override
  State<CGPACalculatorPage> createState() => _CGPACalculatorPageState();
}

class _CGPACalculatorPageState extends State<CGPACalculatorPage> {
  // Local storage is required for this, we will use an in-memory list for now
  final List<Course> _currentSemesterCourses = [];
  final TextEditingController _courseNameController = TextEditingController();
  int _selectedCreditHours = 3;
  String _selectedGrade = 'A';

  double _semesterGpa = 0.00;
  double _cumulativeGpa = 0.00; // Will require all past semester data

  void _addCourse() {
    if (_courseNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter a course name.")));
      return;
    }

    final newCourse = Course(
      _courseNameController.text,
      _selectedCreditHours,
      _selectedGrade,
      gradePoints[_selectedGrade] ?? 0.00,
    );

    setState(() {
      _currentSemesterCourses.add(newCourse);
      _courseNameController.clear();
      _calculateSGPA(); // Recalculate after adding
    });
    // TODO: Implement local storage saving (FR22)
  }

  void _calculateSGPA() {
    double totalPoints = 0;
    int totalCredits = 0;

    for (var course in _currentSemesterCourses) {
      if (course.grade != 'W' && course.grade != 'I' && course.grade != 'F') { // Exclude F, W, I from total credits for GPA calculation
          totalPoints += course.gradePoint * course.creditHours;
          totalCredits += course.creditHours;
      } else if (course.grade == 'F') {
          // F counts credit hours toward total attempted, but 0 points
          totalCredits += course.creditHours;
      }
    }

    double gpa = totalCredits > 0 ? (totalPoints / totalCredits) : 0.0;

    setState(() {
      _semesterGpa = double.parse(gpa.toStringAsFixed(2));
      // **Note on CGPA:** Calculating CGPA requires historical data (all semesters)
      // which is not available in this single-semester view. A proper
      // implementation needs a full `Semester` and `Course` data structure
      // that is fetched/stored locally or via Supabase.
      // For a placeholder, we'll assume CGPA is the same as SGPA for the current calculation.
      _cumulativeGpa = _semesterGpa; 
    });
  }


  @override
  Widget build(BuildContext context) {
    // UI based on image_b73268.png
    return Scaffold(
      appBar: AppBar(title: const Text("CGPA Calculator")),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // Course Input
                TextField(
                  controller: _courseNameController,
                  decoration: const InputDecoration(
                    labelText: "Course Name",
                    hintText: "e.g., Object Oriented Programming",
                  ),
                ),
                const SizedBox(height: 20),

                // Credit Hours Selector
                const Text("Credit Hours", style: TextStyle(fontSize: 16, color: Colors.white70)),
                Wrap(
                  spacing: 10.0,
                  children: [1, 2, 3, 4].map((hours) {
                    bool isSelected = _selectedCreditHours == hours;
                    return ChoiceChip(
                      label: Text('$hours'),
                      selected: isSelected,
                      selectedColor: const Color(0xFF4A90E2),
                      backgroundColor: Theme.of(context).cardColor,
                      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.white70),
                      onSelected: (selected) {
                        setState(() {
                          _selectedCreditHours = hours;
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),

                // Grade Selector
                const Text("Grade", style: TextStyle(fontSize: 16, color: Colors.white70)),
                Wrap(
                  spacing: 10.0,
                  runSpacing: 5.0,
                  children: gradePoints.keys.where((g) => g != 'W' && g != 'I').map((grade) {
                    bool isSelected = _selectedGrade == grade;
                    return ChoiceChip(
                      label: Text(grade),
                      selected: isSelected,
                      selectedColor: const Color(0xFF4A90E2),
                      backgroundColor: Theme.of(context).cardColor,
                      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.white70),
                      onSelected: (selected) {
                        setState(() {
                          _selectedGrade = grade;
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 30),

                // Add Course Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _addCourse,
                    child: const Text("Add Course", style: TextStyle(fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 30),
                
                const Text("Grade Scale Reference", style: TextStyle(fontSize: 16, color: Colors.white70)),
                const SizedBox(height: 10),

                // Course List Display
                ..._currentSemesterCourses.map((course) {
                  return ListTile(
                    title: Text(course.name),
                    subtitle: Text("${course.creditHours} Credit Hours"),
                    trailing: Text(
                      "${course.grade} (${course.gradePoint.toStringAsFixed(2)})",
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF4A90E2)),
                    ),
                    onLongPress: () {
                      // Option to delete
                      setState(() {
                        _currentSemesterCourses.remove(course);
                        _calculateSGPA();
                      });
                    },
                  );
                }).toList(),
              ],
            ),
          ),
          
          // Bottom GPA Display
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: const Border(top: BorderSide(color: Colors.white10)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Text("Semester GPA", style: TextStyle(color: Colors.white70)),
                    Text(
                      _semesterGpa.toStringAsFixed(2),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.greenAccent,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text("Cumulative GPA", style: TextStyle(color: Colors.white70)),
                    Text(
                      _cumulativeGpa.toStringAsFixed(2),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.greenAccent,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}