
import 'package:flutter/material.dart';

void main() {
  runApp(const StudentManagementApp());
}

class StudentManagementApp extends StatelessWidget {
  const StudentManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Management App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F6FA),
      ),
      home: const SplashScreen(),
    );
  }
}

// STUDENT MODEL
class Student {
  final String name;
  final String enrollment;
  final String course;
  final String semester;

  const Student({
    required this.name,
    required this.enrollment,
    required this.course,
    required this.semester,
  });
}

// SPLASH SCREEN
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    openHomeScreen();
  }

  Future<void> openHomeScreen() async {
    await Future.delayed(const Duration(seconds: 10));

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 65,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.school,
                size: 75,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              'STUDENT MANAGEMENT',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Manage Student Information Easily',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 35),
            const CircularProgressIndicator(
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}

// HOME SCREEN WITH BOTTOM NAVIGATION
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  final List<Student> students = [];
  Student? selectedStudent;

  void addStudent(Student student) {
    setState(() {
      students.add(student);
      selectedStudent = student;
      selectedIndex = 2;
    });
  }

  void openStudentDetails(Student student) {
    setState(() {
      selectedStudent = student;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomePage(
        studentCount: students.length,
        onAddStudent: () {
          setState(() {
            selectedIndex = 1;
          });
        },
        onViewStudents: () {
          setState(() {
            selectedIndex = 2;
          });
        },
      ),
      StudentFormScreen(onSubmit: addStudent),
      StudentListScreen(
        students: students,
        selectedStudent: selectedStudent,
        onStudentTap: openStudentDetails,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Student Management',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: IndexedStack(
        index: selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_add_alt_1),
            label: 'Student Form',
          ),
          NavigationDestination(
            icon: Icon(Icons.groups_outlined),
            selectedIcon: Icon(Icons.groups),
            label: 'Student List',
          ),
        ],
      ),
    );
  }
}

// HOME PAGE
class HomePage extends StatelessWidget {
  final int studentCount;
  final VoidCallback onAddStudent;
  final VoidCallback onViewStudents;

  const HomePage({
    super.key,
    required this.studentCount,
    required this.onAddStudent,
    required this.onViewStudents,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          const Text(
            'Welcome!',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.indigo,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Student information at one place.',
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          const SizedBox(height: 25),
          Card(
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    child: Icon(Icons.school, size: 32),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total Students',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '$studentCount',
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 25),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onAddStudent,
              icon: const Icon(Icons.person_add),
              label: const Text('Add New Student'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onViewStudents,
              icon: const Icon(Icons.list_alt),
              label: const Text('View Student List'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// STUDENT FORM SCREEN
class StudentFormScreen extends StatefulWidget {
  final ValueChanged<Student> onSubmit;

  const StudentFormScreen({
    super.key,
    required this.onSubmit,
  });

  @override
  State<StudentFormScreen> createState() =>
      _StudentFormScreenState();
}

class _StudentFormScreenState extends State<StudentFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController =
  TextEditingController();
  final TextEditingController enrollmentController =
  TextEditingController();

  String? selectedCourse;
  String? selectedSemester;

  final List<String> courses = [
    'BCA',
    'BBA',
    'B.Com',
    'B.Sc',
    'MCA',
    'MBA',
  ];

  final List<String> semesters = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
  ];

  void submitForm() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final student = Student(
      name: nameController.text.trim(),
      enrollment: enrollmentController.text.trim(),
      course: selectedCourse!,
      semester: selectedSemester!,
    );

    widget.onSubmit(student);

    nameController.clear();
    enrollmentController.clear();

    setState(() {
      selectedCourse = null;
      selectedSemester = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Student added successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    enrollmentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add Student Details',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
            ),
            const SizedBox(height: 22),

            // STUDENT NAME
            TextFormField(
              controller: nameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Student Name',
                hintText: 'Enter student name',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter student name';
                }
                return null;
              },
            ),
            const SizedBox(height: 18),

            // ENROLLMENT NUMBER
            TextFormField(
              controller: enrollmentController,
              decoration: const InputDecoration(
                labelText: 'Enrollment Number',
                hintText: 'Enter enrollment number',
                prefixIcon: Icon(Icons.badge),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter enrollment number';
                }
                return null;
              },
            ),
            const SizedBox(height: 18),

            // COURSE
            DropdownButtonFormField<String>(
              value: selectedCourse,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Course',
                prefixIcon: Icon(Icons.menu_book),
                border: OutlineInputBorder(),
              ),
              items: courses.map((course) {
                return DropdownMenuItem<String>(
                  value: course,
                  child: Text(course),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCourse = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a course';
                }
                return null;
              },
            ),
            const SizedBox(height: 18),

            // SEMESTER
            DropdownButtonFormField<String>(
              value: selectedSemester,
              isExpanded: true,
              decoration: const InputDecoration(
                labelText: 'Semester',
                prefixIcon: Icon(Icons.calendar_month),
                border: OutlineInputBorder(),
              ),
              items: semesters.map((semester) {
                return DropdownMenuItem<String>(
                  value: semester,
                  child: Text('Semester $semester'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedSemester = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a semester';
                }
                return null;
              },
            ),
            const SizedBox(height: 28),

            // SUBMIT BUTTON
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: submitForm,
                icon: const Icon(Icons.save),
                label: const Text('Submit Student'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// STUDENT LIST AND DETAILS CARD
class StudentListScreen extends StatelessWidget {
  final List<Student> students;
  final Student? selectedStudent;
  final ValueChanged<Student> onStudentTap;

  const StudentListScreen({
    super.key,
    required this.students,
    required this.selectedStudent,
    required this.onStudentTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'Student List',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
              ),
              Chip(
                avatar: const Icon(Icons.people, size: 18),
                label: Text('${students.length} Students'),
              ),
            ],
          ),
        ),

        // DYNAMIC LISTVIEW
        Expanded(
          child: students.isEmpty
              ? const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.person_off_outlined,
                  size: 65,
                  color: Colors.grey,
                ),
                SizedBox(height: 12),
                Text(
                  'No students added yet.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          )
              : ListView.builder(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];

              return Card(
                margin: const EdgeInsets.symmetric(
                  vertical: 6,
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.indigo.shade100,
                    child: Text(
                      student.name[0].toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo,
                      ),
                    ),
                  ),
                  title: Text(
                    student.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    '${student.enrollment} • ${student.course}',
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                  ),
                  onTap: () => onStudentTap(student),
                ),
              );
            },
          ),
        ),

        // SELECTED STUDENT DETAILS CARD
        if (selectedStudent != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
            child: Card(
              color: Colors.indigo.shade50,
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.account_box,
                          color: Colors.indigo,
                          size: 28,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Student Details',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    detailRow('Name', selectedStudent!.name),
                    detailRow(
                      'Enrollment No.',
                      selectedStudent!.enrollment,
                    ),
                    detailRow('Course', selectedStudent!.course),
                    detailRow(
                      'Semester',
                      selectedStudent!.semester,
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 125,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
