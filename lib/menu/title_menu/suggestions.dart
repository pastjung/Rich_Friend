import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

// Q&A : 개발자에게 요청사항을 보내는 공간
class Suggestions extends StatelessWidget {
  Suggestions({super.key});

  final String recipient = "chwogus33@naver.com";
  final _subjectController = TextEditingController();
  final _bodyController = TextEditingController();

  void sendEmail(BuildContext context) {
    final Email email = Email(
      recipients: [recipient],
      subject: _subjectController.text,
      body: _bodyController.text,
    );

    try {
      FlutterEmailSender.send(email);
      // 성공 시 알림창 표시
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('성공'),
            content: const Text('이메일 전송에 성공했습니다.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('확인'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      // 실패 시 알림창 표시
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('실패'),
            content: const Text('이메일 전송에 실패했습니다.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('확인'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade200,
        title: const Text(
          '개발자에게 건의하고 싶은 내용 혹은 버그제보 부탁드립니다.',
          style: TextStyle(fontSize: 15),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
            children: <Widget>[
              const Text(
                // 수정된 부분
                '받는 사람: 개발자',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _subjectController,
                decoration: const InputDecoration(labelText: '제목'),
              ),
              TextField(
                controller: _bodyController,
                decoration: const InputDecoration(
                  labelText: '내용',
                ),
                maxLines: 10,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () => sendEmail(context),
                child: const Text('이메일 보내기'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




/*
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

// Q&A : 개발자에게 요청사항을 보내는 공간
class Suggestions extends StatelessWidget {
  Suggestions({super.key});

  final String recipient = "chwogus33@naver.com";
  final _subjectController = TextEditingController();
  final _bodyController = TextEditingController();

  Future<void> sendEmail(BuildContext context) async {
    final Email email = Email(
      recipients: [recipient],
      subject: _subjectController.text,
      body: _bodyController.text,
    );

    try {
      await FlutterEmailSender.send(email);
      // 성공 시 알림창 표시
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('성공'),
            content: const Text('이메일 전송에 성공했습니다.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('확인'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      // 실패 시 알림창 표시
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('실패'),
            content: const Text('이메일 전송에 실패했습니다.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('확인'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade200,
        title: const Text(
          '개발자에게 건의하고 싶은 내용 혹은 버그제보 부탁드립니다.',
          style: TextStyle(fontSize: 15),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
            children: <Widget>[
              const Text(
                // 수정된 부분
                '받는 사람: 개발자',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _subjectController,
                decoration: const InputDecoration(labelText: '제목'),
              ),
              TextField(
                controller: _bodyController,
                decoration: const InputDecoration(
                  labelText: '내용',
                ),
                maxLines: 10,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () => sendEmail(context),
                child: const Text('이메일 보내기'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

*/