import 'package:flutter/material.dart';
import 'package:pulse_eco_pocket/model/User.dart';

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
      body: Padding(
        padding: EdgeInsets.only(top: 0, bottom: 20, left: 20, right: 20),
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: Colors.grey[200],
            ),
            width: double.infinity,
            padding: EdgeInsets.only(top: 25, left: 20, right: 20, bottom: 20),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Color(0xFF5d6163), width: 3),
                  ),
                  child: CircleAvatar(
                    radius: 100,
                    backgroundImage: AssetImage('assets/images/defaultUser.png'),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                  initialValue: widget.user?.name,
                  onChanged: (value) => widget.user?.name = value,
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Description',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    helperText: 'The description is public information. Make sure to not include any personal information.',
                    helperMaxLines: 2,
                  ),
                  initialValue: widget.user?.description,
                  onChanged: (value) => widget.user?.description = value,
                ),
              ],
            ),
          ),
        ),
      ),
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
