import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:news_app/views/article.dart';

class Blogtile extends StatelessWidget {
  final String imageUrl, title, desc, url, now;

  const Blogtile({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.desc,
    required this.url,
    required this.now,
  });

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateFormat("yyyy-MM-ddTHH:mm:ssZ").parse(now);
    // Calculate the difference between the current time and the parsed date
    Duration difference = DateTime.now().difference(dateTime);

    // Helper function to format a duration as a human-readable string
    String formatDuration(Duration duration) {
      if (duration.inSeconds < 60) {
        return "${duration.inSeconds} seconds ago";
      } else if (duration.inMinutes < 60) {
        return "${duration.inMinutes} minutes ago";
      } else if (duration.inHours < 24) {
        return "${duration.inHours} hours ago";
      } else {
        int days = duration.inDays;
        if (days == 1) {
          return "yesterday";
        } else if (days <= 7) {
          return "$days days ago";
        } else {
          return DateFormat("MMM d, y").format(dateTime);
        }
      }
    }

    // Format the difference as a human-readable string
    String formattedDifference = formatDuration(difference);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return WebViewApp(
                link: url,
              );
            },
          ),
        );
      },
      child: Container(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(imageUrl),
                    ),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),

                  // child: ClipRRect(
                  //   borderRadius: BorderRadius.circular(15),
                  //   child: Image.network(imageUrl),
                  // ),
                ),
                Positioned(
                  bottom: 10,
                  right: 30,
                  child: Text(
                    formattedDifference.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      backgroundColor: Colors.black45,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
                decoration: TextDecoration.underline,
                fontSize: 20,
              ),
            ),
            Text(
              desc,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
            const Divider(
              color: Colors.grey,
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
