import 'package:intl/intl.dart';

extension LastOnlineExtension on int {
  String toLastOnlineMessage() {
    DateTime currentTime = DateTime.now();
    DateTime lastOnline = DateTime.fromMillisecondsSinceEpoch(this);

    Duration difference = currentTime.difference(lastOnline);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return DateFormat('MMM d, yyyy').format(lastOnline);
    }
  }
}
