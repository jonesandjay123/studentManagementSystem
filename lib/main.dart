import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // 用於處理 JSON

void main() {
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
  List<Map<String, String>> students = [];

  @override
  void initState() {
    super.initState();
    _loadStudents(); // 應用啟動時加載數據
  }

  // 加載保存的學生資料
  void _loadStudents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? studentsJson = prefs.getString('students');
    if (studentsJson != null) {
      setState(() {
        students = List<Map<String, String>>.from(json.decode(studentsJson));
      });
    }
  }

  // 保存學生資料到 SharedPreferences
  void _saveStudents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String studentsJson = json.encode(students);
    await prefs.setString('students', studentsJson);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('學生管理系統v0.0.10.12.513'),
      ),
      body: ListView.builder(
        itemCount: students.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('學號: ${students[index]['id']}'),
            subtitle: Text('名稱: ${students[index]['name'] ?? '未設定'}'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  students.removeAt(index);
                  _saveStudents(); // 刪除後保存更新
                });
              },
            ),
          );
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
                  setState(() {
                    students.add({
                      'id': studentId,
                      'name': studentName.isNotEmpty ? studentName : '未設定'
                    });
                    _saveStudents(); // 新增後保存更新
                  });
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
