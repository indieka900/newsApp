import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:news_app/views/article.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';

import '../helper/news.dart';

final nowday = DateTime.now();
final format = DateFormat('h:mm a');
// format the time using the format object
String formattedTime = format.format(nowday);

class Blogtile extends StatefulWidget {
  final String imageUrl, title, desc, url, now, auther;

  const Blogtile({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.desc,
    required this.url,
    required this.now,
    required this.auther, //required this.hashed,
  });

  @override
  State<Blogtile> createState() => _BlogtileState();
}

class _BlogtileState extends State<Blogtile> {
  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateFormat("yyyy-MM-ddTHH:mm:ssZ").parse(widget.now);
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
                link: widget.url,
              );
            },
          ),
        );
      },
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                backgroundImage: AssetImage('assets/images/background.jpg'),
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectableText(
                    widget.auther,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 183, 243, 94),
                      fontSize: 18,
                      decoration: TextDecoration.underline,
                      decorationThickness: 1.2,
                      fontWeight: FontWeight.w700,
                      //decorationStyle: TextDecorationStyle.dashed,
                      decorationColor: Colors.white,
                    ),
                  ),
                  Text(
                    formattedDifference.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Stack(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: CachedNetworkImage(
                    imageUrl: widget.imageUrl,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          semanticsLabel: 'Loading\nPlease wait',
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                  // child: SizedBox(
                  //   child: BlurHash(
                  //     hash: 'LGF5]+Yk^6#M@-5c,1J5@[or[Q6.',
                  //     image: widget.imageUrl,
                  //     imageFit: BoxFit.cover,
                  //   ),
                  // ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(209, 0, 0, 0),
                        Color.fromARGB(185, 0, 0, 0),
                        Color.fromARGB(108, 15, 14, 14),
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 28.0,
                      bottom: 5,
                    ),
                    child: SizedBox(
                      child: SelectableText(
                        widget.title,
                        maxLines: null,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          SelectableText(
            widget.desc,
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
    );
  }
}
