import 'package:flutter/material.dart';
import '../../model/Achievement.dart';
import '../../model/User.dart';
import '../../model/UserStatistics.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int selectedAchievementIndex = 0;

  static User user = User('Name Surname', 'Description');

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
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
          _buildBottomButtons(context),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      leading: BackButton(),
      title: Text('Profile'),
      actions: [
        IconButton(icon: Icon(Icons.edit), onPressed: _goToEditProfile),
      ],
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  Widget _buildProfile(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
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
          Text(user.name, style: Theme.of(context).textTheme.headlineMedium),
          Text(user.description, style: Theme.of(context).textTheme.titleMedium),
        ]
      )
    );
  }

  Widget _buildStatisticsOverview(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 15, bottom: 10),
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

  Widget _buildBottomButtons(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
            leading: Icon(Icons.logout),
            title: Text('Sign Out'),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Future<void> _goToEditProfile() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => EditProfilePage(user: user))
    );

    if (result != null) {
      setState(() => user = result);
    }
  }
}
