import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:apptry1/features/create_join_room/create_room_page.dart';
import 'package:apptry1/features/create_join_room/join_room_page.dart';
import 'package:apptry1/design_system/text_styles.dart';
import 'package:apptry1/features/UnityLauncherPage.dart'; // Import Unity launcher page

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(top: 30),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              decoration: const BoxDecoration(
                color: Color(0xFF1E1E1E),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateRoomPage(),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Expanded(
                          flex: 6,
                          child: Image.asset(
                            "assets/create_meeting_vector.png",
                            fit: BoxFit.fill,
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Create Room",
                                style: AppTextStyles.large.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Create a unique room and invite others.",
                                style: AppTextStyles.regular.copyWith(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    color: Colors.white24,
                    thickness: 1,
                    height: 32,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JoinRoomPage(),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Expanded(
                          flex: 6,
                          child: Image.asset(
                            "assets/join_meeting_vector.png",
                            fit: BoxFit.fill,
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Join Room",
                                style: AppTextStyles.large.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Join a room created by your friend.",
                                style: AppTextStyles.regular.copyWith(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFBB86FC),
        child: const Icon(
          Icons.open_in_new,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const UnityLauncherPage(),
            ),
          );
        },
      ),
    );
  }
}
