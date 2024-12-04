import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pulse_eco_pocket/models/user.dart';
import 'package:pulse_eco_pocket/models/achievement.dart';

class ProfileViewPage extends StatefulWidget {
  final Function(bool) setSettingsPageActive;
  User user;

  ProfileViewPage({Key? key, required this.setSettingsPageActive, required this.user}) : super(key: key);

  @override
  _ProfileViewPageState createState() => _ProfileViewPageState();
}

class _ProfileViewPageState extends State<ProfileViewPage> {
  int selectedAchievementIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Column(
            children: [
              _buildProfile(context),
              const SizedBox(height: 10),
              Expanded(child: _buildAchievements(context)),
            ],
          ),
        ),
        _buildBottomBar(context),
      ],
    );
  }

  Widget _buildProfile(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 25, left: 20, right: 20, bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).cardColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
          Column(
            children: [
              Text(widget.user.name, style: Theme.of(context).textTheme.headlineMedium),
              Text(widget.user.description, style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              __buildStatistic(context, 'Sensors', widget.user.number_of_connected_sensors.toString()),
              __buildStatistic(context, 'Scans', widget.user.number_of_scans.toString()),
              __buildStatistic(context, 'Uploads', widget.user.number_of_uploads.toString()),
            ],
          ),
        ],
      ),
    );
  }

  Widget __buildStatistic(BuildContext context, String title, String value) {
    return Expanded(
        flex: 1,
        child: Column(
        children: [
          Text(value, style: Theme.of(context).textTheme.headlineMedium),
          Text(title, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }

  Widget _buildAchievements(BuildContext context) {
    return Column(
      children: [
        Text('Achievements', style: Theme.of(context).textTheme.headlineSmall),
        SizedBox(
          height: 200,
          child: PageView.builder(
            itemCount: widget.user.achievements.length,
            controller: PageController(viewportFraction: 0.8),
            onPageChanged: (index) =>setState(() => selectedAchievementIndex = index),
            itemBuilder: (context, index) {
              return AnimatedPadding(
                duration: const Duration(milliseconds: 400),
                curve: Curves.fastOutSlowIn,
                padding: EdgeInsets.all(selectedAchievementIndex == index ? 0.0 : 8.0),
                child: Card(
                  color: widget.user.achievements[index].isUnlocked ? Colors.green[100] : Colors.red[100],
                  child: _buildAchievement(context, widget.user.achievements[index]),
                  elevation: 0,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAchievement(BuildContext context, Achievement achievement) {
    String text_status = achievement.isUnlocked ? 'Unlocked' : 'Locked';
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(achievement.icon, size: 50),
          Text(achievement.name, style: Theme.of(context).textTheme.headlineMedium),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(achievement.isUnlocked ? Icons.lock_open : Icons.lock),
              SizedBox(width: 5),
              Text(text_status, style: Theme.of(context).textTheme.titleMedium),
            ]
          )
        ]
      )
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).cardColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton.icon(
            icon: Icon(Icons.logout, color: Colors.red),
            label: Text('Sign Out', style: TextStyle(color: Colors.red)),
            iconAlignment: IconAlignment.start,
            onPressed: () {},
          ),
          TextButton.icon(
            icon: Icon(Icons.settings),
            label: Text('Settings'),
            iconAlignment: IconAlignment.end,
            onPressed: () { widget.setSettingsPageActive(true); },
          ),
        ],
      ),
    );
  }

  Future<void> _loadUser() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    final String? user = await sharedPreferences.getString('user');

    if (user == null) {
      await sharedPreferences.setString('user', widget.user.toJson());
      return;
    }

    setState(() {
      widget.user = User.fromJson(user!);
    });
  }
}
