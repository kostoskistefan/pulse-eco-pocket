import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pulse_eco_pocket/model/User.dart';
import 'package:pulse_eco_pocket/model/Achievement.dart';
import 'package:pulse_eco_pocket/model/UserStatistics.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  int selectedAchievementIndex = 0;

  static User user = User('', '');

  static final UserStatistics statistics = UserStatistics(3, 13, 7);

  static final List<Achievement> achievements = [
    Achievement('First Scan', Icons.sensors, statistics.scans >= 1),
    Achievement('First Upload', Icons.cloud_upload, statistics.uploads >= 1),
    Achievement('10 Scans', Icons.sensors, statistics.scans >= 10),
    Achievement('10 Uploads', Icons.cloud_upload, statistics.uploads >= 10),
    Achievement('100 Scans', Icons.sensors, statistics.scans >= 100),
    Achievement('100 Uploads', Icons.cloud_upload, statistics.uploads >= 100),
    Achievement('500 Scans', Icons.sensors, statistics.scans >= 500),
    Achievement('500 Uploads', Icons.cloud_upload, statistics.uploads >= 500),
    Achievement('1000 Scans', Icons.sensors, statistics.scans >= 1000),
    Achievement('1000 Uploads', Icons.cloud_upload, statistics.uploads >= 1000),
  ];

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    final String? name = sharedPreferences.getString('name');
    final String? description = sharedPreferences.getString('description');

    if (name != null && description != null) {
      setState(() {
        user.name = name;
        user.description = description;
      });
    }

    else {
      setState(() {
        user.name = 'Name Surname';
        user.description = 'Description';
      });

      await sharedPreferences.setString('name', user.name);
      await sharedPreferences.setString('description', user.description);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: SafeArea(
                  child: Column(
                    children: [
                      _buildProfile(context),
                      _buildStatisticsOverview(context),
                      _buildAchievements(context),
                    ],
                  ),
                ),
              ),
            ),
            TextButton.icon(
              icon: Icon(Icons.logout, color: Colors.red),
              label: Text('Sign Out', style: TextStyle(color: Colors.red)),
              iconAlignment: IconAlignment.start,
              onPressed: () {},
            ),
          ],
          ),
          ),
          );
  }

  Widget _buildProfile(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(top: 25, left: 20, right: 20, bottom: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: Colors.grey[200],
          ),
          width: double.infinity,
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
              Column(
                children: [
                  Text(user.name, style: Theme.of(context).textTheme.headlineMedium),
                  Text(user.description, style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: IconButton(
            icon: Icon(Icons.edit),
            onPressed: _goToEditProfile,
          ),
        ),
      ],
    );
  }

  Widget _buildStatisticsOverview(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(100),
        ),
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            __buildStatistic(context, 'Sensors', statistics.sensors.toString()),
            __buildStatistic(context, 'Scans', statistics.scans.toString()),
            __buildStatistic(context, 'Uploads', statistics.uploads.toString()),
          ]
        )
      )
    );
  }

  Widget __buildStatistic(BuildContext context, String title, String value) {
    return Column(
      children: [
        Text(value, style: Theme.of(context).textTheme.headlineMedium),
        Text(title, style: Theme.of(context).textTheme.titleMedium),
      ]
    );
  }

  Widget _buildAchievements(BuildContext context) {
    return Column(
      children: [
        Text('Achievements', style: Theme.of(context).textTheme.headlineSmall),
        SizedBox(
          height: 200,
          child: PageView.builder(
            itemCount: achievements.length,
            controller: PageController(viewportFraction: 0.8),
            onPageChanged: (index) =>
            setState(() => selectedAchievementIndex = index),
            itemBuilder: (context, index) {
              return AnimatedPadding(
                duration: const Duration(milliseconds: 400),
                curve: Curves.fastOutSlowIn,
                padding: EdgeInsets.all(selectedAchievementIndex == index ? 0.0 : 8.0),
                child: Card(
                  color: achievements[index].isUnlocked ? Colors.green[100] : Colors.red[100],
                  child: _buildAchievement(context, achievements[index]),
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

  Future<void> _goToEditProfile() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => EditProfilePage(user: user))
    );

    if (result != null) {
      final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

      setState(() => user = result);

      await sharedPreferences.setString('name', result.name);
      await sharedPreferences.setString('description', result.description);
    }
  }
}
