import 'package:flutter/material.dart';
import '../../model/User.dart';

class EditProfilePage extends StatefulWidget {
  EditProfilePage({required this.user});

  User? user;

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Color(0xFF5d6163), width: 3),
              ),
              child: CircleAvatar(
                radius: 100,
                backgroundImage: AssetImage('assets/images/defaultUser.png')
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Full Name',
              ),
              initialValue: widget.user?.name,
              onChanged: (value) => widget.user?.name = value,
            ),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Description',
              ),
              initialValue: widget.user?.description,
              onChanged: (value) => widget.user?.description = value,
            ),
            SizedBox(height: 8),
            Text(
              'The description is public information. Make sure to not include any personal information.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ]
        )
      )
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      leading: BackButton(
        onPressed: () {
          Navigator.of(context).pop(widget.user);
        },
      ),
      title: Text('Edit Profile'),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }
}
