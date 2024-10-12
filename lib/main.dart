import 'package:flutter/material.dart';

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
  // 存儲學生資料的清單
  List<Map<String, String>> students = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('學生管理系統'),
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
                  students.removeAt(index); // 刪除學生資料
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
