class FormatUtils {
  static String formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)} M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)} K';
    } else {
      return number.toString();
    }
  }

  static String formatTimeAgo(String createdDateString) {
    try {
      final createdDate = DateTime.parse(createdDateString);
      final now = DateTime.now();
      final difference = now.difference(createdDate);

      if (difference.inDays >= 365) {
        final years = (difference.inDays / 365).floor();
        return '$years year${years > 1 ? 's' : ''} ago';
      } else if (difference.inDays >= 30) {
        final months = (difference.inDays / 30).floor();
        return '$months month${months > 1 ? 's' : ''} ago';
      } else if (difference.inDays >= 1) {
        return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
      } else if (difference.inHours >= 1) {
        return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
      } else if (difference.inMinutes >= 1) {
        return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
      } else {
        return 'just now';
      }
    } catch (e) {
      return createdDateString; // fallback nếu parse lỗi
    }
  }
}