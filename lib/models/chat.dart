class Chat{
  String userId;
  String targetUserId;
  String userImage;
  String targetUserImage;
  int lastSeen;
  bool isTyping;

  Chat({
    required this.userId,
    required this.targetUserId,
    required this.userImage,
    required this.targetUserImage,
    required this.lastSeen,
    required this.isTyping});
}