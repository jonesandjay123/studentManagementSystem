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
        title: const Text('學生管理系統v0.0.10.12.530'),
      ),
      body: ValueListenableBuilder(
        valueListenable: studentsBox.listenable(),
        builder: (context, Box box, _) {
          if (box.values.isEmpty) {
            return Center(child: Text('尚無學生資料'));
          } else {
            return ListView.builder(
              itemCount: box.length,
              itemBuilder: (context, index) {
                var student = box.getAt(index) as Map;
                return ListTile(
                  title: Text('學號: ${student['id']}'),
                  subtitle: Text('名稱: ${student['name']}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _deleteStudent(index);
                    },
                  ),
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
        child: Icon(Icons.add),
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
          title: Text('新增學生'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: '學號'),
                onChanged: (value) {
                  studentId = value;
                },
              ),
              TextField(
                decoration: InputDecoration(labelText: '名稱'),
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
              child: Text('取消'),
            ),
            TextButton(
              onPressed: () {
                if (studentId.isNotEmpty) {
                  _addStudent(studentId, studentName);
                  Navigator.of(context).pop();
                }
              },
              child: Text('新增'),
            ),
          ],
        );
      },
    );
  }
}
