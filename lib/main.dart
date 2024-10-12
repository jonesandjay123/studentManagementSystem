import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  // 初始化 Hive
  await Hive.initFlutter();
  await Hive.openBox('studentsBox');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Management System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StudentListPage(),
    );
  }
}

class StudentListPage extends StatefulWidget {
  @override
  _StudentListPageState createState() => _StudentListPageState();
}

class _StudentListPageState extends State<StudentListPage> {
  late Box studentsBox;

  @override
  void initState() {
    super.initState();
    studentsBox = Hive.box('studentsBox');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('學生管理系統v0.0.10.12.555'),
      ),
      body: ValueListenableBuilder(
        valueListenable: studentsBox.listenable(),
        builder: (context, Box box, _) {
          if (box.values.isEmpty) {
            return const Center(child: Text('尚無學生資料'));
          } else {
            return ListView.builder(
              itemCount: box.length,
              itemBuilder: (context, index) {
                var student = box.getAt(index) as Map;
                return ListTile(
                  title: Text('學號: ${student['id']}'),
                  subtitle: Text('名稱: ${student['name']}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      _deleteStudent(index);
                    },
                  ),
                  onTap: () {
                    _showEditStudentDialog(
                        index, student['id'], student['name']);
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddStudentDialog(); // 點擊按鈕時新增學生
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // 新增學生資料
  void _addStudent(String studentId, String studentName) {
    final newStudent = {
      'id': studentId,
      'name': studentName.isNotEmpty ? studentName : '未設定'
    };
    studentsBox.add(newStudent); // 每次新增後保存到 Hive
  }

  // 刪除學生資料
  void _deleteStudent(int index) {
    studentsBox.deleteAt(index); // 每次刪除後保存更新
  }

  // 彈出對話框以新增學生
  void _showAddStudentDialog() {
    String studentId = '';
    String studentName = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('新增學生'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: '學號'),
                onChanged: (value) {
                  studentId = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: '名稱'),
                onChanged: (value) {
                  studentName = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                if (studentId.isNotEmpty) {
                  _addStudent(studentId, studentName);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('新增'),
            ),
          ],
        );
      },
    );
  }

  // 彈出對話框以編輯學生
  void _showEditStudentDialog(int index, String currentId, String currentName) {
    String studentId = currentId;
    String studentName = currentName;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('編輯學生'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: '學號'),
                controller: TextEditingController(text: currentId),
                onChanged: (value) {
                  studentId = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: '名稱'),
                controller: TextEditingController(text: currentName),
                onChanged: (value) {
                  studentName = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                if (studentId.isNotEmpty) {
                  _editStudent(index, studentId, studentName);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('保存'),
            ),
          ],
        );
      },
    );
  }

  // 編輯學生資料
  void _editStudent(int index, String studentId, String studentName) {
    final updatedStudent = {
      'id': studentId,
      'name': studentName.isNotEmpty ? studentName : '未設定'
    };
    studentsBox.putAt(index, updatedStudent); // 更新學生資料
  }
}
