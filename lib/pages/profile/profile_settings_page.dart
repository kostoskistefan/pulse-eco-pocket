import 'package:flutter/material.dart';
import 'package:pulse_eco_pocket/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pulse_eco_pocket/drivers/ai_interpreter.dart';

class ProfileSettingsPage extends StatefulWidget {
  final Function(bool) setSettingsPageActive;
  final User user;

  const ProfileSettingsPage({Key? key, required this.setSettingsPageActive, required this.user}) : super(key: key);

  @override
  State<ProfileSettingsPage> createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  @override
  void initState() {
    super.initState();
    _loadAsyncSettings();
  }

  void _loadAsyncSettings() async {
    await AIInterpreter.loadUrl();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).cardColor,
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
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
                    SizedBox(height: 40),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      initialValue: widget.user.name,
                      onChanged: (value) => widget.user.name = value,
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Description',
                        filled: true,
                        fillColor: Colors.white,
                        helperText: 'The description is public information. Make sure to not include any personal information.',
                        helperMaxLines: 2,
                      ),
                      initialValue: widget.user.description,
                      onChanged: (value) => widget.user.description = value,
                    ),
                    Divider(height: 60),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'AI Interpreter URL',
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      initialValue: AIInterpreter.URL,
                      onChanged: (value) {
                        AIInterpreter.setUrl(value);
                      },
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            TextButton.icon(
              icon: Icon(Icons.arrow_back),
              label: Text('Return'),
              iconAlignment: IconAlignment.start,
              onPressed: _saveAndReturn,
            ),
          ],
        ),
      ),
    );
  }

  void _saveAndReturn() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('user', widget.user.toJson());
    await AIInterpreter.setUrl(AIInterpreter.URL);
    widget.setSettingsPageActive(false);
  }
}
